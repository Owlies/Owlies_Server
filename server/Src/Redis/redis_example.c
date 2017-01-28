#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <hiredis/hiredis.h>

static int connectRedis(lua_State *L) {
    const char *ip = lua_tostring(L, 1);
    int port = lua_tointeger(L, 2);
    printf("redis ip: %s:%d", ip, port);
    redisContext *c = redisConnect(ip, port);
    if (c != NULL && c->err) {
        printf("Error: %s\n", c->errstr);
        // handle error
    } else {
        printf("Connected to Redis\n");
    }

    redisReply *reply;
    reply = redisCommand(c, "AUTH password");
    freeReplyObject(reply);

    redisFree(c);

    return 0;
}

int luaopen_hiredisExample(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "connectRedis", connectRedis },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}