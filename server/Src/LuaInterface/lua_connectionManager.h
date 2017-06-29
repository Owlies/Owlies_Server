#ifndef OWLIES_CONNECTION_MANAGER
#define OWLIES_CONNECTION_MANAGER

int onReceiveProtobuf (lua_State *L);
void* getProtobufFromTypeString(const char *typeString, char* buf, int sz);

#endif