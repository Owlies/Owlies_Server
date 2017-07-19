#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include <hiredis/hiredis.h>
#include <hiredis/async.h>

static int connect(lua_State *L) {
    const char *ip = lua_tostring(L, 1);
    int port = lua_tointeger(L, 2);
    printf("redis ip: %s:%d\n", ip, port);

    struct timeval timeout = { 1, 500000 }; // 1.5 seconds
    redisContext *c = redisConnectWithTimeout(ip, port, timeout);
    if (c == NULL || c->err) {
        if (c) {
            printf("Connection error: %s\n", c->errstr);
            redisFree(c);
        } else {
            printf("Connection error: can't allocate redis context\n");
        }
        exit(1);
    }

    lua_pushlightuserdata(L, c);
    return 1;
}

static int disconnect(lua_State *L) {
    redisContext *c = lua_touserdata(L, 1);
    redisFree(c);
    return 0;
}

static int setByteString(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    const char *key = lua_tostring(L, 2);
    const char *value = lua_tostring(L, 3);
    int sz = lua_tointeger(L, 4);
 
    redisReply *reply;
    reply = redisCommand(context, "SET %s %b", key, value, (size_t)sz);

    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;

    return 1;
}

static int getByteString(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    const char *key = lua_tostring(L, 2);
    redisReply *reply;
    reply = redisCommand(context, "GET %s", key);

    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;
    return 1;
}

static int ping(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    redisReply *reply;
    reply = redisCommand(context, "PING");
    if (strcmp(reply->str, "PONG") == 0) {
        lua_pushboolean(L, 1);
    }
    lua_pushboolean(L, 0);

    freeReplyObject(reply);
    return 1;
}

int luaopen_hiredis(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        {"redisConnect", connect},
        {"redisDisconnect", disconnect},
        {"redisSetByteString", setByteString},
        {"redisGetByteString", getByteString},
        {"redisPing", ping},
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}