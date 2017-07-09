### MySQL DB Service Model Usage

Sample code:

```
require "dbobjuseraccountlib"
local usergameinfolib = require "dbobjusergameinfolib"

local mysql_service_lib = require "owlies_mysql_service"

local mysql_client = {}

-- init the mysql_client
mysql_service_lib:create_mysql_connection( mysql_client )

-- execute sql
mysql_service_lib:create_new_database( mysql_client, "towergirl" )

-- use DB Object
objUserGameInfo = usergameinfolib.new()

objUserGameInfo:setUserGameInfoUserId("uid_0523")
objUserGameInfo:setUserGameInfoLevel(9)
objUserGameInfo:setUserGameInfoExp(99)
objUserGameInfo:setUserGameInfoGameVersion("music_run_v1.0")
objUserGameInfo:setUserGameInfoLastLoginTime("2017-05-21")

mysql_service_lib:add_new_user_game_info( mysql_client, objUserGameInfo )

--close connection

mysql_service_lib:close_mysql_connection( mysql_client )
```
