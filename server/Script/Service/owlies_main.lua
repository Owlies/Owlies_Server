local skynet = require "skynet"
require "skynet.manager"
local physic = require "physic"
--local max_client = 64
local redis = require "hiredisExample"

skynet.start(function()
	physic.testprint("a")
	redis.connectRedis("127.0.0.1", 6379);

	skynet.newservice("owlies_api")

	local watchdog = skynet.newservice("owlies_watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
		--address = "192.168.0.107",
	})

	skynet.exit();
end)