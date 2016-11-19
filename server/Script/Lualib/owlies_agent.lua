local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"

local sproto = require "sproto"
local print_r = require "print_r"

require "owlies_sproto_scheme"

local sp = sprotoSchemes:getInstance().getScheme("Member");

local WATCHDOG
local host
local sendRequest

local CMD = {}
local REQUEST = {}
local clientFd

function REQUEST:get()
	print("get", self.what)
	local r = skynet.call("SIMPLEDB", "lua", "get", self.what)
	return { result = r }
end

function REQUEST:set()
	print("set", self.what, self.value)
	local r = skynet.call("SIMPLEDB", "lua", "set", self.what, self.value)
end

function REQUEST:handshake()
	return { msg = "Welcome to skynet, I will send heartbeat every 5 sec." }
end

function REQUEST:quit()
	skynet.call(WATCHDOG, "lua", "close", client_fd)
end

local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(pack, sz)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, pack, sz)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		print("recive:");
		print(sz);
		local addr = sp:decode("Person", msg, sz)
		print("recive decoded:");
		print_r(addr);
		return addr;
	end,
	dispatch = function (_, _, type, ...)
		-- if type == "REQUEST" then
		-- 	local ok, result  = pcall(request, ...)
		-- 	if ok then
		-- 		if result then
		-- 			send_package(result)
		-- 		end
		-- 	else
		-- 		skynet.error(result)
		-- 	end
		-- else
		-- 	assert(type == "RESPONSE")
		-- 	error "This example doesn't support request client"
		-- end
	end
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- slot 1,2 set at main.lua
	skynet.fork(function()
		while true do
		    local person = sp;
			person.name = "Alice";
			person.id = 10000;
			person.phone = {number = "123456789", type = 2};
			local code = sp:encode("Person", person);
			send_package(code);
			skynet.sleep(500);
		end
	end)

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)