#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "Protobuf/protobufLoaders/protobufDataTemplateLoader.h"

int create (lua_State *L);
int destroy (lua_State *L);
int helper (lua_State *L);
int unpack (lua_State *L);
int pack (lua_State *L);