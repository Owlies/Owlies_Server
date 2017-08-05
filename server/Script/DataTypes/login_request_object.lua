local class = require "middleclass"
local C2sObjectBase = require "c2s_object_base"
local sprotoNames = require "sproto_names";

local LoginRequestObject = class("LoginRequsetObject", C2sObjectBase);
LoginRequestObject.timestamp = nil;
LoginRequestObject.user_id = nil;
LoginRequestObject.user_account = nil;
LoginRequestObject.device_identifier = nil;
LoginRequestObject.client_version = nil;
LoginRequestObject.client_app_name = nil;

function LoginRequestObject:getTableName()
    return "user_login";
end

function LoginRequestObject:getSprotoName()
    return sprotoNames.LoginRequest;
end

function LoginRequestObject:getPrimaryKeys()
    return {"user_id"};
end

function LoginRequestObject:initialize(sproto)
    print("LoginRequestObject:initialize")
    C2sObjectBase.initialize(self, sproto);
end

return LoginRequestObject;