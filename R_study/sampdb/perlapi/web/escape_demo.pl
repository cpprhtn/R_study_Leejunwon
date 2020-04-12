#!/usr/bin/perl
# escape_demo.pl - demonstrate CGI.pm output-encoding functions

use strict;
use warnings;
use CGI qw(escapeHTML escape);  # import escapeHTML() and escape()

# Assign default string value, but use command-line argument if present
my $s = "1<=2, right?";
$s = shift (@ARGV) if @ARGV;
print "Unencoded string:             ", $s, "\n";
print "Encoded for use as HTML text: ", escapeHTML ($s), "\n";
print "Encoded for use in a URL:     ", escape ($s), "\n";
