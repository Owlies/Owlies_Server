#ifndef PROTOBUF_DATA_TEMPLATE_LOADER
#define PROTOBUF_DATA_TEMPLATE_LOADER

#include "Protobuf/protobufs/ProtoBufDataTemplate.pb-c.h"

void serializeMessageWithSize(struct _Owlies__Core__ChangeEvents__Item *message, void **buf, unsigned size);
void serializeMessage (struct _Owlies__Core__ChangeEvents__Item *message, void **buf);
void serializeMessageWithLenOutput(struct _Owlies__Core__ChangeEvents__Item *message, void **buf, unsigned *len);
struct _Owlies__Core__ChangeEvents__Item deserializeMessage(void *buf, unsigned len);

#endif