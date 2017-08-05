local class = require "middleclass"
local RedisObject = require "redis_object"
local sp = sprotoSchemes:Instance().getScheme("Server2Client");

local S2cObjectBase = class("S2cObjectBase", RedisObject);

function S2cObjectBase:initialize()
    RedisObject.initialize(self);
    return RedisObject.loadByPrimaryKeys(self);
end

function S2cObjectBase:toSproto()
    return RedisObject.toSproto(self, sp);
end

-- Should exclude 'class', 'columns'
function S2cObjectBase:toSproto()
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self) do
        if type(v) ~= "function" and i ~= "class" and i~= "columns" then
            print(i)
            sproto[i] = v;
        end
    end

    return sproto;
end

return S2cObjectBase;

