local skynet = require "skynet"
require "skynet.manager"
local physic = require "physic"
local dataTemplateProtobuf = require "dataTemplateProtobuf"
--local max_client = 64

skynet.start(function()
	print("game start")
	physic.testprint("a")
	local watchdog = skynet.newservice("owlies_watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
		--address = "192.168.0.107",
	})
end)