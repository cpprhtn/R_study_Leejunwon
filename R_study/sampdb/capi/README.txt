You might have to edit the Makefile somewhat to get the programs in
this directory to build on your system.

The Makefile assumes that your C and C++ compilers are named gcc and g++.
On systems where that is not true, you can invoke make with CC and CXX
arguments that override the names.  For example, if your compilers are named
cc and c++, you can invoke make like this:

    % make CC=cc CXX=c++ all

Mac OS X note: If when you try to run any of these programs you see an
error like this:

dyld: Library not loaded: libmysqlclient.18.dylib
  Referenced from: .../sampdb/capi/./exec_stmt
  Reason: image not found
Trace/BPT trap

Try setting the DYLD_LIBARARY_PATH environment variable to the library
where your libmysqlclient is installed. For example:

sh: DYLD_LIBRARY_PATH=/usr/local/mysql/lib
tcsh: setenv DYLD_LIBRARY_PATH /usr/local/mysql/lib
