local skynet = require "skynet"
local class = require "middleclass"

local ObjectBase = class("ObjectBase");

function ObjectBase:initialize()
    print("ObjectBase:initialize");
    self.columns = ObjectBase.getColumnNames(self);
end

function ObjectBase:updateDB()
    return ObjectBase.insertOnDuplicate(self);
end

function tryGetTableName(self)
    local tableName = self:getTableName();
    if tableName == nil then
        print("Error insertOnDuplicate, tableName is nil");
        print(self);
    end

    return tableName;
end

-- Should exclude 'class', 'columns'
function ObjectBase:toSproto(sp)
    local sproto = sp:host(self.getSprotoName());
    for i,v in pairs(self) do
        if type(v) ~= "function" and i ~= "class" and i~= "columns" then
            print(i)
            sproto[i] = v;
        end
    end

    return sproto;
end

function ObjectBase:getColumnNames()
    local tableName = self:getTableName();
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

function ObjectBase:insertOnDuplicate()
    local tableName = tryGetTableName(self);
    if tableName == nil then
        return;
    end

    local primaryKeys = self:getPrimaryKeys();

    local sql = "INSERT INTO " .. tableName .. " VALUES (";

    local columns = self.columns;
    for i = 1, #columns do
        local value = self[columns[i]];
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
        local value = self[columnsToUpdate[i]];
        sql = sql .. columnsToUpdate[i] .. " = '" .. value .. "', ";
    end
    -- Remove last ', ' 
    sql = string.sub(sql, 1, -3) .. ";";

    local success, result = pcall(skynet.call, "db_service", "lua", "query", sql);
    if not success then
        print("Failed to insertOnDuplicate " .. sql);
    end

    return success;
end

function ObjectBase:loadByPrimaryKeys()
    local tableName = tryGetTableName(self);
    if tableName == nil then
        return;
    end

    local primaryKeys = self:getPrimaryKeys();

    local sql = "SELECT * FROM " .. tableName .. " WHERE ";
    local count = #primaryKeys;

    for i = 1, count do
        sql = sql .. primaryKeys[i] .. " = '" .. self[primaryKeys[i]] .. "'";
        if i >= 2 and i < count - 1 then
            sql = sql .. "AND ";
        end
    end

    sql = sql .. ";";

    local success, result = pcall(skynet.call, "db_service", "lua", "query", sql);
    if not success then
        print("Failed to loadByPrimaryKeys " .. sql);
    end

    return success, result;
end

return ObjectBase;