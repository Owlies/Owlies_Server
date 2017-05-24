local usergameinfolib = require "dbobjusergameinfolib"
objUserGameInfo = usergameinfolib.new()

objUserGameInfo:setUserGameInfoUserId("uid_0523")
print ("The set UserId : uid_0523 and get UserId : " .. objUserGameInfo:getUserGameInfoUserId())

objUserGameInfo:setUserGameInfoLevel(9)
print ("The set Level : 9 and get Level : " .. objUserGameInfo:getUserGameInfoLevel())

objUserGameInfo:setUserGameInfoExp(99)
print ("The set Exp : 99 and get Exp : " .. objUserGameInfo:getUserGameInfoExp())

objUserGameInfo:setUserGameInfoGameVersion("music_run_v1.0")
print ("The set Game Version : music_run_v1.0 and get Game Version : " .. objUserGameInfo:getUserGameInfoGameVersion())

objUserGameInfo:setUserGameInfoLastLoginTime("2017-05-21")
print ("The set Last Login Time : 2017-05-21 and get Last Login Time : " .. objUserGameInfo:getUserGameInfoLastLoginTime())
