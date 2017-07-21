local useraccountlib = require "dbobjuseraccountlib"
objUserAccount = useraccountlib.new()

objUserAccount:setUserAccountUserId("uid_0523")
print ("The set UserId : uid_0523 and get UserId : " .. objUserAccount:getUserAccountUserId())

objUserAccount:setUserAccountAccount("music_run_0523")
print ("The set Account : music_run_0523 and get Account : " .. objUserAccount:getUserAccountAccount())

objUserAccount:setUserAccountDevice("Android Nexus 6")
print ("The set Device : Android Nexus 6 and get Device : " .. objUserAccount:getUserAccountDevice())

objUserAccount:setUserAccountFacebookAccount("https://www.facebook.com/johnson.green.338")
print ("The set FacebookAccount : https://www.facebook.com/johnson.green.338 and get FacebookAccount : " .. objUserAccount:getUserAccountFacebookAccount())

objUserAccount:setUserAccountGooglePlayAccount("https://plus.google.com/u/0/+JohnsonGreen")
print ("The set GooglePlayAccount : https://plus.google.com/u/0/+BaichuanYANG and get GooglePlayAccount : " .. objUserAccount:getUserAccountGooglePlayAccount())

objUserAccount:setUserAccountIdentifier("music_run_uid_0523")
print ("The set Identifier : music_run_uid_0523 and get Identifier : " .. objUserAccount:getUserAccountIdentifier())

print ("The returned Redis Item Key : "..objUserAccount:getUserAccountRedisItemKey());

print ("The returned Redis Item Value : "..objUserAccount:getUserAccountRedisItemValue());

objUserAccount_second = useraccountlib.new()

objUserAccount_second:setUserAccountUserId("uid_0717")
print ("For second object : The set UserId : uid_0717 and get UserId : " .. objUserAccount_second:getUserAccountUserId())

print ("For first object : The set UserId : uid_0523 and get UserId : " .. objUserAccount:getUserAccountUserId())

