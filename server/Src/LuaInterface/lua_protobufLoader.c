#include "lua-seri.h"

#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <assert.h>
#include "Protobuf/protobufLoaders/protobufDataTemplateLoader.h"

static int unpack (lua_State *L) {
	printf("unpack function called\n");
	void *buf = lua_touserdata(L, 1);
	int sz = lua_tointeger(L,2);
	struct _Owlies__Core__ChangeEvents__Item item = deserializeMessage(buf, sz);
	printf("item name: %s\n", item.name);
	// TODO: owlies__core__change_events__item__free_unpacked(&item, NULL);
	lua_settop(L, 0);
	return 0;
}

static int pack (lua_State *L) {
	printf("pack function called\n");
	size_t *name_len = 0;
	const char *name = lua_tolstring(L,1,name_len);
	struct _Owlies__Core__ChangeEvents__Item message = OWLIES__CORE__CHANGE_EVENTS__ITEM__INIT;
	void *buf;
	// unsigned size;

	message.name = (char *)name;
	message.price = 123;
	message.itemtype = OWLIES__CORE__CHANGE_EVENTS__ITEM_TYPE__Shirt;

	serializeMessage(&message, &buf);
	// lua_pushinteger(L, len);
	// lua_pushlightuserdata(L, buf);
	lua_pushstring(L, buf);
	printf("pack function end\n");

	return 1;
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