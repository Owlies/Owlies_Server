local class = require "middleclass"
local ObjectBase = require "object_base"
local sp = sprotoSchemes:Instance().getScheme("Client2Server");

local C2sObjectBase = class("C2sObjectBase", ObjectBase);

function C2sObjectBase:initialize(sproto)
    print("C2sObjectBase:initialize")
    ObjectBase.initialize(self);

    for i,v in pairs(sproto) do
        self[i] = v;
    end
end

function C2sObjectBase:toSproto()
    return ObjectBase.toSproto(self, sp);
end

return C2sObjectBase;

