local sproto = require "sproto"

local sprotoSchemeFilePath = "sproto_files/";
local sprotoSchemeFiles = {"Member"}


sprotoSchemes = {}
 
local _instance;
 
function sprotoSchemes.getInstance()
    if not _instance then
        loadSchemes();
        _instance = sprotoSchemes;
    end
 
    --'any new methods would be added to the _instance object like this'
    _instance.getType = function()
        return 'singleton';
    end

    _instance.getScheme = function(schemeName)
        return _instance[schemeName];
    end
 
    return _instance
end
 
function sprotoSchemes:new()
    print('Singleton cannot be instantiated - use getInstance() instead');
end

function readFile(filename)
	local f = assert(io.open(filename), "Can't open sproto file");
	local data = f:read "a";
	f:close();
	local sp = sproto.parse(data);
	if sp == nil then
		assert(false, "Parse sproto error for file " .. filename);
		return nil;
	end
	return sp;
end

function loadSchemes()
    print("loadSchemes called");
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

