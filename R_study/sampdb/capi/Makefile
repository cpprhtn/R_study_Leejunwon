# C and C++ compilers
CC = gcc
CXX = g++

# Use these settings if you have mysql_config.  Note that if you have
# multiple installations of MySQL, you can compile with the client
# library from any of them by changing the value of MYSQL_CONFIG to
# the full pathname of the version of mysql_config that you want to
# use.
MYSQL_CONFIG = mysql_config
INCLUDES = ${shell $(MYSQL_CONFIG) --include}
LIBS = ${shell $(MYSQL_CONFIG) --libs}
EMBLIBS = ${shell $(MYSQL_CONFIG) --libmysqld-libs}

# Use these settings if you don't have mysql_config; modify as necessary
#INCLUDES = -I/usr/local/mysql/include/mysql
#LIBS = -L/usr/local/mysql/lib/mysql -lmysqlclient #-lm -lsocket -lnsl
#EMBLIBS = -L/usr/local/mysql/lib/mysql -lmysqld #-lm -lsocket -lnsl

ALL_PROGRAMS = connect1 show_argv show_opt connect2 exec_stmt \
	exec_stmt_ssl exec_stmt_multi embapp prepared stats binary metadata \
	protocol prepared_call

default::
	@echo "You must say what you want to build.  For example:"
	@echo "make all - build all programs"
	@echo "make progname - build the 'progname' program"
	@echo "Permitted values of progname include:"
	@echo "$(ALL_PROGRAMS)"

all:: $(ALL_PROGRAMS)

.c.o:
	$(CC) -c $(INCLUDES) $<

# Simple connect and disconnect

connect1:: connect1.o
	$(CC) -o $@ connect1.o $(LIBS)

# Show effect of load_defaults() on argument vector

show_argv:: show_argv.o
	$(CC) -o $@ show_argv.o $(LIBS)

# Show how to process command-line options

show_opt:: show_opt.o
	$(CC) -o $@ show_opt.o $(LIBS)

# Connect and disconnect, and process command line options

connect2:: connect2.o
	$(CC) -o $@ connect2.o $(LIBS)

# Simple statement-execution client

exec_stmt.o: exec_stmt.c \
	process_statement.c \
	process_result_set.c
exec_stmt:: exec_stmt.o
	$(CC) -o $@ exec_stmt.o $(LIBS)

# SSL-capable version of exec_stmt

exec_stmt_ssl.o: exec_stmt_ssl.c \
	process_statement.c \
	process_result_set.c
exec_stmt_ssl:: exec_stmt_ssl.o
	$(CC) -o $@ exec_stmt_ssl.o $(LIBS)

# multiple-statement execution-capable version of exec_stmt_ssl

exec_stmt_multi.o: exec_stmt_multi.c \
	process_multi_statement.c \
	process_result_set.c
exec_stmt_multi:: exec_stmt_multi.o
	$(CC) -o $@ exec_stmt_multi.o $(LIBS)

# embedded-server app.  Note that it links in EMBLIBS

embapp.o: embapp.c \
	process_statement.c \
	process_result_set.c
embapp:: embapp.o
	$(CXX) -o $@ embapp.o $(EMBLIBS)

# Prepared-statement demonstration

prepared.o: prepared.c \
	process_prepared_statement.c \
	process_result_set.c
prepared:: prepared.o
	$(CXX) -o $@ prepared.o $(LIBS)

stats.o: stats.c summary_stats.c
stats:: stats.o
	$(CC) -o $@ stats.o $(LIBS)

binary.o: binary.c load_image.c
binary:: binary.o
	$(CC) -o $@ binary.o $(LIBS)

metadata.o: metadata.c \
	process_statement.c \
	process_result_meta.c
metadata:: metadata.o
	$(CC) -o $@ metadata.o $(LIBS)

# version of exec_stmt that understands --protcol

protocol.o: protocol.c \
	process_statement.c \
	process_result_set.c
protocol:: protocol.o
	$(CC) -o $@ protocol.o $(LIBS)

prepared_call.o: prepared_call.c
prepared_call:: prepared_call.o
	$(CC) -o $@ prepared_call.o $(LIBS)

clean::
	rm -f $(ALL_PROGRAMS) *.o
