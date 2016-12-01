local sproto = require "sproto"
local print_r = require "print_r"
local cmCore = require "connectionManager"

require "owlies_sproto_scheme"


local sp = sprotoSchemes:Instance().getScheme("Member");

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

    _instance.serialize = function(sprotoObj, typeString)
        return serialize(sprotoObj, typeString);
    end
 
    return _instance
end
 
function connectionManager:new()
    print('Singleton [connectionManager] cannot be instantiated - use Instance() instead');
end
-- Singleton Model --

function deserialize(message, size)
    print("deserialize");
    local messageType, session, messageName, messageNameLen, msg = cmCore.unpackMessage(message);
    local sz = size - 9 - messageNameLen;
    return sp:decode("Person", msg, sz);
end

function serialize(sprotoObj, typeString)
    assert(type(sprotoObj) == "userdata");
    assert(type(typeString) == "string");

end
