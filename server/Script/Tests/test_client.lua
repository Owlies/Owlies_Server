-- package.cpath = "luaclib/?.so"
-- package.path = "lualib/?.lua;examples/?.lua"

skynet_root = "./3rd/skynet/"
package.cpath = skynet_root.."luaclib/?.so;".."./Lib/?.so;"
package.path = skynet_root.."lualib/?.lua;" .. skynet_root .. "examples/?.lua;".."./Script/Lualib/?.lua;"

if _VERSION ~= "Lua 5.3" then
	error "Use lua 5.3"
end

local socket = require "clientsocket"
local proto = require "proto"
local sproto = require "sproto"
local print_r = require "print_r"

local host = sproto.new(proto.s2c):host "package"
local request = host:attach(sproto.new(proto.c2s))

local fd = assert(socket.connect("127.0.0.1", 8888))

require "owlies_sproto_scheme"
require "owlies_connection_manager"

local sp = sprotoSchemes:Instance().getScheme("Member");
local connectionManager = connectionManager:Instance();

local function send_package(fd)
	local person = sp;
	person.name = "Alice";
	person.id = 10000;
	person.phone = {number = "123456789", type = 1};

	local pack = connectionManager.Instance().serialize("Person", person);
	-- Insert messageType infront, 1 means messageType API call
	pack = string.char(1) .. pack;
	print(string.byte(pack, 1));
	local package = string.pack(">s2", pack);
	-- print(string.byte(package, 1) .. string.byte(package, 2) .. package);
	-- package = string.sub(package, 1, 1) .. string.char(string.byte(package, 2) + 10) .. string.sub(package, 3);
	package = string.char(string.byte(package, 1) + 10) .. string.sub(package, 2);
	-- print(string.byte(package, 1) .. string.byte(package, 2) .. package);
	print("send message to server");
	socket.send(fd, package)
end

local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
	-- print("Unpack_package from server");
	-- local size = #text;
	-- print(text);
	-- local obj = connectionManager.Instance().deserialize(text, size);
	-- print_r(obj);
	-- return obj;
end

local function recv_package(last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.recv(fd)
	if not r then
		return nil, last
	end
	if r == "" then
		error "Server closed"
	end
	return unpack_package(last .. r)
end

local session = 0

local function send_request(name, args)
	session = session + 1
	local str = request(name, args, session)
	send_package(fd, str)
	print("Request:", session)
end

local last = ""

local function print_request(name, args)
	print("REQUEST", name)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_response(session, args)
	print("RESPONSE", session)
	if args then
		for k,v in pairs(args) do
			print(k,v)
		end
	end
end

local function print_package(t, ...)
	if t == "REQUEST" then
		print_request(...)
	else
		assert(t == "RESPONSE")
		print_response(...)
	end
end

local function dispatch_package()
	while true do
		local v
		v, last = recv_package(last)
		if not v then
			break
		end

		print_package(host:dispatch(v))
	end
end

send_package(fd);
-- while true do
-- socket.usleep(1000);
-- end

-- send_request("handshake")
-- send_request("set", { what = "hello", value = "world" })
-- while true do
-- 	dispatch_package()
-- 	local cmd = socket.readstdin()
-- 	if cmd then
-- 		if cmd == "quit" then
-- 			send_request("quit")
-- 		else
-- 			send_request("get", { what = cmd })
-- 		end
-- 	else
-- 		socket.usleep(100)
-- 	end
-- end
