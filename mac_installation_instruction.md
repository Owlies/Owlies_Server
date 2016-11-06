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
<hr>

### Build protobuf - c from Source
https://github.com/protobuf-c/protobuf-c
Master branch

Run following command:
``` bash
./autogen.sh && ./configure && make && make install
```

<hr>

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

