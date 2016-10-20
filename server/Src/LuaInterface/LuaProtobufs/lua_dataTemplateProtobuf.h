#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "Protobuf/protobufLoaders/protobufDataTemplateLoader.h"

struct _Owlies__Core__ChangeEvents__Item* deserializeProtobuf(void *buf, unsigned sz);
void* serializeProtobuf(struct _Owlies__Core__ChangeEvents__Item message, unsigned* sz);