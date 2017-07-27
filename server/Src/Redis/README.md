Read Me

To run the unit test here, follow these steps:

1. Follow the Read Me file under DBObject folder to generate the `dbobjuseraccountlib.so`. And then copy the `.so` file
   to this folder.

2. Assume that `hiredis` is installed successfully in the OS. If not, check the Read Me file in this repository.

3. Run the following command to generate `hiredis.so` file for unit test lua program:

```
gcc -Wall -shared -fPIC -o hiredis.so -I/usr/local/include/ -llua -lhiredis hiredis.c
```

4. Run the lua program by this command:

```
lua hiredis_unit_test.lua
```

Note that remember to start redis server. And the port number must be 6379. If not, change the port number in the unit
test file.

5. The output of unit test should be similar as follows:

```
redis ip and port: 127.0.0.1:6379
Init done
The test key is redis-VBC-ENU9-Mwiwj-nUyBhU
Set Redis KV done
Get Redis Value done
The actual value is userid:uid_0523,account:music_run_0523,device:Android Nexus
6,facebookaccount:https://www.facebook.com/johnson.green.338,googleplayaccount:https://plus.google.com/u/0/+JohnsonGreen,identifier:music_run_uid_0523
The expected value is userid:uid_0523,account:music_run_0523,device:Android Nexus
6,facebookaccount:https://www.facebook.com/johnson.green.338,googleplayaccount:https://plus.google.com/u/0/+JohnsonGreen,identifier:music_run_uid_0523
```

The unit test just saves a key value pair to Redis and retrieves the value from the same key, and then compared the valued
returned and the one defined by `useraccount` object before. Here it is obvious that the two values are equal.
