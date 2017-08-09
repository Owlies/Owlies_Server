local sproto = require "sproto"
local print_r = require "print_r"
local cmCore = require "connectionManager"

require "owlies_sproto_scheme"
local c2sSp = sprotoSchemes:Instance().getScheme("Client2Server");
local s2cSp = sprotoSchemes:Instance().getScheme("Server2Client");

-- Singleton Model --
connectionManager = {};
local _instance;
 
function connectionManager.Instance()
    if not _instance then
        _instance = sprotoSchemes;
    end
 
    --'any new methods would be added to the _instance object like this'
    _instance.deserialize = function(message, size)
        return deserialize(message, size);
    end

    _instance.serialize = function(sprotoObj, typeString, serverSession)
        return serialize(sprotoObj, typeString, serverSession);
    end
 
    return _instance
end
 
function connectionManager:new()
    print('Singleton [connectionManager] cannot be instantiated - use Instance() instead');
end
-- Singleton Model --

function deserialize(message, size)
    print("deserialize");
    local session, messageType, messageName, messageNameLen, msg = cmCore.unpackMessage(message);
    local sz = size - 7 - messageNameLen;

    if not c2sSp:exist_type(messageName) then 
        print("Can't find sproto with typename: ", messageName);
    end
    local obj = c2sSp:decode(messageName, msg, sz);

    return obj, session, messageType, messageName;
end

function serialize(messageName, sprotoObj, serverSession)
    assert(type(messageName) == "string");
    assert(type(sprotoObj) == "table");
    local sp = c2sSp;
    if not sp:exist_type(messageName) then
        sp = s2cSp;
    end

    local code = sp:encode(messageName, sprotoObj);
    local package = cmCore.packMessage(messageName, serverSession, code);
    return package;
end
