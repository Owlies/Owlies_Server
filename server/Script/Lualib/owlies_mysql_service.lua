-- Fail to import following DB object lib
-- require "dbobjuseraccountlib"
-- require "dbobjusergameinfolib"
local mysql = require "mysql"

local mysql_service_lib = {}

function mysql_service_lib.create_mysql_connection( mysql_db )

    if not mysql_db then
        print("DB connection is lost.")
    else
        return mysql_db
    end

    mysql_db = mysql.connect{
        host="0.0.0.0",
        port="",
        database="towergirl",
        user="root",
        password="",
        max_packet_size = 1024 * 1024
    }

    if not mysql_db then
        print("Failed to connect.")
    end

    return mysql_db
end

function mysql_service_lib.close_mysql_connection( mysql_db )

    if not mysql_db then
        print("DB connection is lost.")
        return 
    end

    mysql_db:disconnect()
    return 
end

function mysql_service_lib.create_new_database( mysql_db, database_name )

    local sql_str = "create database "..database_name

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

function mysql_service_lib.use_database( mysql_db, database_name )

    local sql_str = "use "..database_name

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

function mysql_service_lib.list_database_tables( mysql_db )

    local sql_str = "show tables"

    if not mysql_db then
        print("Connection is broken or not established yet. Reconnect to MySQL now ...")
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

function mysql_service_lib.create_new_table( mysql_db, table_name )

    local sql_str = "create table "..table_name.."()"

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return 
end

function mysql_service_lib.add_new_user_account( mysql_db, useraccount )
  
-- FIXME : Not working because fail to import DB object lib
--    local sql_str = "insert into UserAccount( UserId, Account, Device, FacebookAccount, GoogleplayAccount, Identifier ) values ("..useraccount:getUserAccountUserId()..","..useraccount:getUserAccountAccount()..","..useraccount:getUserAccountDevice()..","..useraccount:getUserAccountFacebookAccount..","..useraccount:getUserAccountGooglePlayAccount()..","..useraccount:getUserAccountIdentifier()..")"

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

-- TODO : Add dump method to parse returned object 
function mysql_service_lib.select_user_account_by_user_id( mysql_db, user_id )

    local sql_str = "select * from UserAccount where UserId = "..user_id

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

function  mysql_service_lib.delete_new_user_account_by_user_id( mysql_db, user_id )

    local sql_str = "delete from UserAccount where UserId = "..user_id

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

function mysql_service_lib.add_new_user_game_info( mysql_db, usergameinfo )

-- FIXME : Not working because fail to import DB object lib
--    local sql_str = "insert into UserGameInfo( UserId, Level, Exp, GameVersion, LastLoginTime ) values ("..usergameinfo:getUserGameInfoUserId()..","..usergameinfo:getUserGameInfoLevel()..","..usergameinfo:getUserGameInfoExp()..","..usergameinfo:getUserGameInfoGameVersion()..","..usergameinfo:getUserGameInfoLastLoginTime()..")"

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end

-- TODO : Add dump method to parse returned object 
function mysql_service_lib.select_user_gameinfo_by_user_id( mysql_db, user_id )

    local sql_str = "select * from UserGameInfo where UserId = "..user_id

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return

end

function mysql_service_lib.delete_new_user_game_info( mysql_db, user_id )

    local sql_str = "delete from UserGameInfo where UserId = "..user_id

    if not mysql_db then
        self:create_mysql_connection( mysql_db )
    end

    local res = mysql_db:query(sql_str)

    return
end


return mysql_service_lib
