#include <lua.h>
#include <lauxlib.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <hiredis/hiredis.h>
#include <hiredis/async.h>

#define MAX_RETRY_TIMES 5
#define STOP_RETRY_SECONDS 1

char * REDIS_SET_BYTE_STRING_ERROR = "Fail to send key-value pair to Redis due to connection failure";
char * REDIS_GET_BYTE_STRING_ERROR = "Fail to get key-value pair from Redis due to connection failure";

typedef struct clientconfig {
    char *ip;
    int port;
    struct timeval *timeout;
};

static struct clientconfig config;

static redisContext *context;

static struct timeval default_timeout = {1,500000};


redisContext * connect_redis();
int ping(redisContext *context);

redisContext *c;

static int init(lua_State *L) {
    config.ip = lua_tostring(L, 1);
    config.port = lua_tointeger(L, 2);
    config.timeout = &default_timeout;
    printf("redis ip and port: %s:%d\n", config.ip, config.port);

    context = NULL;
    int retry_time = 0;

    while(retry_time < MAX_RETRY_TIMES){
        ++ retry_time;
        context = connect_redis();        
        if(ping(context) != -1)
            break;
        sleep(STOP_RETRY_SECONDS);
    }

    if(retry_time >= MAX_RETRY_TIMES) {
        printf("Already tried many times to connect to Redis but all failed.");
        if(context)
            redisFree(context);
        exit(1);
    }
    //lua_pushlightuserdata(L, context);
    return 1;
}

redisContext * connect_redis() {
    if( c != NULL )
        redisFree(c);
    c = redisConnectWithTimeout(config.ip, config.port, *(config.timeout));
    if (c == NULL || c->err) {
        if (c) {
            printf("Connection error: %s\n", c->errstr);
            redisFree(c);
        } else {
            printf("Connection error: can't allocate redis context\n");
        }
        return NULL;
    }
    return c;
}

static int disconnect(lua_State *L) {
   // redisContext *context = lua_touserdata(L, 1);
    redisFree(context);
    return 0;
}

static int setByteString(lua_State *L) {
    const char *key = lua_tostring(L, 1);
    const char *value = lua_tostring(L, 2);
    int sz = lua_tointeger(L, 3);

    int retry_time = 0;

    //If ping redis fails, rebuild the connection and ensure that new connection is working/pinged.
    if(ping(context) == -1) {
        while(retry_time < MAX_RETRY_TIMES){
            ++ retry_time;
            context = connect_redis();
            if(ping(context) != -1)
                break;
            sleep(STOP_RETRY_SECONDS);
        }
    }
    
    if(retry_time >= MAX_RETRY_TIMES) {
        printf("Already tried many times to connect to Redis but all failed.");
        if(context)
            redisFree(context);
        lua_pushlstring(L, REDIS_SET_BYTE_STRING_ERROR, "62");
        return 1;
    }

 
    redisReply *reply;
    reply = redisCommand(context, "SET %s %b", key, value, (size_t)sz);

    //Note: reply->str can contain error information
    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;

    return 1;
}

static int getByteString(lua_State *L) {
    const char *key = lua_tostring(L, 1);

    int retry_time = 0;

    //If ping redis fails, rebuild the connection and ensure that new connection is working/pinged.
    if(ping(context) == -1) {
        while(retry_time < MAX_RETRY_TIMES){
            ++ retry_time;
            context = connect_redis();
            if(ping(context) != -1)
                break;
            sleep(STOP_RETRY_SECONDS);
        }
    }

    if(retry_time >= MAX_RETRY_TIMES) {
        printf("Already tried many times to connect to Redis but all failed.");
        if(context)
            redisFree(context);
        lua_pushlightuserdata(L, context);
        lua_pushlstring(L, REDIS_GET_BYTE_STRING_ERROR, "63");
        return 1;
    }

    redisReply *reply;
    reply = redisCommand(context, "GET %s", key);

    //Note: reply->str can contain error information
    lua_pushlstring(L, reply->str, reply->len);

    freeReplyObject(reply);
    reply = NULL;
    return 1;
}

int ping(redisContext *context) {
    if(context == NULL)
        return -1;
    redisReply *reply;
    reply = redisCommand(context, "PING");
    int res = -1;
    if (strcmp(reply->str, "PONG") == 0) {
        res = 0;
    }

    freeReplyObject(reply);
    return res;
}

int luaopen_hiredis(lua_State *L) {
	luaL_checkversion(L);

	luaL_Reg l[] = {
        {"redisInit", init},
        {"redisDisconnect", disconnect},
        {"redisSetByteString", setByteString},
        {"redisGetByteString", getByteString},
		{ NULL, NULL },
	};

	luaL_newlib(L, l);

	return 1;
}
