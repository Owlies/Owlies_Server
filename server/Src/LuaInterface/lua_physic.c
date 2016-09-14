 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>

static int testprint(lua_State *L)
{
	const char* msg = lua_tolstring(L,1,NULL);
	printf("interesting! %s \n",msg);
	lua_pop(L,1);
	
	char ret[50] = "+++";
	strcat(ret,msg);
	//sprintf("+++%s",ret,msg);
	lua_pushstring(L,ret);
	
	return 1;
}

int luaopen_physic(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
		{ "testprint" , testprint },
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}