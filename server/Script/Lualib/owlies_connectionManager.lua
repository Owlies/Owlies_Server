local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local protobufLoader = require "protobufLoader"

local ConnectionManager = {};
function ConnectionManager.receive(msg, sz)
    print("receive\n");
    
end

function ConnectionManager.send(pack, sz)
    print("send\n");
    print(pack);
    print("\n");
    print(sz);
end

return ConnectionManager;