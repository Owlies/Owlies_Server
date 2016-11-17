
#include "lua-seri.h"

#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "LuaProtobufs/lua_dataTemplateProtobuf.h"
#include "lua_connectionManager.h"
#include "pbc.h"


#define TYPE_STRING_MAX_LEN 255

void read_file (const char *filename , struct pbc_slice *slice) {
	FILE *f = fopen(filename, "rb");
	if (f == NULL) {
        printf("file not found\n");
		slice->buffer = NULL;
		slice->len = 0;
		return;
	}
	fseek(f,0,SEEK_END);
	slice->len = ftell(f);
	fseek(f,0,SEEK_SET);
	slice->buffer = malloc(slice->len);
	if (fread(slice->buffer, 1 , slice->len , f) == 0)
		exit(1);
	fclose(f);
}

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
    //lua_pushstring(L, protobufObject);
	return 1;
}

int splitOnReceive (lua_State *L) {
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

    //char *s = (buf + 2 + typeStringSize);
    //void* protobufObject = getProtobufFromTypeString(typeString, (buf + 2 + typeStringSize), sz - typeStringSize - 4);

    //lua_pushlstring(L, (buf + 2 + typeStringSize), sz - typeStringSize - 4);
    lua_pushstring(L, (buf + 2 + typeStringSize));


    struct pbc_env * env = pbc_new();
	struct pbc_slice slice;
	read_file("Src/Protobuf/protobufs/protobufDataTemplate.pb", &slice);
	int ret = pbc_register(env, &slice);
	assert(ret == 0);

    slice.buffer = (buf + 2 + typeStringSize);
    printf("slice len: %d\n", slice.len);

    struct pbc_wmessage* w_msg = pbc_wmessage_new(env, "Item");
    
    pbc_wmessage_delete(w_msg);
	pbc_delete(env);

	return 1;
}

int test (lua_State *L) {
    size_t len;
    const char *s = lua_tolstring(L, 1, &len);
    printf("%d: %s\n", (int)len, s);
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
        { "splitOnReceive", splitOnReceive },
        { "test", test },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}
