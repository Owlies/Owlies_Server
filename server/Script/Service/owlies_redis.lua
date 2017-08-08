local skynet = require "skynet"
require "skynet.manager"
local redis = require "redis"

local redisAddr = skynet.getenv("redisAddress");
local redisPort = skynet.getenv("redisPort");

local conf = {
	host = redisAddr,
	port = redisPort
}

local Methods = {};
local redisContext = {};

function Methods.set(key, value)
	print("redis_set" .. key .. ", " .. value)
	redisContext:set(key, value);
end

function Methods.get(key)
	return redisContext:get(key);
end

function Methods.del(key)
	redisContext:del(key);
end

function Methods.exists(key)
	return redisContext:exists(key);
end

skynet.start(function()
    redisContext = redis.connect(conf);

	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = Methods[cmd]
		if f then
			skynet.ret(skynet.pack(f(...)))
		end
	end)

	skynet.register "owlies_redis"
end)