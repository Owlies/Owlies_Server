local objectBase = {}

function objectBase:new(p, sproto)
    p = p or {}
    setmetatable(p, self)
    self.__index = self;

    for i,v in pairs(sproto) do
        p.properties[i] = v;
    end

    return p;
end

function objectBase:getSprotoName()
-- Must be implemented be child class
    return "";
end

function objectBase:toSproto()
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self.properties) do
        sproto[i] = v;
    end
    
    return sproto;
end

