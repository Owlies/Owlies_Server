#include <lua.h>
#include <lauxlib.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <hiredis/hiredis.h>
#include <hiredis/async.h>

#define MAX_RETRY_TIMES 3
#define RETRY_INTERVAL 1

int isConnectedToRedis(redisContext *context) {
    if(context == NULL)
        return 0;
    redisReply *reply;
    reply = redisCommand(context, "PING");
    int res = 0;
    if (strcmp(reply->str, "PONG") == 0) {
        res = 1;
    }

    freeReplyObject(reply);
    return res;
}

redisContext *connectToRedis(redisContext *context, const char *ip, int port) {
    struct timeval timeout = { 1, 500000 }; // 1.5 seconds
    if(context != NULL ) {
        redisFree(context);
    }
        
    context = redisConnectWithTimeout(ip, port, timeout);
    if (context == NULL || context->err) {
        if (context) {
            printf("Connection error: %s\n", context->errstr);
            redisFree(context);
        } else {
            printf("Connection error: can't allocate redis context\n");
        }
        return NULL;
    }
    return context;
}

redisContext *connectToRedisWithRetry(const char *ip, int port) {
    redisContext *context = NULL;
    int retryTime = 0;

    while(retryTime < MAX_RETRY_TIMES) {
        ++retryTime;
        context = connectToRedis(context, ip, port);        
        if(context != NULL) {
            break;
        }
        
        // sleep(RETRY_INTERVAL);
    }

    if(retryTime >= MAX_RETRY_TIMES) {
        printf("Already tried many times to connect to Redis but all failed.\n");
        if(context) {
            redisFree(context);
        }
    }

    return context;
}

/* ----- Lua Methods ----- */
static int isConnected(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    lua_pushboolean(L, isConnectedToRedis(context));
    return 1;
}

static int connectWithRetry(lua_State *L) {
    const char *ip = lua_tostring(L, 1);
    int port = lua_tointeger(L, 2);

    printf("redis ip and port: %s:%d\n", ip, port);

    redisContext *context = connectToRedisWithRetry(ip, port);
    if (context == NULL) {
        lua_pushboolean(L, 0);
        return 1;
    }

    //Note: Test it out. It should only returns the context and ignore the boolean because
    //every lua_pushxxx method will create one stack and the next lua_pushxxx method will
    //override the stack created by last push method.
    lua_pushboolean(L, 1);
    lua_pushlightuserdata(L, context);
    return 2;
}

static int disconnect(lua_State *L) {
   redisContext *context = lua_touserdata(L, 1);
   redisFree(context);
   return 0;
}

static int setByteString(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    if (context == NULL) {
        printf("setByteString: Invalid redisContext\n");
        return 0;
    }
    const char *key = lua_tostring(L, 2);
    const char *value = lua_tostring(L, 3);
    int sz = lua_tointeger(L, 4);
    redisReply *reply;

    reply = redisCommand(context, "SET %s %b", key, value, (size_t)sz);

    // TODO(Huayu): check error
    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;

    return 1;
}

static int getByteString(lua_State *L) {
    redisContext *context = lua_touserdata(L, 1);
    if (context == NULL) {
        printf("getByteString: Invalid redisContext\n");
        return 0;
    }
    const char *key = lua_tostring(L, 2);
    redisReply *reply;
    reply = redisCommand(context, "GET %s", key);

    // TODO(Huayu): check error
    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;
    return 1;
}

int luaopen_hiredis(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        {"connectWithRetry", connectWithRetry},
        {"redisDisconnect", disconnect},
        {"redisSetByteString", setByteString},
        {"redisGetByteString", getByteString},
        {"isRedisConnected", isConnected},
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}
