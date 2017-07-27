local skynet = require "skynet"
require "skynet.manager"
local print_r = require "print_r"
require "owlies_sproto_scheme"
require "owlies_connection_manager"
local loginRequestObject = require "login_request_object"

-- TODO(Huayu): Should contain Server2Clinet, but the test sproto is in Client2Server
local sp = sprotoSchemes:Instance().getScheme("Client2Server");
local connectionManager = connectionManager:Instance();
local sprotoNames = require "sproto_names"

local CMD ={}
local networkSessionMap = {}

-- TODO(Huayu): Remove
local testKey = "huayu"

local function stubResponse()
	local person = sp:host "Person";
	person.name = "Huayu";
	person.id = 5000;
	person.phone = {number = "222222", type = 3};

	return connectionManager.Instance().serialize("Person", person, 100);
end

local function processApiCall(sproto, sprotoType)
	pcall(skynet.call, "owlies_redis", "lua", "updateRedisSproto", testKey, sprotoType, sproto);
	local success, obj = pcall(skynet.call, "owlies_redis", "lua", "loadRedisSproto", testKey, sprotoType);
	
	local dbobj = loginRequestObject.new(obj);
	local ssp = dbobj.toSproto();

	-- TODO(Huayu): Server session
	local dbobjSproto = connectionManager.Instance().serialize(dbobj.getSprotoName(), ssp, 100);
	print(dbobjSproto)
	return stubResponse();
end

function updateClientSession(clientFd, clientSession)
	local serverSession = networkSessionMap[clientFd];
	if serverSession ==nil or clientSession ~= serverSession + 1 then
		skynet.error("Missing sessions: client " .. clientFd .. ", clientSession " .. clientSession .. ", serverSession " .. networkSessionMap[clientFd]);
		return false;
	end
	networkSessionMap[clientFd] = clientSession;
	return true;
end

function syncError()
	-- TODO(Huayu): Implement
	return "syncError";
end

function clientDisconnect()
	networkSessionMap[clientFd] = nil;
end

function CMD.receivedApiCall(clientFd, clientSession, messageType, sprotoName, sproto)
	print("---received api call---")

	if sprotoNames.LoginRequest == sprotoName then
		networkSessionMap[clientFd] = clientSession;
	elseif not updateClientSession(clientFd, clientSession) then
		return nil;
	end		
	
	return processApiCall(sproto, sprotoName)
end

function CMD.receivedChangeEvent(clientFd, clientSession, messageType, messageName, sproto)
	print("---received change event call---")
	if not updateClientSession(clientFd, clientSession) then
		return nil;
	end	
	
	return nil;
end

skynet.start(function()
	print("---api start---")
	skynet.dispatch("lua", function(session, source, cmd, ...)
		print(session)
		local f = CMD[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.register "owlies_api"
end)