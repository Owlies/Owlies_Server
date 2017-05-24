## DB Object

### System Requirement
Use `Lua5.3`

### Design Idea
Here two data base tables/objects are defined, which are user account and user game info. And each head file defines one of these two objects and c file implements the actual methods.

The members of object correspond to columns of table.

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

The lua unit test script for `UserAccount` object is here:
```
useraccount_lua_unit_test.lua
```

The lua unit test script for `UserGameInfo` object is here:
```
usergameinfo_lua_unit_test.lua
```

### Current Errors
#### 1.Fail to load user defined lib
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

##### Reasons: `.so` file name is different from the function name of `luaopen_function_name`.

#### 2.Fail to instantiate user data object
##### Description:
When run the lua script, following error may show up:
```
lua: db_obj_lua_unit_test.lua:9: attempt to index a nil value (global 'dbobjuseraccountlib')
stack traceback:
        db_obj_lua_unit_test.lua:9: in main chunk
        [C]: in ?
```

##### Status: Fixed

##### Reasons: `metatable name` in get/set functions is different from the metatable name defined in `luaopen_function_name`. Thus the functions are fail to register in library. And the value from `require 'lib'` should be assigned to a global variable.


### Unit Test
#### Unit Test result for UserAccount Object
Here is the unit test output:
```
The set UserId : uid_0523 and get UserId : uid_0523
The set Account : music_run_0523 and get Account : music_run_0523
The set Device : Android Nexus 6 and get Device : Android Nexus 6
The set FacebookAccount : https://www.facebook.com/johnson.green.338 and get FacebookAccount : https://www.facebook.com/johnson.green.338
The set GooglePlayAccount : https://plus.google.com/u/0/+BaichuanYANG and get GooglePlayAccount : https://plus.google.com/u/0/+JohnsonGreen
The set Identifier : music_run_uid_0523 and get Identifier : music_run_uid_0523
```
All the get/set function work.

#### Unit Test result for UserGameInfo Object
Here is the unit test output:
```
The set UserId : uid_0523 and get UserId : uid_0523
The set Level : 9 and get Level : 9
The set Exp : 99 and get Exp : 99
The set Game Version : music_run_v1.0 and get Game Version : music_run_v1.0
The set Last Login Time : 2017-05-21 and get Last Login Time : 2017-05-21
```
All the get/set function work.

