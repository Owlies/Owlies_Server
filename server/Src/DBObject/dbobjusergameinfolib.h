#include<string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

typedef struct userGameInfo{
    char *user_id;
    int level;
    int exp;
    char *game_version;
    char *last_login_time;
}userGameInfo;

static int create_user_gameinfo(lua_State *L);
static int get_user_gameinfo_user_id(lua_State *L);
static int set_user_gameinfo_user_id(lua_State *L);
static int get_user_gameinfo_level(lua_State *L);
static int set_user_gameinfo_level(lua_State *L);
static int get_user_gameinfo_exp(lua_State *L);
static int set_user_gameinfo_exp(lua_State *L);
static int get_user_gameinfo_game_version(lua_State *L);
static int set_user_gameinfo_game_version(lua_State *L);
static int get_user_gameinfo_last_login_time(lua_State *L);
static int set_user_gameinfo_last_login_time(lua_State *L);

static const struct luaL_Reg arrayFunc_userGameInfo[] =
{
        {"new", create_user_gameinfo},
        {NULL, NULL}
};

static const struct luaL_Reg arrayFunc_userGameInfoMeta[] =
{
        {"getUserGameInfoUserId", get_user_gameinfo_user_id},
        {"setUserGameInfoUserId", set_user_gameinfo_user_id},
        {"getUserGameInfoLevel", get_user_gameinfo_level},
        {"setUserGameInfoLevel", set_user_gameinfo_level},
        {"getUserGameInfoExp", get_user_gameinfo_exp},
        {"setUserGameInfoExp", set_user_gameinfo_exp},
        {"getUserGameInfoGameVersion", get_user_gameinfo_game_version},
        {"setUserGameInfoGameVersion", set_user_gameinfo_game_version},
        {"getUserGameInfoLastLoginTime", get_user_gameinfo_last_login_time},
        {"setUserGameInfoLastLoginTime", set_user_gameinfo_last_login_time},
        {NULL, NULL}
};

//int luaopen_db_obj_usergameinfolib(lua_State *L);
