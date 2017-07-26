local redis = require "hiredis"

require "owlies_sproto_scheme"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

hiredisUtil = {};
local redisContext = {};
local _redisAddr, _redisPort;
local _instance;
 
function hiredisUtil.Instance()
    if not _instance then
        _instance = sprotoSchemes;
    end

    _instance.initRedisContext = function(redisAddr, redisPort)
        return initRedisContext()
    end
 
    _instance.checkConnection = function()
        return checkConnection();
    end

    _instance.reconnectIfNecessary = function( redisAddr, redisPort)
        return reconnectIfNecessary(redisContext, redisAddr, redisPort);
    end

    _instance.setSproto = function( key, sprotoType, sproto)
        return setSproto(redisContext, key, sprotoType, sproto);
    end

    _instance.getSproto = function( key, sprotoType)
        return getSproto(redisContext, key, sprotoType);
    end
 
    return _instance
end

function hiredisUtil:new()
    print('Singleton [hiredisUtil] cannot be instantiated - use Instance() instead');
end

-- TODO: A better way to ensure that a redisContext is singleton is to create a factory class/object 
-- that returns only one redisContext reference.
-- But it may have some conflicts with the exsiting retry mechanism.
function initRedisContext(redisAddr, redisPort)
    local connected, redisC = reconnectIfNecessary( redisAddr, redisPort);
    if not connected then
        print(errorPrefix .. "Failed to updateRedisContext");
        return false;
    end

    redisContext = redisC;
    _redisAddr = redisAddr;
    _redisPort = redisPort;
end

function checkConnection()
    return redis.isRedisConnected(redisContext);
end

function reconnectIfNecessary( redisAddr, redisPort )
    if not checkConnection() then
        local success, redisC = redis.connectWithRetry(redisAddr, redisPort);
        if success == false then
            return false, redisC;
        end
    end

    return true, redisContext;
end

function setSproto( key, sprotoType, sproto)
    local success, redisC = reconnectIfNecessary( _redisAddr, _redisPort );

    if not success then
        print("Failed to reconnect to redis server.");
        return false;
    end

    redisContext = redisC;

    local code = sp:encode(sprotoType, sproto);
    local sz = string.len(code);
    
    local res = redis.redisSetByteString(redisContext, key, code, sz);

    if res == "OK" then
        return true;
    end   
    
    return false;
end

function getSproto(key, sprotoType)
    local success, redisC = reconnectIfNecessary( _redisAddr, _redisPort );

    if not success then
        print("Failed to reconnect to redis server.");
        return false;
    end

    redisContext = redisC;

    local value = redis.redisGetByteString(redisContext, key);
    if value == nil then
        print("Can't find sproto for key " .. key);
        return nil;
    end

    local sz = string.len(value);
    return sp:decode(sprotoType, value, sz);
end

