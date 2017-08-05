local class = require "middleclass"
local ObjectBase = require "object_base"
local sp = sprotoSchemes:Instance().getScheme("Server2Client");

local S2cObjectBase = class("S2cObjectBase", ObjectBase);

function S2cObjectBase:initialize()
    ObjectBase.initialize(self);
    return ObjectBase.loadByPrimaryKeys(self);
end

function S2cObjectBase:toSproto()
    return ObjectBase.toSproto(self, sp);
end

return S2cObjectBase;

