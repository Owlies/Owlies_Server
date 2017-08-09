local skynet = require "skynet"
require "skynet.manager"
local print_r = require "print_r"
require "owlies_sproto_scheme"
require "owlies_connection_manager"
local loginRequestObject = require "login_request_object"
local loginResponseObject = require "login_response_object"

-- TODO(Huayu): Should contain Server2Clinet, but the test sproto is in Client2Server
local c2sSp = sprotoSchemes:Instance().getScheme("Client2Server");
local s2cSp = sprotoSchemes:Instance().getScheme("Server2Client");

local connectionManager = connectionManager:Instance();
local sprotoNames = require "sproto_names"

local CMD ={}
local networkSessionMap = {}

local function processApiCall(sproto, sprotoType)
	if sprotoType == sprotoNames.LoginRequest then
		local objb = loginRequestObject:new(sproto)
		objb:insertOnDuplicate();
		local sprotob = objb:toSproto();
		local response = loginResponseObject:new(objb.user_id);
		local responseSproto = response:toSproto();
		local result = connectionManager.Instance().serialize("LoginResponse", responseSproto, 100);
		return result;
	end
	return nil;
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
		return false, nil;
	end		
	
	return processApiCall(sproto, sprotoName)
end

function CMD.receivedChangeEvent(clientFd, clientSession, messageType, messageName, sproto)
	print("---received change event call---")
	if not updateClientSession(clientFd, clientSession) then
		return false;
	end	
	
	return true;
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