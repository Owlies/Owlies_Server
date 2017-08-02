local objectBase = {}
objectBase.__index = objectBase;

function objectBase:new(sproto)
    local newInstance = newInstance or {};
    newInstance.properties = newInstance.properties or {};
    setmetatable(newInstance, self)
    return newInstance;
end

function objectBase.insertOnDuplicate()
    print("insertOnDuplicate")
end

return objectBase;