
#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define TYPE_STRING_MAX_LEN 255

static int unpackMessage(lua_State *L) {
    char messageName[TYPE_STRING_MAX_LEN];
    char *buf = lua_touserdata(L, 1);

    int messageType = buf[0];
    int session = buf[1] << 24 | buf[2] << 16 | buf[3] << 8 | buf[4];
    int messageNameLen = buf[5] << 8 | buf[6];

    for (int i = 0; i < messageNameLen && i < TYPE_STRING_MAX_LEN; ++i) {
        messageName[i] = buf[7 + i];
    }
    lua_settop(L, 0);
    lua_pushinteger(L, messageType);
    lua_pushinteger(L, session);
    lua_pushstring(L, messageName);
    lua_pushinteger(L, messageNameLen);
    lua_pushlightuserdata(L, buf + 7 + messageNameLen);

    return 5;
}

static int packMessage(lua_State *L) {
    return 0;
}

int luaopen_connectionManager(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "unpackMessage", unpackMessage },
        { "packMessage", packMessage },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}
