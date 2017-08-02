local objectBase = require "object_base"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

local c2sObjectBase = {}
setmetatable(c2sObjectBase, objectBase);
c2sObjectBase.__index = c2sObjectBase;

function c2sObjectBase:new(sproto)
    local newInstance = newInstance or {};
    newInstance.properties = newInstance.properties or {};

    setmetatable(newInstance, self)

    for i,v in pairs(sproto) do
        newInstance.properties[i] = v;
    end

    return newInstance;
end

function c2sObjectBase:toSproto()
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self.properties) do
        sproto[i] = v;
    end
    
    return sproto;
end

return c2sObjectBase;

