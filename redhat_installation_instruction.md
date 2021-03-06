#Installation Guide on Redhat Environment

### protobuf - 2.7.0
https://github.com/google/protobuf/tree/2.7.0
Make sure download the 2.7.0 branch.
``` bash
git clone https://github.com/google/protobuf.git
git checkout 2.7.0
```

Follow the instruction in src/README.md

To build protobuf from source, the following tools are needed:

  * autoconf
  * automake
  * libtool
  * curl (used to download gmock)
  * make
  * g++
  * unzip
  * pkg/config

Type following commands:
``` bash
$ ./autogen.sh
$ ./configure
$ make
$ make check
$ sudo make install
$ sudo ldconfig # refresh shared library cache.
```

### Environment Configuration 
Add environment path
```bash
vim /etc/profile
```

Add following lines bellow to the end of file
```bash
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
```

find the file '.bashrc' under the folder of your username(HOME if your are root user) and then add the line bellow to the end of file
``` bash
source /etc/profile
```

<hr>

### Install Server
Go to Owlies_Server/server/3rd/skynet
``` bash
make clean
make 'linux'
```

Go to Owlies_Server/server/
``` bash
source /etc/profile
make linux
```

### Install Redis Server
cd to installs/redis-3.2.6
``` bash
cd installs/redis-3.2.6
make install MALLOC-libc
```

To start redis server:
``` bash
src/redis-server
```

cd to installs/hiredis
``` bash
cd installs/hiredis
make install
cp libhiredis.so /usr/lib/
cp hiredis.h /usr/include/hiredis/
cp read.h /usr/include/hiredis/
cp sds.h /usr/include/hiredis/
ldconfig
```

then
``` bash
cd server
make clean
make linux
sh startserver.sh
```
if connected to redis then installation conplete!

