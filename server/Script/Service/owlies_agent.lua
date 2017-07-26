local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"

require "owlies_sproto_scheme"
require "owlies_connection_manager"
local eMessageType = require "message_request_type"

local sp = sprotoSchemes:Instance().getScheme("Client2Server");
local connectionManager = connectionManager:Instance();

local WATCHDOG
local CMD = {}

local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		print("Unpack data from client");
		return connectionManager.Instance().deserialize(msg, sz);
	end,
	dispatch = function (_, _, sproto, clientSession, messageType, messageName)
		print("send message to client");
		local success = false;
		local response = nil;
		if messageType == eMessageType.ChangeEvent then
			success = pcall(skynet.call, "owlies_api", "lua", "receivedApiCall", client_fd, clientSession, messageType, messageName, sproto);
		elseif messageType == eMessageType.ApiCall then
			 success, response = pcall(skynet.call, "owlies_api", "lua", "receivedChangeEvent", client_fd, clientSession, messageType, messageName, sproto);
		end

		if not success then
			skynet.error("Process api call failed")
			skynet.error(response)
			response = pcall(skynet.call, "owlies_api", "lua", "syncError");
		end

		if success and response ~= nil then
			send_package(response);
		end
	end
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
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