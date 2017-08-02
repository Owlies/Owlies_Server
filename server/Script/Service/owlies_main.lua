local skynet = require "skynet"
require "skynet.manager"
local physic = require "physic"
--local max_client = 64

skynet.start(function()
	physic.testprint("a")

	skynet.uniqueservice("owlies_redis")
	skynet.newservice("owlies_api")
	skynet.newservice("db_service")

	local watchdog = skynet.newservice("owlies_watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
		--address = "192.168.0.107",
	})
	
	skynet.exit();
end)