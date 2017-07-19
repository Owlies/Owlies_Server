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
    local sz = string.len(code);
    local res = redis.redisSetByteString(redisContext, key, code, sz);
end

function CMD.getSproto(key, sprotoType)
    reconnectIfNecessary();
    local value, sz = redis.redisGetByteString(redisContext, key);
    if value == nil then
        print("Can't find sproto for key " .. key);
        return nil;
    end

    return sp:decode(sprotoType, value, sz);
end

skynet.start(function()
    redisContext = redis.redisConnect(redisAddr, redisPort);

	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = CMD[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.register "owlies_redis"
end)