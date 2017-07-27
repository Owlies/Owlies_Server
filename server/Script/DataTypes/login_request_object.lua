local sp = sprotoSchemes:Instance().getScheme("Client2Server");
local sprotoNames = require "sproto_names";
require "owlies_connection_manager"

local properties = {};
properties.timestamp = nil;
properties.user_id = nil;
properties.user_account = nil;
properties.device_identifier = nil;
properties.client_version = nil;
properties.client_app_name = nil;

local M = {};

function M.getSprotoName()
    return sprotoNames.LoginRequest;
end

function M.new(sproto)
    print("loginRequestObject")
    for i,v in pairs(sproto) do
        properties[i] = v;
    end

    return M;
end

function M.toSproto()
    local sproto = sp:host(M.getSprotoName());
    for i,v in pairs(properties) do
        sproto[i] = v;
    end
    
    return sproto;
end

return M;