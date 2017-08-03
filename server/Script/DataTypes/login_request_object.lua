local c2sObjectBase = require "c2s_object_base"
local sprotoNames = require "sproto_names";

local loginRequestObject = {};
setmetatable(loginRequestObject, c2sObjectBase);
loginRequestObject.__index = loginRequestObject;

local _properties = {};
_properties = {};
_properties.timestamp = nil;
_properties.user_id = nil;
_properties.user_account = nil;
_properties.device_identifier = nil;
_properties.client_version = nil;
_properties.client_app_name = nil;

loginRequestObject.properties = _properties;

function loginRequestObject.getTableName()
    return "user_login";
end

function loginRequestObject.getSprotoName()
    return sprotoNames.LoginRequest;
end

function loginRequestObject.getPrimaryKeys()
    return {"user_id"};
end

function instantiate(sproto)
    local newInstance = c2sObjectBase:instantiate(sproto);
    setmetatable(newInstance, loginRequestObject)
    return newInstance;
end

function loginRequestObject:new(sproto)
    local instance = instantiate(sproto);
    local columnNames = instance:getColumnNames();
    loginRequestObject.columns = columnNames;
    return instance;
end

return loginRequestObject;