#!/usr/bin/perl
# dbi-version.pl - display DBI and DBD::mysql versions
use DBI;
print "DBI::VERSION: $DBI::VERSION\n";
use DBD::mysql;
print "DBD::mysql::VERSION: $DBD::mysql::VERSION\n";
