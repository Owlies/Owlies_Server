include ./3rd/skynet/platform.mk

OWLIES_LIBS ?= -lpthread -lm
SHARED ?= -fPIC --shared

SKYNET_PATH ?= 3rd/skynet
PROTOBUF_PATH ?= 3rd/protobuf-c
OWLIES_SRC ?= Src
LUA_INTERFACE_PATH ?= $(OWLIES_SRC)/LuaInterface
LUA_INC ?= $(SKYNET_PATH)/3rd/lua
LUALIB_INC ?= $(SKYNET_PATH)/lualib-src
SKYNET_INC ?= $(SKYNET_PATH)/skynet-src
BUILD_PATH ?= Lib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) -I$(LUALIB_INC) -I$(SKYNET_INC) -I$(PROTOBUF_PATH) -I$(OWLIES_SRC) 
PROTOBUF_C_COMPILE_FLAG = pkg-config --cflags 'libprotobuf-c >= 1.0.0'
PROTOBUF_C_LINK_FLAG = -lprotobuf-c

$(BUILD_PATH) :
	mkdir $(BUILD_PATH)

all: skynet $(BUILD_PATH)/physic.so $(BUILD_PATH)/protobufLoader.so

skynet : 3rd/skynet/Makefile
	cd $(SKYNET_PATH) && make linux
	cp -rpf $(SKYNET_PATH)/skynet skynet

$(BUILD_PATH)/protobufDataTemplateLoader.o : $(OWLIES_SRC)/Protobuf/protobufLoaders/protobufDataTemplateLoader.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -c -o $@ $^
	
$(BUILD_PATH)/ProtoBufDataTemplate.pb-c.o : $(OWLIES_SRC)/Protobuf/protobufs/ProtoBufDataTemplate.pb-c.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(PROTOBUF_C_COMPILE_FLAG) $(SHARED) $(OWLIES_LIBS) -c -o $@ $^
	
$(BUILD_PATH)/physic.so : $(LUA_INTERFACE_PATH)/lua_physic.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^

$(BUILD_PATH)/protobufLoader.so : $(BUILD_PATH)/protobufDataTemplateLoader.o $(BUILD_PATH)/ProtoBufDataTemplate.pb-c.o $(LUA_INTERFACE_PATH)/lua_protobufLoader.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^ $(PROTOBUF_C_LINK_FLAG)

clean:
	cd $(SKYNET_PATH) && make clean
	rm -f $(BUILD_PATH)/*.so
	rm -f skynet

