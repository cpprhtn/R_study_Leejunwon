#!/usr/bin/perl
# cgiskel.pl - CGI skeleton script (using CGI.pm function call interface).
#@ _PREAMBLE_

use strict;
use warnings;
use DBI;
#@ _USE_CGI_
use CGI qw(:standard);
#@ _USE_CGI_

use Cwd;
# option file that should contain connection parameters for UNIX
my $option_file = "/usr/local/apache/conf/sampdb.cnf";
my $option_drive_root;
# override file location for Windows
if ($^O =~ /^MSWin/i || $^O =~ /^dos/)
{
  $option_drive_root = "C:/";
  $option_file = "/Apache/conf/sampdb.cnf";
}

# construct data source and connect to server (under Windows, save
# current working directory first, change location to option file
# drive, connect, and restore current directory)
my $orig_dir;
if (defined ($option_drive_root))
{
  $orig_dir = cwd ();
  chdir ($option_drive_root)
    or die "Cannot chdir to $option_drive_root: $!\n";
}
my $dsn = "DBI:mysql:sampdb;mysql_read_default_file=$option_file";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);
if (defined ($option_drive_root))
{
  chdir ($orig_dir)
    or die "Cannot chdir to $orig_dir: $!\n";
}
#@ _PREAMBLE_

#@ _MAIN_BODY_
my $title = "Page Title";

print header ();
print start_html (-title => $title, -bgcolor => "white");

#@ _HEADER1_
print h1 ("This is a header");
#@ _HEADER1_
#@ _PARA_
print p ("This is a paragraph");
#@ _PARA_

# ... produce rest of document body here ...

print end_html ();
#@ _MAIN_BODY_

$dbh->disconnect ();
