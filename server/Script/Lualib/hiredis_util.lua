local redis = require "hiredis"

require "owlies_sproto_scheme"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

hiredisUtil = {};
local _instance;
 
function hiredisUtil.Instance()
    if not _instance then
        _instance = sprotoSchemes;
    end
 
    _instance.checkConnection = function(redisContext)
        return checkConnection(redisContext);
    end

    _instance.reconnectIfNecessary = function(redisContext, redisAddr, redisPort)
        return reconnectIfNecessary(redisContext, redisAddr, redisPort);
    end

    _instance.setSproto = function(redisContext, key, sprotoType, sproto)
        return setSproto(redisContext, key, sprotoType, sproto);
    end

    _instance.getSproto = function(redisContext, key, sprotoType)
        return getSproto(redisContext, key, sprotoType);
    end
 
    return _instance
end
 
function hiredisUtil:new()
    print('Singleton [hiredisUtil] cannot be instantiated - use Instance() instead');
end

function checkConnection(redisContext)
    return redis.isRedisConnected(redisContext);
end

function reconnectIfNecessary(redisContext, redisAddr, redisPort)
    if not checkConnection(redisContext) then
        local success, redisC = redis.connectWithRetry(redisAddr, redisPort);
        if success == false then
            return false, redisContext;
        end
        redisContext = redisC;
    end

    return true, redisContext;
end

function setSproto(redisContext, key, sprotoType, sproto)
    local code = sp:encode(sprotoType, sproto);
    local sz = string.len(code);
    
    local res = redis.redisSetByteString(redisContext, key, code, sz);

    if res == "OK" then
        return true;
    end   
    
    return false;
end

function getSproto(redisContext, key, sprotoType)
    local value = redis.redisGetByteString(redisContext, key);
    if value == nil then
        print("Can't find sproto for key " .. key);
        return nil;
    end

    local sz = string.len(value);
    return sp:decode(sprotoType, value, sz);
end

