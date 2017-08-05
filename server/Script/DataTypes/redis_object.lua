local skynet = require "skynet"
local class = require "middleclass"

local ObjectBase = require "object_base"

local RedisObject = class("RedisObject", ObjectBase);

function RedisObject:initialize()
    print("RedisObject:initialize");
    return ObjectBase.initialize(self);
end

function RedisObject:getRedisKey()
    local primaryKeys = self:getPrimaryKeys();

    local redisKey = nil;
    for i,v in primaryKeys do
        redisKey = redisKey .. v;
    end

    return redisKey;
end

function RedisObject:seralizeProperties()
    
end

function RedisObject:loadRedisCache()

end

function RedisObject:updateRedis()
    local redisKey = getRedisKey();

end

return RedisObject;