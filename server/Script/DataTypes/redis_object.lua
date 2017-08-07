local skynet = require "skynet"
local class = require "middleclass"
local ObjectBase = require "object_base"
local packer = require "packer"
local RedisObject = class("RedisObject", ObjectBase);

function RedisObject:initialize()
    print("RedisObject:initialize");
    return ObjectBase.initialize(self);
end

function RedisObject:getRedisKey()
    local primaryKeys = self:getPrimaryKeys();

    local redisKey = "";
    for i,v in pairs(primaryKeys) do
        redisKey = redisKey .. self[v].."_";
    end

    return redisKey;
end

function RedisObject:loadRedisCache()

end

function RedisObject:updateRedis()
    local redisKey = RedisObject.getRedisKey(self);
    local valueTable = {};

    for i,v in pairs(self) do
        if type(v) ~= "function" then
            valueTable[i] = v;
        end
    end

    local json = packer.pack(valueTable);
    print(json)
end

return RedisObject;