local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local protobufLoader = require "protobufLoader"
local connectionManager = require('owlies_connectionManager')

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
	--local package = string.pack(">s2", pack)
	socket.write(client_fd, pack, sz)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
	    connectionManager.receive(msg, sz);
		return protobufLoader.unpack(msg, sz);
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
	-- host = protobufLoader.load(1):host "package"
	-- send_request = host:attach(protobufLoader.load(2))
	skynet.fork(function()
		while true do
		    local sz, pack = protobufLoader.pack("huayu");
			connectionManager.send(pack, sz);
			send_package(pack, sz);
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