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

    for (int i = 0; i < typeStringSize; ++i) {
        typeString[i] = buf[i+2];
    }
    typeString[typeStringSize] = '\0';

    void* protobufObject = getProtobufFromTypeString(typeString, (buf + 2 + typeStringSize), sz - typeStringSize - 4);

    lua_pushlightuserdata(L, protobufObject);
	return 0;
}

void* getProtobufFromTypeString(const char *typeString, char* buf, int sz) {
    printf("getProtobufFromTypeString called\n");

    printf("%d\n", sz);
    printf("%d\n", buf[0]);
	printf("%d\n", buf[1]);
	printf("%d\n", buf[2]);
	printf("%d\n", buf[3]);
	printf("%d\n", buf[4]);
	printf("%d\n", buf[5]);

    // TODO(Huayu): create protobuf object based on typeString
    struct _Owlies__Core__ChangeEvents__Item *item = deserializeProtobuf(buf, sz);
    printf("Item name: %s\n", item->name);
    return item;
}

int sendProtobuf (lua_State *L) {
	printf("pack function called\n");
	size_t *name_len = 0;
	const char *name = lua_tolstring(L,1,name_len);
	struct _Owlies__Core__ChangeEvents__Item message = OWLIES__CORE__CHANGE_EVENTS__ITEM__INIT;
	void *buf;

	message.name = (char *)name;
	message.price = 999;
	message.itemtype = OWLIES__CORE__CHANGE_EVENTS__ITEM_TYPE__Hat;

    unsigned len = owlies__core__change_events__item__get_packed_size(&message);
    buf = malloc(len + 2);
    owlies__core__change_events__item__pack(&message, ((unsigned char *)buf + 2));

	((unsigned char *)buf)[0] = len / 256;
	((unsigned char *)buf)[1] = len % 256;

	lua_pushinteger(L, len + 2);
	lua_pushlightuserdata(L, buf);
	
	// lua_pushstring(L, buf);
	//free(buf);
	return 2;
}

int luaopen_connectionManager(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "onReceiveProtobuf", onReceiveProtobuf },
        { "sendProtobuf", sendProtobuf },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}