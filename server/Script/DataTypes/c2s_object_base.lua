local sp = sprotoSchemes:Instance().getScheme("Client2Server");

local objectBase = {}
objectBase.__index = objectBase;

function objectBase:new(sproto)
    local newInstance = newInstance or {};
    newInstance.properties = newInstance.properties or {};

    setmetatable(newInstance, self)

    for i,v in pairs(sproto) do
        newInstance.properties[i] = v;
    end

    return newInstance;
end

function objectBase:toSproto()
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self.properties) do
        sproto[i] = v;
    end
    
    return sproto;
end

return objectBase;

