local class = require "middleclass"
local RedisObject = require "redis_object"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

local C2sObjectBase = class("C2sObjectBase", RedisObject);

function C2sObjectBase:initialize(sproto)
    print("C2sObjectBase:initialize")
    RedisObject.initialize(self);

    for i,v in pairs(sproto) do
        self[i] = v;
    end
end

-- Should exclude 'class', 'columns'
function C2sObjectBase:toSproto()
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self) do
        if type(v) ~= "function" and i ~= "class" and i~= "columns" then
            sproto[i] = v;
        end
    end

    return sproto;
end

return C2sObjectBase;

