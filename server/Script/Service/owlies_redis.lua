local skynet = require "skynet"
require "skynet.manager"
require "hiredis_util"
local redisAddr = skynet.getenv("redisAddress");
local redisPort = skynet.getenv("redisPort");

local Methods = {};

local hiredisUtil = hiredisUtil:Instance();
local errorPrefix = "[RedisError] ";

local redis = require "hiredis"
require "owlies_sproto_scheme"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

-- FIXME: A better method name should be * createOrUpdateRedisSproto *
function Methods.updateRedisSproto(key, sprotoType, sproto)

    local success = hiredisUtil.setSproto(redisContext, key, sprotoType, sproto);
    if not success then
        print(errorPrefix .. "Failed to updateRedisSproto, " .. key .. ", " .. sprotoType);
    end

    return success;
end

function Methods.loadRedisSproto(key, sprotoType)

    local success, sproto = hiredisUtil.getSproto(redisContext, key, sprotoType);
    if not success then
        print(errorPrefix .. "Failed to loadRedisSproto, " .. key .. ", " .. sprotoType);
    end

    return success, sproto;
end

skynet.start(function()

    hiredisUtil.initRedisContext()

	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = Methods[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.register "owlies_redis"
end)
