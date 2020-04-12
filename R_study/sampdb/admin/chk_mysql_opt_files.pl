#!/usr/bin/perl
# chk_mysql_opt_files.pl - check user-specific .my.cnf files and make sure
# the ownership and mode is correct. Each file should be owned by the
# user in whose home directory the file is found. The mode should
# have the "group" and "other" permissions turned off.

# This script must be run as root.  Execute it with your password file as
# input.  If you have an /etc/passwd file, run it like this:
#  chk_mysql_opt_file.pl /etc/passwd

use strict;
use warnings;

while (<>)
{
  next if /^#/ || /^\s*$/;           # skip comments, blank lines
  my ($uid, $home) = (split (/:/, $_))[2,5];
  my $cnf_file = "$home/.my.cnf";
  next unless -f $cnf_file;          # is there a .my.cnf file?
  if ((stat ($cnf_file))[4] != $uid) # test ownership
  {
    warn "Changing ownership of $cnf_file to $uid\n";
    chown ($uid, (stat ($cnf_file))[5], $cnf_file);
  }
  my $mode = (stat ($cnf_file))[2];
  if ($mode & 077)                   # test group/other access bits
  {
    warn sprintf ("Changing mode of %s from %o to %o\n",
                  $cnf_file, $mode, $mode & ~077);
    chmod ($mode & ~077, $cnf_file);
  }
}
