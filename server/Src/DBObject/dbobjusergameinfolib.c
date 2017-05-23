#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "dbobjusergameinfolib.h"

static int create_user_gameinfo(lua_State *L) {
    size_t iBytes = sizeof(struct userGameInfo);
    userGameInfo *pUserGameInfo = (userGameInfo *)lua_newuserdata(L, iBytes);

    luaL_getmetatable(L, "UserGameInfo");
    lua_setmetatable(L, -2);

    return 1;
}

static int get_user_gameinfo_user_id(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    lua_pushstring(L, pUserGameInfo->user_id);
    return 1;
}

static int set_user_gameinfo_user_id(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    luaL_argcheck(L, pUserGameInfo != NULL, 1, "Wrong Parameter: UserGameInfo Object is NULL");

    const char *pUserId = luaL_checkstring(L, 2);
    luaL_argcheck(L, pUserId != NULL, 2, "Wrong Parameter: UserId of UserGameInfo");
    pUserGameInfo->user_id = pUserId;
    return 0;

}

static int get_user_gameinfo_level(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    lua_pushinteger(L, pUserGameInfo->level);
    return 1;
}

static int set_user_gameinfo_level(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    luaL_argcheck(L, pUserGameInfo != NULL, 1, "Wrong Parameter: UserGameInfo Object is NULL");

    const int pLevel = luaL_checkinteger(L, 2);
    luaL_argcheck(L, pLevel < 0, 2, "Wrong Parameter: Level of UserAccount");
    pUserGameInfo->level = pLevel;
    return 0;
}

static int get_user_gameinfo_exp(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    lua_pushinteger(L, pUserGameInfo->exp);
    return 1;
}

static int set_user_gameinfo_exp(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    luaL_argcheck(L, pUserGameInfo != NULL, 1, "Wrong Parameter: UserGameInfo Object is NULL");

    const int pExp = luaL_checkinteger(L, 2);
    luaL_argcheck(L, pExp < 0, 2, "Wrong Parameter: Exp of UserAccount");
    pUserGameInfo->exp = pExp;
    return 0;
}

static int get_user_gameinfo_game_version(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    lua_pushstring(L, pUserGameInfo->game_version);
    return 1;
}

static int set_user_gameinfo_game_version(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    luaL_argcheck(L, pUserGameInfo != NULL, 1, "Wrong Parameter: UserGameInfo Object is NULL");

    const char *pGameVersion = luaL_checkstring(L, 2);
    luaL_argcheck(L, pGameVersion != NULL, 2, "Wrong Parameter: Game Version of UserGameInfo");
    pUserGameInfo->game_version = pGameVersion;
    return 0;
}

static int get_user_gameinfo_last_login_time(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    lua_pushstring(L, pUserGameInfo->last_login_time);
    return 1;
}

static int set_user_gameinfo_last_login_time(lua_State *L) {
    userGameInfo *pUserGameInfo = (userGameInfo *)luaL_checkudata(L, 1, "UserGameInfo");
    luaL_argcheck(L, pUserGameInfo != NULL, 1, "Wrong Parameter: UserGameInfo Object is NULL");

    const char *pLastLoginTime = luaL_checkstring(L, 2);
    luaL_argcheck(L, pLastLoginTime != NULL, 2, "Wrong Parameter: Last Login Time of UserGameInfo");
    pUserGameInfo->last_login_time = pLastLoginTime;
    return 0;
}

int luaopen_dbobjusergameinfolib(lua_State *L){
    luaL_newmetatable(L, "UserGameInfo_Metatable");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, arrayFunc_userGameInfoMeta, 0);
    luaL_newlib(L, arrayFunc_userGameInfo);

    return 1;
}
