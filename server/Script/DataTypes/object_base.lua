local skynet = require "skynet"

local objectBase = {}
objectBase.__index = objectBase;

function objectBase:getColumnNames()
    local tableName = self.getTableName();
    print("getColumnNames " .. tableName);
    local sql = "SHOW COLUMNS FROM " .. tableName .. ";";
    local success, columnNames = pcall(skynet.call, "db_service", "lua", "query", sql);
    if not success then
        print("Failed to getColumnNames");
    end
    local columns = {};
    for i,v in pairs(columnNames) do
        table.insert(columns, v["Field"]);
    end
    
    return columns;
end

function objectBase:instantiate(sproto)
    local newInstance = newInstance or {};
    newInstance.properties = newInstance.properties or {};
    setmetatable(newInstance, self)
    return newInstance;
end

function objectBase:insertOnDuplicate()
    local tableName = self.getTableName();
    if tableName == nil then
        print("Error insertOnDuplicate, tableName is nil");
        print(self);
        return;
    end

    local primaryKeys = self.getPrimaryKeys();

    local sql = "INSERT INTO " .. tableName .. " VALUES (";

    local columns = self.columns;
    for i = 1, #columns do
        local value = self.properties[columns[i]];
        sql = sql .. "'" .. value .. "',";
    end

    -- Remove last ',' 
    sql = string.sub(sql, 1, -2) .. ") ON DUPLICATE KEY UPDATE ";

    -- Remove primaryKeys
    local columnsToUpdate = {};

    for i,v in pairs(columns) do
        local isPrimarykey = false;
        for j = 1, #primaryKeys do
            if primaryKeys[j] == v then
                isPrimarykey = true;
                break;
            end
        end
        if not isPrimarykey then
            table.insert(columnsToUpdate, v);
        end
    end

    for i = 1, #columnsToUpdate do
        local value = self.properties[columnsToUpdate[i]];
        sql = sql .. columnsToUpdate[i] .. " = '" .. value .. "', ";
    end
    -- Remove last ', ' 
    sql = string.sub(sql, 1, -3) .. ";";

    local success, columnNames = pcall(skynet.call, "db_service", "lua", "query", sql);
    if not success then
        print("Failed to insertOnDuplicate " .. sql);
    end

    return success;
end

return objectBase;