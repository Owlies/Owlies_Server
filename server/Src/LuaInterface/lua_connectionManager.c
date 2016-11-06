#include "lua-seri.h"

#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "LuaProtobufs/lua_dataTemplateProtobuf.h"
#include "lua_connectionManager.h"

#define TYPE_STRING_MAX_LEN 255

int onReceiveProtobuf (lua_State *L) {
    printf("onReceiveProtobuf called\n");
    char *buf = lua_touserdata(L, 1);
	int sz = lua_tointeger(L,2);
    lua_settop(L, 0);

    int typeStringSize = buf[0] * 256 + buf[1];
    char typeString[TYPE_STRING_MAX_LEN];
    memset(typeString, 0, TYPE_STRING_MAX_LEN);

    int i = 0;
    for (i = 0; i < typeStringSize; ++i) {
        typeString[i] = buf[i+2];
    }
    typeString[typeStringSize] = '\0';

    void* protobufObject = getProtobufFromTypeString(typeString, (buf + 2 + typeStringSize), sz - typeStringSize - 4);

    lua_pushlightuserdata(L, protobufObject);
	return 0;
}

void* getProtobufFromTypeString(const char *typeString, char* buf, int sz) {
    printf("getProtobufFromTypeString called\n");

    // TODO(Huayu): create protobuf object based on typeString
    struct _Owlies__Core__ChangeEvents__Item *item = deserializeProtobuf(buf, sz);
    printf("Item name: %s\n", item->name);
    return item;
}

int luaopen_connectionManager(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "onReceiveProtobuf", onReceiveProtobuf },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}
