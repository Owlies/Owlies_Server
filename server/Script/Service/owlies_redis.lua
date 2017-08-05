local skynet = require "skynet"
require "skynet.manager"
local redis = require "redis"

local redisAddr = skynet.getenv("redisAddress");
local redisPort = skynet.getenv("redisPort");

local conf = {
	host = redisAddr ,
	port = redisPort
}

local Methods = {};
local redisContext = {};

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