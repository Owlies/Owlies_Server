include platform.mk

OWLIES_LIBS ?= -lpthread -lm
SHARED ?= --shared

SKYNET_PATH ?= 3rd/skynet
PBC_PATH ?= 3rd/pbc
OWLIES_SRC ?= Src
LUA_INTERFACE_PATH ?= $(OWLIES_SRC)/LuaInterface
LUA_PROTOBUF_INTERFACE_PATH ?= $(OWLIES_SRC)/LuaInterface/LuaProtobufs
LUA_INC ?= $(SKYNET_PATH)/3rd/lua
LUALIB_INC ?= $(SKYNET_PATH)/lualib-src
SKYNET_INC ?= $(SKYNET_PATH)/skynet-src
BUILD_PATH ?= Lib

CFLAGS = -g -O2 -fPIC -Wall -I$(LUA_INC) -I$(LUALIB_INC) -I$(SKYNET_INC) -I$(OWLIES_SRC) -I$(PBC_PATH) -I$(PBC_PATH)/binding/lua53
PROTOBUF_C_COMPILE_FLAG = `pkg-config --cflags 'libprotobuf-c >= 1.0.0'`
PROTOBUF_C_LINK_FLAG = -lprotobuf-c `pkg-config --libs 'libprotobuf-c >= 1.0.0'`

$(BUILD_PATH) :
	mkdir $(BUILD_PATH)

all: skynet pbc $(BUILD_PATH)/physic.so $(BUILD_PATH)/dataTemplateProtobuf.so $(BUILD_PATH)/connectionManager.so

skynet :
	cd $(SKYNET_PATH) && make $(PLAT)
	cp -rpf $(SKYNET_PATH)/skynet skynet

pbc :
	cd $(PBC_PATH) && make
	cd $(PBC_PATH)/binding/lua53 && make


$(BUILD_PATH)/protobufDataTemplateLoader.o : $(OWLIES_SRC)/Protobuf/protobufLoaders/protobufDataTemplateLoader.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) $(PROTOBUF_C_COMPILE_FLAG) -c -o $@ $^
	
$(BUILD_PATH)/ProtoBufDataTemplate.pb-c.o : $(OWLIES_SRC)/Protobuf/protobufs/ProtoBufDataTemplate.pb-c.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) $(PROTOBUF_C_COMPILE_FLAG) -c -o $@ $^
	
$(BUILD_PATH)/physic.so : $(LUA_INTERFACE_PATH)/lua_physic.c | $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^

$(BUILD_PATH)/dataTemplateProtobuf.so : $(BUILD_PATH)/protobufDataTemplateLoader.o $(BUILD_PATH)/ProtoBufDataTemplate.pb-c.o $(LUA_PROTOBUF_INTERFACE_PATH)/lua_dataTemplateProtobuf.c| $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) -o $@ $^ $(PROTOBUF_C_LINK_FLAG)

$(BUILD_PATH)/connectionManager.so : $(BUILD_PATH)/dataTemplateProtobuf.so $(LUA_INTERFACE_PATH)/lua_connectionManager.c| $(BUILD_PATH)
	$(CC) $(CFLAGS) $(SHARED) $(OWLIES_LIBS) $(PROTOBUF_C_LINK_FLAG) -L$(PBC_PATH)/build/ -lpbc -o $@ $^

clean:
	cd $(SKYNET_PATH) && make clean
	cd $(PBC_PATH) && make clean
	cd $(PBC_PATH)/binding/lua53 && make clean
	rm -r -f $(BUILD_PATH)
	rm -f skynet

