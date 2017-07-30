#include <lua.h>
#include <lauxlib.h>
#include <stdio.h>
#include <mysql.h>

int test() {
    MYSQL *connection, mysql;
    mysql_init(&mysql);
    connection = mysql_real_connect(&mysql,"localhost","huayuyang","Legendary@0213","Music_Game",0,0,0); //user->用户名;psd->密码;db->数据库名称
    if (connection == NULL)
    {
        printf("连接失败:%s\n", mysql_error(&mysql));
    }
    else
    {
        printf("连接成功, 服务器版本: %s, 客户端版本: %s.\n", MYSQL_SERVER_VERSION, mysql_get_client_info());
    }
    mysql_close(&mysql);
    return 0;
}

int testFun(lua_State *L) {
    test();
    return 0;
}
int luaopen_mysqlutil(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "test", testFun },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}