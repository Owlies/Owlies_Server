require "dbobjuseraccountlib"
require "dbobjusergameinfolib"
--require "userGameInfoLib"

local msg = "Hello, world!"
print (msg)
-- return msg

local objUserAccount = dbobjuseraccountlib.new()

objUserAccount:setUserAccountUserId("uid_0523")
print (objUserAccount:getUserAccountUserId())

