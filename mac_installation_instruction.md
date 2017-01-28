#Installation Guide on Mac Environment

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

create .bash_profile under root folder, add:
``` bash
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
```

### Install Server
Go to Owlies_Server/server/3rd/skynet
``` bash
make clean
make macosx
```

Go back to Owlies_Server/server/
``` bash
make clean
make macosx
```

* if see error: 
   Src/Protobuf/protobufs/ProtoBufDataTemplate.pb-c.h:7:10: fatal error: 
      'protobuf-c/protobuf-c.h' file not found
* update Xcode : https://github.com/citusdata/cstore_fdw/issues/40

install luarocks:
https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Mac-OS-X
follow the manual install instructions
"configure", "make", "make install"

then install lpeg:
luarocks install lpeg

### Install Redis Server
cd to installs/redis-3.2.6
make install

cd to installs/hiredis
make install

To start redis server:
redis-server

