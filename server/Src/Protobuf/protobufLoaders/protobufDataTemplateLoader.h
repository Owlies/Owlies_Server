#ifndef PROTOBUF_DATA_TEMPLATE_LOADER
#define PROTOBUF_DATA_TEMPLATE_LOADER

#include "../protobufs/ProtoBufDataTemplate.pb-c.h"

void serializeMessage(struct _Owlies__Core__ChangeEvents__Item *message, void **buf, unsigned *len);
struct _Owlies__Core__ChangeEvents__Item deserializeMessage(void *buf, unsigned len);

#endif