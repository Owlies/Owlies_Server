#include "lua-seri.h"
#include "lua_dataTemplateProtobuf.h"

struct _Owlies__Core__ChangeEvents__Item protobufObject;

int create (lua_State *L) {
	struct _Owlies__Core__ChangeEvents__Item message = OWLIES__CORE__CHANGE_EVENTS__ITEM__INIT;
    protobufObject = message;
	return 0;
}

int destroy (lua_State *L) {
    owlies__core__change_events__item__free_unpacked(&protobufObject, NULL);
	return 0;
}

int helper (lua_State *L) {
	char *buf = lua_touserdata(L, 1);
	printf("%d", buf[0]);
	printf("%d", buf[1]);
	printf("%d", buf[2]);
	printf("%d", buf[3]);
	printf("%d", buf[4]);
	printf("%d", buf[5]);
	lua_settop(L, 0);
	return 0;
}

struct _Owlies__Core__ChangeEvents__Item* deserializeProtobuf(void *buf, unsigned sz) {
	struct _Owlies__Core__ChangeEvents__Item *item = malloc(sizeof(struct _Owlies__Core__ChangeEvents__Item));
    *item = deserializeMessage(buf, sz);
	return item;
} 

void* serializeProtobuf(struct _Owlies__Core__ChangeEvents__Item message, unsigned* sz) {
	unsigned len = owlies__core__change_events__item__get_packed_size(&message);
	(*sz) = len + 2;

	void *buf;
	buf = malloc(len + 2);
    owlies__core__change_events__item__pack(&message, ((unsigned char *)buf + 2));

	((unsigned char *)buf)[0] = len / 256;
	((unsigned char *)buf)[1] = len % 256;

	return buf;
}

int unpack (lua_State *L) {
	void *buf = lua_touserdata(L, 1);
	int sz = lua_tointeger(L,2);
	struct _Owlies__Core__ChangeEvents__Item item = deserializeMessage(buf, sz);
	// owlies__core__change_events__item__free_unpacked(&item, NULL);
	lua_settop(L, 0);
	return 0;
}

int pack (lua_State *L) {
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

int luaopen_dataTemplateProtobuf(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        { "create", create },
        { "destroy", destroy },
		{ "helper", helper },
		{ "unpack" , unpack },
		{ "pack" , pack },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}