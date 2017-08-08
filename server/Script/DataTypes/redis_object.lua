local skynet = require "skynet"
local class = require "middleclass"
local ObjectBase = require "object_base"
local packer = require "packer"
local RedisObject = class("RedisObject", ObjectBase);

function RedisObject:initialize()
    print("RedisObject:initialize");
    ObjectBase.initialize(self);
    local success, result = RedisObject.loadRedisCache(self);
    if success then
        return result;
    end

    local suc, result = RedisObject.loadByPrimaryKeys(self);
    if suc == false then
        print("Error: Failed to load DB " .. redisKey);
        return nil;
    end

    if #result == 0 then
        return nil;
    end

    if #result ~= 1 then
        print("Error: Found more than one rows when loading DB " .. redisKey);
        return nil;
    end

    local valueTable = {};
    for index,row in pairs(result) do
        for columnName,value in pairs(row) do
            valueTable[columnName] = value;
        end
    end

    return valueTable;
end

function RedisObject:getRedisKey()
    local tableName = self:getTableName();
    local primaryKeys = self:getPrimaryKeys();

    local redisKey = tableName .. "_";
    for i,v in pairs(primaryKeys) do
        redisKey = redisKey .. self[v] .. "_";
    end

    return redisKey;
end

function RedisObject:loadRedisCache()
    local redisKey = RedisObject.getRedisKey(self);
    print("loadRedisCache: " .. redisKey);
    local success, json = pcall(skynet.call, "owlies_redis", "lua", "get", redisKey);
    local valueTable = {};

    if success == false then
        print("Error loading from redis, check redis connection!");
        return false, nil;
    end

    if json == nil then
        return false, nil;
    end

    print(json)
    local valueTable = packer.unpack(json);
    return true, valueTable;
end

function RedisObject:updateRedis()
    local redisKey = RedisObject.getRedisKey(self);
    local valueTable = {};

    for i,v in pairs(self) do
        if type(v) ~= "function" and i ~= "class" and i~= "columns" then
            valueTable[i] = v;
        end
    end

    local json = packer.pack(valueTable);
    local success = pcall(skynet.call, "owlies_redis", "lua", "set", redisKey, json);

    return success;
end

return RedisObject;