#include "lua-seri.h"

#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../Protobuf/protobufLoaders/protobufDataTemplateLoader.h"

static int unpack (lua_State *L) {
	printf("unpack function called\n");
	printf("%d", lua_gettop(L));
	//struct _Owlies__Core__ChangeEvents__Item deserializeMessage(void *buf, unsigned len)
	void *buf = lua_touserdata(L, 1);
	printf("1\n");
	lua_pop(L, 1);
	printf("2\n");
	int sz = lua_tointeger(L,1);
	lua_pop(L, 1);
	printf("%d\n", sz);

	//struct _Owlies__Core__ChangeEvents__Item item = deserializeMessage(buf, sz);
	lua_getglobal(L, "deserializeMessage");
	lua_pushlightuserdata(L ,buf);
	lua_pushinteger(L, sz);
	lua_call(L, 2, 1);
	lua_setglobal(L, "item");
	struct _Owlies__Core__ChangeEvents__Item *item = lua_touserdata(L, 1);
	lua_pop(L, 1);
	printf("item name: %s\n", (*item).name);
	return 0;
}

static int pack (lua_State *L) {
	printf("pack function called\n");
	return 0;
}

int luaopen_protobufLoader(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
		{ "unpack" , unpack },
		{ "pack" , pack },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}