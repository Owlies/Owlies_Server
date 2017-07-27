#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

#include "dbobjuseraccountlib.h"

#define HASH_KEY_LEN 27
#define KEY_CHAR_POOL_LEN 62

char KEY_CHAR_POOL[62] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
char FIX_HASH_KEY_PREFIX[5] = "redis";

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

//TODO : Move this method to a helper c file called redishashkeygenerator.c
//Key format is : redis-xxx-xxxx-xxxxx-xxxxxx
static int get_user_account_redis_item_key(lua_State *L) {
    srand(time(NULL));
    char *redis_item_key;
    redis_item_key = (char*) malloc(HASH_KEY_LEN);
    strcpy(redis_item_key, FIX_HASH_KEY_PREFIX);

    int i = 5;
    for(i = 5; i < 27; ++ i) {
        int idx = (int)( rand()%KEY_CHAR_POOL_LEN );
        redis_item_key[i] = KEY_CHAR_POOL[idx];
    }
    redis_item_key[5] = redis_item_key[9] = redis_item_key[14] = redis_item_key[20] = '-';

    lua_pushstring(L, redis_item_key);
    return 1;
}

//Value format is : field1_name:field1_value,field2_name:field2_Value,...,fieldn_name:fieldn_value
static int get_user_account_redis_item_value(lua_State *L) {
    char *redis_item_value;
    userAccount *pUserAccount = (userAccount *)luaL_checkudata(L, 1, "UserAccount");
    luaL_argcheck(L, pUserAccount != NULL, 1, "Wrong Parameter: UserAccount Object is NULL");

    int redis_item_value_len = 72;

    if(pUserAccount->user_id != NULL)
        redis_item_value_len += strlen(pUserAccount->user_id);
    if(pUserAccount->account != NULL)
        redis_item_value_len += strlen(pUserAccount->account);
    if(pUserAccount->device != NULL)
        redis_item_value_len += strlen(pUserAccount->device);
    if(pUserAccount->facebook_account != NULL)
        redis_item_value_len += strlen(pUserAccount->facebook_account);
    if(pUserAccount->google_play_account != NULL)
        redis_item_value_len += strlen(pUserAccount->google_play_account);
    if(pUserAccount->identifier != NULL)
        redis_item_value_len += strlen(pUserAccount->identifier);

    redis_item_value = (char*) malloc(redis_item_value_len);

    strcat(redis_item_value, "userid:");
    if(pUserAccount->user_id != NULL)
        strcat(redis_item_value, pUserAccount->user_id);
    strcat(redis_item_value, ",");
    strcat(redis_item_value, "account:");
    if(pUserAccount->account != NULL)
        strcat(redis_item_value, pUserAccount->account);
    strcat(redis_item_value, ",");
    strcat(redis_item_value, "device:");
    if(pUserAccount->device != NULL)
        strcat(redis_item_value, pUserAccount->device);
    strcat(redis_item_value, ",");
    strcat(redis_item_value, "facebookaccount:");
    if(pUserAccount->facebook_account != NULL)
        strcat(redis_item_value, pUserAccount->facebook_account);
    strcat(redis_item_value, ",");
    strcat(redis_item_value, "googleplayaccount:");
    if(pUserAccount->google_play_account != NULL)
        strcat(redis_item_value, pUserAccount->google_play_account);
    strcat(redis_item_value, ",");
    strcat(redis_item_value, "identifier:");
    if(pUserAccount->identifier != NULL)
        strcat(redis_item_value, pUserAccount->identifier);

    lua_pushstring(L, redis_item_value);
    return 1;
}

int luaopen_dbobjuseraccountlib(lua_State *L){
    luaL_newmetatable(L, "UserAccount");
    lua_pushstring(L, "__index");
    lua_pushvalue(L, -2);
    lua_settable(L, -3);
    luaL_setfuncs(L, arrayFunc_userAccountMeta, 0);
    luaL_newlib(L, arrayFunc_userAccount);

    return 1;
}
