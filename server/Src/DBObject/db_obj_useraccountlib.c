#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "db_obj_useraccountlib.h"

static int create_user_account(lua_State *L) {
    size_t iBytes = sizeof(struct userAccount);
    userAccount *pUserAccount = (userAccount *)lua_newuserdata(L, iBytes);

    luaL_getmetatable(L, "UserAccount");
    lua_setmetatable(L, -2);

    return 1;
}

static int get_user_account_user_id(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->user_id);
    return 1;
}

static int set_user_account_user_id(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pUserId = luaL_checkstring(L, 2);
    luaL_argcheck(L, pUserId != NULL, 2, "Wrong Parameter: UserId of UserAccount");
    pUserAccount->user_id = pUserId;
    return 0;
}

static int get_user_account_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->account);
    return 1;
}

static int set_user_account_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pAccount = luaL_checkstring(L, 2);
    luaL_argcheck(L, pAccount != NULL, 2, "Wrong Parameter: Account of UserAccount");
    pUserAccount->account = pAccount;
    return 0;
}

static int get_user_account_device(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->device);
    return 1;
}

static int set_user_account_device(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pDevice = luaL_checkstring(L, 2);
    luaL_argcheck(L, pDevice != NULL, 2, "Wrong Parameter: Device of UserAccount");
    pUserAccount->device = pDevice;
    return 0;
}

static int get_user_account_facebook_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->facebook_account);
    return 1;
}

static int set_user_account_facebook_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pFacebookAccount = luaL_checkstring(L, 2);
    luaL_argcheck(L, pFacebookAccount != NULL, 2, "Wrong Parameter: Facebook Account of UserAccount");
    pUserAccount->facebook_account = pFacebookAccount;
    return 0;
}

static int get_user_account_google_play_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->google_play_account);
    return 1;
}

static int set_user_account_google_play_account(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pGooglePlayAccount = luaL_checkstring(L, 2);
    luaL_argcheck(L, pGooglePlayAccount != NULL, 2, "Wrong Parameter: Google Play Account of UserAccount");
    pUserAccount->google_play_account = pGooglePlayAccount;
    return 0;
}

static int get_user_account_identifier(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    lua_pushstring(L, pUserAccount->identifier);
    return 1;
}

static int set_user_account_identifier(lua_State *L) {
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    const char *pIdentifier = luaL_checkstring(L, 2);
    luaL_argcheck(L, pIdentifier != NULL, 2, "Wrong Parameter: Identifier of UserAccount");
    pUserAccount->identifier = pIdentifier;
    return 0;

}

int luaopen_db_obj_useraccountlib(lua_State *L){
    luaL_newmetatable(L, "UserAccount_Metatable");
    lua_pushvalue(L, -1);
    lua_setfield(L, -2, "__index");
    luaL_setfuncs(L, arrayFunc_userAccountMeta, 0);
    luaL_newlib(L, arrayFunc_userAccount);

    return 1;
}
