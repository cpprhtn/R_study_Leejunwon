The scripts in this directory contain the text of the examples used in
Appendix I.

None of them is intended to be executed from your Web server. Instead,
execute them at the command line like this:

% php script_name

For example:

% php error.php

Most of the scripts assume that the sampdb_pdo.php include file
(located in the parent directory) is installed in a directory that
is named in the include_path directive of your php.ini file, and
that the connection parameters in sampdb_pdo.php are set appropriately
to enable you to connect to your MySQL server.
