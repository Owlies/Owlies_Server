#include<string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

typedef struct userAccount{
    char *user_id;
    char *account;
    char *device;
    char *facebook_account;
    char *google_play_account;
    char *identifier;
}userAccount;

static int create_user_account(lua_State *L);
static int get_user_account_user_id(lua_State *L);
static int set_user_account_user_id(lua_State *L);
static int get_user_account_account(lua_State *L);
static int set_user_account_account(lua_State *L);
static int get_user_account_device(lua_State *L);
static int set_user_account_device(lua_State *L);
static int get_user_account_facebook_account(lua_State *L);
static int set_user_account_facebook_account(lua_State *L);
static int get_user_account_google_play_account(lua_State *L); 
static int set_user_account_google_play_account(lua_State *L);
static int get_user_account_identifier(lua_State *L);
static int set_user_account_identifier(lua_State *L);

static const struct luaL_Reg arrayFunc_userAccount[] =
{
    {"new", create_user_account},
    {NULL, NULL}
};

static const struct luaL_Reg arrayFunc_userAccountMeta[] = 
{
     {"getUserAccountUserId", get_user_account_user_id},
     {"setUserAccountUserId", set_user_account_user_id},
     {"getUserAccountAccount", get_user_account_account},
     {"setUserAccountAccount", set_user_account_account},
     {"getUserAccountDevice", get_user_account_device},
     {"setUserAccountDevice", set_user_account_device},
     {"getUserAccountFacebookAccount", get_user_account_facebook_account},
     {"setUserAccountFacebookAccount", set_user_account_facebook_account},
     {"getUserAccountGooglePlayAccount", get_user_account_google_play_account},
     {"setUserAccountGooglePlayAccount", set_user_account_google_play_account},
     {"getUserAccountIdentifier", get_user_account_identifier},
     {"setUserAccountIdentifier", set_user_account_identifier},
     {NULL, NULL}
};

//int luaopen_db_obj_useraccountlib(lua_State *L);
