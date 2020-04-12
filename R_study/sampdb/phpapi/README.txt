This directory contains the PHP scripts used in Chapter 9.  To use them
with your Web server, create two directories named gp and ushl under your
server's document root and install the scripts in the corresponding
directories here into them.

appfrag
	Directory containing the examples from Appendix I
gp
	Directory containing Grade-Keeping Project scripts
ushl
	Directory containing U.S. Historical League scripts

hello.php
	"hello, world" script that can be run from the command line if you
	have a standalone version of PHP:
		% php hello.php
sampdb_pdo.php
    This is an include file that should should be installed in a PHP
    include file directory (e.g., /usr/local/apache/lib/php).  The
    pathname of this directory should be listed in the value of the
    include_path configuration setting in your PHP initialization file,
    php.ini.

Any files installed for use by your Web server must be readable to
the user or group that the server runs as.  One way to do this is to
set the user or group ownership of the files to those used by the
server.  Another is to make the files world readable, though this
is not a good idea for any file that contains MySQL username or
password connection parameters.

Gentoo Linux note:

The PHP ebuild needs to be built with PDO and MySQL support. Use
the mysql and pdo USE flags when you emerge PHP.

The PHP ebuild may be built with the ctype_xxx() functions disabled
by default. To make sure that these functions are enabled, use the
ctype USE flag when you emerge PHP.

Alternatively, add the flags to /etc/portage/package.use.
I use these flags:

dev-lang/php mysql pdo ctype
