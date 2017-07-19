local skynet = require "skynet"
require "skynet.manager"
local redis = require "hiredis"
local redisAddr = skynet.getenv("redisAddress");
local redisPort = skynet.getenv("redisPort");

require "owlies_sproto_scheme"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");


local CMD = {}
local redisContext;

function checkConnection()
    if redis.redisPing(redisContext) == 0 then
        return false;
    end
    return true;
end

function reconnectIfNecessary()
    if checkConnection == 0 then
        redisContext = redis.redisConnect(redisAddr, redisPort);
    end
end

function CMD.checkConnection()
    return checkConnection();
end

function CMD.setSproto(key, sprotoType, sproto)
    reconnectIfNecessary();
    local code = sp:encode(sprotoType, sproto);
    local res = redis.redisSetString(redisContext, key, code);
end

function CMD.getSproto(key, sprotoType)
    reconnectIfNecessary();
    local value = redis.redisGetString(redisContext, key);
    local sproto = sp:decode(sprotoType, value, strlen(value));
    return sproto;
end

skynet.start(function()
    reconnectIfNecessary();

	skynet.dispatch("lua", function(session, source, cmd, ...)
		print(session)
		local f = CMD[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.register "owlies_redis"
end)