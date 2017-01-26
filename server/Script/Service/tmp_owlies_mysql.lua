--- require "luasql.mysql"

luasql = require "luasql.mysql"
env = assert (luasql.mysql())
con = assert (env:connect("db_name","user_name","password","host_ip",port))

print(env,con)

cur,errorString = con:execute([[select * from user_account;]])
print(cur,errorString )

row = cur:fetch ({}, "a")

while row do
    print(string.format("Id: %s, Account: %s, Device: %s, FB: %s, Google: %s, Identifier: %s", row.user_id, row.account, row.device, row.facebook_account, row.google_play_account, row.identifier))
    row = cur:fetch (row, "a")
end

cur:close()
con:close()
env:close()
