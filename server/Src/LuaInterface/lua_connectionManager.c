
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

    int session = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
    int messageType = buf[4];
    int messageNameLen = buf[5] << 8 | buf[6];

    for (int i = 0; i < messageNameLen && i < TYPE_STRING_MAX_LEN; ++i) {
        messageName[i] = buf[7 + i];
    }

    lua_settop(L, 0);
    lua_pushinteger(L, session);
    lua_pushinteger(L, messageType);
    lua_pushstring(L, messageName);
    lua_pushinteger(L, messageNameLen);
    lua_pushlightuserdata(L, buf + 7 + messageNameLen);

    return 5;
}

// For client, don't need to send down package size
static int packMessage(lua_State *L) {
    const char *messageName = lua_tostring(L, 1);
    int session = lua_tointeger(L, 2);
    const char *buf = lua_tostring(L, 3);
    int size = lua_rawlen(L, 3);
    int messageNameSize = strlen(messageName);
    int totalSize = size + 6 + messageNameSize;

    char *package = lua_newuserdata(L, totalSize);

    package[0] = session >> 24;
    package[1] = session >> 16;
    package[2] = session >> 8;
    package[3] = session;
    package[4] = messageNameSize >> 8;
    package[5] = messageNameSize;
    for(int i = 0; i < messageNameSize; ++i) {
        package[i + 6] = messageName[i];
    }

    memcpy(package + 6 + messageNameSize, buf, size);

    lua_pushlstring(L, package, totalSize);
    
    return 1;
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
