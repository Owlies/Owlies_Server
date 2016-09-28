#include <stdio.h>
#include <stdlib.h>
#include "protobufDataTemplateLoader.h"

void serializeMessageWithSize(struct _Owlies__Core__ChangeEvents__Item *message, void **buf, unsigned len) {
    (*buf) = malloc(len);
    owlies__core__change_events__item__pack(message, *buf);
}

void serializeMessage (struct _Owlies__Core__ChangeEvents__Item *message, void **buf) {
    unsigned len = owlies__core__change_events__item__get_packed_size(message);
    (*buf) = malloc(len);
    owlies__core__change_events__item__pack(message, *buf);
}

void serializeMessageWithLenOutput (struct _Owlies__Core__ChangeEvents__Item *message, void **buf, unsigned *len) {
    (*len) = owlies__core__change_events__item__get_packed_size(message);
    (*buf) = malloc((*len));
    owlies__core__change_events__item__pack(message, *buf);
}

struct _Owlies__Core__ChangeEvents__Item deserializeMessage(void *buf, unsigned len) {
    struct _Owlies__Core__ChangeEvents__Item* message = owlies__core__change_events__item__unpack(NULL, len, buf);
    if (message == NULL) {
        printf("error deserializing message\n");
        exit(1);
    }

    return (*message);
}