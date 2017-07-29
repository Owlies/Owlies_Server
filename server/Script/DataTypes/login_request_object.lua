require "object_base"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");
local sprotoNames = require "sproto_names";
require "owlies_connection_manager"

local _properties = {};
_properties.timestamp = nil;
_properties.user_id = nil;
_properties.user_account = nil;
_properties.device_identifier = nil;
_properties.client_version = nil;
_properties.client_app_name = nil;

local M = {properties = _properties};
setmetatable()

function M.getSprotoName()
    return sprotoNames.LoginRequest;
end

function M.new(sproto)
    print("loginRequestObject")
    for i,v in pairs(sproto) do
        M.properties[i] = v;
    end

    return M;
end

function M.toSproto()
    local sproto = sp:host(M.getSprotoName());
    for i,v in pairs(M.properties) do
        sproto[i] = v;
    end
    
    return sproto;
end

return M;