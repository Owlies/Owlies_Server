local skynet = require "skynet"
require "skynet.manager"
local print_r = require "print_r"
require "owlies_sproto_scheme"
require "owlies_connection_manager"

-- TODO(Huayu): Should contain Server2Clinet, but the test sproto is in Client2Server
local sp = sprotoSchemes:Instance().getScheme("Client2Server");
local connectionManager = connectionManager:Instance();

local CMD ={}

local function stubResponse()
	local person = sp;
	person.name = "Huayu";
	person.id = 5000;
	person.phone = {number = "222222", type = 3};
	return connectionManager.Instance().serialize("Person", person);
end

local function processApiCall(sproto)
	print_r(sproto);
	return stubResponse();
end

function CMD.receivedApiCall(sproto)
	print("---received api call---")
	return processApiCall(sproto)
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