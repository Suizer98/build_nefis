# build_nefis

## Description

This projects aim to compile libNefis.a and libNefis.so so it can be used for https://github.com/Suizer98/nefis2nc.

This directory is checked out from: 
https://svn.oss.deltares.nl/repos/delft3d/trunk/src/utils_lgpl/nefis/
using SVN.
There might be some dependencies or files that Make will look for througout the 
repository.

Tech stacks:
![Tech stacks](https://skillicons.dev/icons?i=c,cmake,docker,ubuntu,bash)

## Current progress

### Latest updates
- Currently we did a roundabout way to compile the libNefis.so from the libNefis.a instead. Since the static library file is created successfully we can assume it is solid.
- The hack is to run our own gcc compile command and try to resolve any undefined symbols, luckily there is only one important symbol needed to be defined properly (see gp.c part)

```
WORKDIR /app/packages/nefis/src/.libs
RUN find . -name "libNefis.a"
RUN gcc -shared -o libNefis.so -Wl,--no-undefined -Wl,--whole-archive libNefis.a -Wl,--no-whole-archive
```

### Previous updates
- The libNefis.a (static library file) can be created successfully, while the libNefis.so remained failed in *make* command. We can obtain it after running *docker-compose up --build* or so to access the file
```
29.95 libtool: link: ar cr .libs/libNefis.a .libs/c2c.o .libs/df.o .libs/er.o .libs/f2c.o .libs/gp.o .libs/gt.o .libs/hs.o .libs/nefis_version.o .libs/oc.o .libs/pt.o .libs/rt.o .libs/wl-xdr.o
29.96 libtool: link: ranlib .libs/libNefis.a
29.97 libtool: link: ( cd ".libs" && rm -f "libNefis.la" && ln -s "../libNefis.la" "libNefis.la" )
29.98 make[5]: Leaving directory '/app/packages/nefis/src'
29.98 make[4]: Leaving directory '/app/packages/nefis/src'
29.98 Making all in src_so
29.98 make[4]: *** No rule to make target 'all'.  Stop.
29.98 make[4]: Entering directory '/app/packages/nefis/src_so'
29.98 make[4]: Leaving directory '/app/packages/nefis/src_so'
29.98 make[3]: *** [Makefile:405: all-recursive] Error 1
29.98 make[3]: Leaving directory '/app/packages/nefis'
29.98 make[2]: Leaving directory '/app/packages'
29.98 make[2]: *** [Makefile:404: all-recursive] Error 1
29.98 make[1]: *** [Makefile:457: all-recursive] Error 1
29.98 make[1]: Leaving directory '/app'
29.98 make: *** [Makefile:388: all] Error 2
------
Dockerfile:33
--------------------
  31 |     RUN dos2unix autogen.sh
  32 |     # RUN autoreconf -i
  33 | >>> RUN ./build.sh
  34 |
--------------------
ERROR: failed to solve: process "/bin/sh -c ./build.sh" did not complete successfully: exit code: 2
```

## Debugging

- To debug this in dockerfile, run below in terminal:
```
docker build -t build_nefis .
docker run -it --rm build_nefis /bin/bash
OR
docekr-compose up --build

make clean
./configure --help
./configure CFLAGS=-WERROR 
```

## Modified files:

1. build.sh
- Hidding *make check* part for now
```
File: \\wsl$\Ubuntu-20.04\home\suizer\sven\nefis\build.sh
8: # echo "running make check, results into test/testresults.txt"
9: # make check > test/testresults.txt 2> test/testresults.txt
```

2. oc.c
- Added one more argument FILE_MODE for **open** function
```
File: \\wsl$\Ubuntu-20.04\home\suizer\sven\nefis\packages\nefis\src\oc.c
1210:   fds = FILE_OPEN( file_name, FILE_READ_ONLY, FILE_MODE );
...
1288:     if ( fds == -1 )
1289:     {
1290:         if ( acType == FILE_CREATE )
1291:         {
1292:             fds   = FILE_OPEN( file_name, acType, FILE_MODE );
1293:         }
1294:         else
1295:         {
1296:             fds   = FILE_OPEN( file_name, acType, FILE_MODE );
1297:         }
1298:     }

```

3. gp.c
- Forcefully defined FILE_SEEK as lseek, see line 80:
```
File: \\wsl.localhost\Ubuntu-20.04\home\suizer\build_nefis\packages\nefis\src\gp.c
46: #include <unistd.h> /* grep -r "lseek64" /usr/include and it showed this file */
...
69: #if defined(_WIN32)
70: #  define FILE_READ  _read
71: #  define FILE_SEEK  _lseeki64
72: #  define FILE_WRITE _write
73: #elif defined(linux)
74: #  define FILE_READ  read
75: #  if defined(HAVE_LSEEK64)
76: #    define FILE_SEEK lseek64
77: #  elif defined(HAVE_LSEEK)
78: #    define FILE_SEEK lseek
79: #  else
80: #    define FILE_SEEK lseek /* originally this was FILE_SEEK_not_defined, I forced defined it as lseek */
81: #  endif
82: #  define FILE_WRITE write
83: #else
84: #  define FILE_READ  FILE_READ_not_defined
85: #  define FILE_SEEK  FILE_SEEK_not_defined
86: #  define FILE_WRITE FILE_WRITE_not_defined
87: #endif

```

4. nefis_version.h
- Copy and renamed *nefis_version.h.svn* into *nefis_version.h* then placed in /packages/nefis/src & packages/nefis/src_so

5. update_version.sh
- SVN Checked out https://svn.oss.deltares.nl/repos/delft3d/trunk/src/scripts_lgpl/ so *make* can find update_version.sh



