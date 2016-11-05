#Installation Guide on Redhat Environment

### protobuf - 2.7.0
https://github.com/google/protobuf/tree/2.7.0
Make sure download the 2.7.0 branch.

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

<hr>

### Build protobuf - c from Source
https://github.com/protobuf-c/protobuf-c
Master branch

Run following command:
``` bash
./autogen.sh && ./configure && make && make install
```

<hr>

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
Go to Owlies_Server/server/
``` bash
source /etc/profile
make clean
make all
```
