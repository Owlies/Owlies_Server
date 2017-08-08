local class = require "middleclass"
local S2cObjectBase = require "s2c_object_base"
local sprotoNames = require "sproto_names";

local loginResponseObject = class("S2cObjectBase", S2cObjectBase);
loginResponseObject.user_id = nil;
loginResponseObject.energy = nil;

local initialEnergy = 10;

function loginResponseObject:getTableName()
    return "user_energy";
end

function loginResponseObject:getSprotoName()
    return sprotoNames.LoginResponse;
end

function loginResponseObject:getPrimaryKeys()
    return {"user_id"};
end

function loginResponseObject:initialize(user_id)
    print("loginResponseObject:initialize")
    self.user_id = user_id;

    local result = S2cObjectBase.initialize(self);
    if result == nil then
        print("Failed to load object from " .. loginResponseObject:getTableName() .. ", user_id " .. user_id);
        return nil;
    end

    for i,v in pairs(result) do
        self[i] = v;
    end
end

return loginResponseObject;