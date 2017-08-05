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

    local success, result = S2cObjectBase.initialize(self);
    if success == false then
        print("Error: Failed to load login response for user " .. user_id);
        return;
    end

    if #result == 0 then
        self.energy = initialEnergy;
        S2cObjectBase.updateDB(self);
        return;
    end

    if #result ~= 1 then
        print("Error: Found two rows for user " .. user_id);
        return;
    end

    -- Should only have 1 row
    for index,row in pairs(result) do
        for columnName,value in pairs(row) do
            self[columnName] = value;
        end
    end
end

return loginResponseObject;