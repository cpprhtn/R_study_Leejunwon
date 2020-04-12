# This code shows how to use a Windows pathname as the value
# of the mysql_read_default_file option in a data source name (DSN)
# string.  Normally, pathnames that begin with a drive letter and colon
# will fail because DBI uses colon as the DSN component separator.
# By cd-ing to the drive root directory before connecting, the filename
# can be specified without the drive letter and colon.  The code here
# also saves the current directory first and changes back to it after
# connecting; This leaves the current directory undisturbed by the
# connect() operation.

use strict;
use DBI;

#@ _FRAG_
# save current directory pathname
use Cwd;
my $orig_dir = cwd ();
# change location to root dir of drive where file is located
chdir ("C:/") or die "Cannot chdir: $!\n";
# connect using parameters in C:\my.ini
my $dsn = "DBI:mysql:sampdb:localhost;mysql_read_default_file=/my.ini";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);
# change location back to original directory
chdir ($orig_dir) or die "Cannot chdir: $!\n";
#@ _FRAG_

$dbh->disconnect ();
