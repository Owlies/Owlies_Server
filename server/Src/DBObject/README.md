## DB Object

### System Requirement
Use `Lua5.3`

### Design Idea
Here two data base tables/objects are defined, which are user account and user game info. And each head file defines one of these two objects and c file implements the actual methods.

So `dbobjuseraccountlib.*` file is for user account database object. So do `dbobjusergameinfolib.*` files.

### Compile Command
Here are the two commands to compile and generate the `.so` files as lua library.

```
gcc -Wall -shared -fPIC -o dbobjuseraccountlib.so -I/usr/local/include/ -llua dbobjuseraccountlib.c
gcc -Wall -shared -fPIC -o dbobjusergameinfolib.so -I/usr/local/include/ -llua dbobjusergameinfolib.c
```

Note that `-I` parameter should be assigned the path where `lua.h`, `lualib.h` and `lauxlib.h` locate.

### Lua Unit Test
Right now the script fails to load the user defined library so the unit tests do not work.

A sample lua unit test script is included:
```
db_obj_lua_unit_test.lua
```

### Current Errors
####1.Fail to load user defined lib
##### Description:
When run the lua script, following error may show up:
```
lua: error loading module 'db_object_useraccountlib' from file './db_object_useraccountlib.so':
        ./db_object_useraccountlib.so: undefined symbol: luaopen_db_object_useraccountlib
stack traceback:
        [C]: in ?
        [C]: in function 'require'
        db_obj_lua_unit_test.lua:1: in main chunk
        [C]: in ?
```

##### Status: Fixed

####2.Fail to instantiate user data object
##### Description:
When run the lua script, following error may show up:
```
lua: db_obj_lua_unit_test.lua:9: attempt to index a nil value (global 'dbobjuseraccountlib')
stack traceback:
        db_obj_lua_unit_test.lua:9: in main chunk
        [C]: in ?
```

##### Status: Pending

