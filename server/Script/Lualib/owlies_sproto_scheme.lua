local sproto = require "sproto"

local sprotoSchemeFilePath = "sproto_files/";
local sprotoSchemeFiles = {"Member"}

-- Singleton Model --
sprotoSchemes = {}
 
local _instance;
 
function sprotoSchemes.Instance()
    if not _instance then
        initSchemes();
        _instance = sprotoSchemes;
    end
 
    --'any new methods would be added to the _instance object like this'
    _instance.getScheme = function(schemeName)
        return _instance[schemeName];
    end
 
    return _instance
end
 
function sprotoSchemes:new()
    print('Singleton [sprotoSchemes] cannot be instantiated - use getInstance() instead');
end
-- Singleton Model --

function readFile(filename)
	local f = assert(io.open(filename), "Can't open sproto file " .. filename);
	local data = f:read "a";
	f:close();
	local sp = sproto.parse(data);
	if sp == nil then
		assert(false, "Parse sproto error for file " .. filename);
		return nil;
	end
	return sp;
end

function initSchemes()
    local filepath = "";
    for i = 1,#sprotoSchemeFiles do
        filepath = sprotoSchemeFilePath .. sprotoSchemeFiles[i] .. ".sproto";
        local sp = readFile(filepath);
        if sprotoSchemes[sprotoSchemeFiles[i]] ~= nil then
            print("Duplicate sproto files found: " .. sprotoSchemeFiles[i] .. ".sproto, skip");
        else
            sprotoSchemes[sprotoSchemeFiles[i]] = sp;
        end
    end
end

