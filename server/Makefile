include platform.mk

OWLIES_LIBS ?= -lpthread -lm
SHARED ?= --shared

SKYNET_PATH ?= 3rd/skynet
OWLIES_SRC ?= Src
LUA_INTERFACE_PATH ?= $(OWLIES_SRC)/LuaInterface
LUA_PROTOBUF_INTERFACE_PATH ?= $(OWLIES_SRC)/LuaInterface/LuaProtobufs
LUA_INC ?= $(SKYNET_PATH)/3rd/lua
LUALIB_INC ?= $(SKYNET_PATH)/lualib-src
SKYNET_INC ?= $(SKYNET_PATH)/skynet-src
HIREDIS_SRC ?= $(OWLIES_SRC)/Redis
BUILD_PATH ?= Lib

CFLAGS = -g -O2 -fPIC -Wall -I$(LUA_INC) -I$(LUALIB_INC) -I$(SKYNET_INC) -I$(OWLIES_SRC)
PROTOBUF_C_COMPILE_FLAG = `pkg-config --cflags 'libprotobuf-c >= 1.0.0'`
PROTOBUF_C_LINK_FLAG = -lprotobuf-c `pkg-config --libs 'libprotobuf-c >= 1.0.0'`
LDFLAGS = -lhiredis

$(BUILD_PATH) :
	mkdir $(BUILD_PATH)

all: skynet $(BUILD_PATH)/physic.so $(BUILD_PATH)/connectionManager.so $(BUILD_PATH)/hiredisExample.so

skynet :
	cd $(SKYNET_PATH) && make $(PLAT)
	cp -rpf $(SKYNET_PATH)/skynet skynet
	
$(BUILD_PATH)/physic.so : $(LUA_INTERFACE_PATH)/lua_physic.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^

$(BUILD_PATH)/connectionManager.so : $(LUA_INTERFACE_PATH)/lua_connectionManager.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^

$(BUILD_PATH)/hiredisExample.so : $(HIREDIS_SRC)/redis_example.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(LDFLAGS) $(OWLIES_LIBS) -o $@ $^

clean:
	cd $(SKYNET_PATH) && make clean
	rm -r -f $(BUILD_PATH)
	rm -f skynet

