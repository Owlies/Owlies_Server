
OWLIES_LIBS ?= -lpthread -lm
SHARED ?= -fPIC --shared

SKYNET_PATH ?= 3rd/skynet
LUA_INTERFACE_PATH ?= Src/LuaInterface
LUA_INC ?= $(SKYNET_PATH)/3rd/lua
LUALIB_INC ?= $(SKYNET_PATH)/lualib-src
SKYNET_INC ?= $(SKYNET_PATH)/skynet-src
BUILD_PATH ?= Lib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) -I$(LUALIB_INC) -I$(SKYNET_INC)

$(BUILD_PATH) :
	mkdir $(BUILD_PATH)

all: skynet $(BUILD_PATH)/physic.so $(BUILD_PATH)/protobufLoader.so

skynet : 3rd/skynet/Makefile
	cd $(SKYNET_PATH) && make linux
	cp -rpf $(SKYNET_PATH)/skynet skynet

$(BUILD_PATH)/physic.so : $(LUA_INTERFACE_PATH)/lua_physic.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^

$(BUILD_PATH)/protobufLoader.so : $(LUA_INTERFACE_PATH)/lua_protobufLoader.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^
clean:
	cd $(SKYNET_PATH) && make clean
	rm -f $(BUILD_PATH)/*.so
	rm -f skynet

