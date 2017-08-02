local skynet = require "skynet"
require "skynet.manager"
local mysql = require "mysql"

local dbAddress = skynet.getenv("mysqlAddress");
local dbPort = skynet.getenv("mysqlPort");
local dbName = skynet.getenv("mysqlDB");
local dbUser = skynet.getenv("mysqlUser");
local dbPassword = skynet.getenv("mysqlPassword");

local db 
local Methods = {}

function Methods.query(sql)
	print("--- dbserver query:" .. sql)
	return db:query(sql)
end

skynet.start(function()
	skynet.dispatch("lua", function(session, address, cmd, ...)
		local f = Methods[cmd]
		skynet.ret(skynet.pack(f(...)))
	end)

	db = mysql.connect {
		host = dbAddress,
		port = dbPort,
		database = dbName,
		user = dbUser,
		password = dbPassword,
		max_packet_size = 1024 * 1024
	}

	if not db then
		print("failed to connect mysql")
	end

	skynet.register "db_service"
end)
		
