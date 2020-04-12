#!/usr/bin/perl
# url.pl - show how to add parameters to URLs

use strict;
use warnings;
use CGI qw(:standard escapeHTML escape);

my $url;

# URL-construction without encoding functions

#@ _MAKE_URL_1_
$url = url ();          # get URL for script
$url .= "?size=large";  # add first parameter
$url .= ";color=blue";  # add second parameter
#@ _MAKE_URL_1_
#@ _PRINT_URL_1_
print a ({-href => $url}, "Click Me!");
#@ _PRINT_URL_1_
print "\n";

# URL-construction with encoding functions (store param values and
# label in variables to emphasize that you may not know just what the
# content of the params and label are when you construct the URL).

my $size = "large";
my $color = "blue";
my $label = "Click Me!";
#@ _MAKE_URL_2_
$url = url ();
$url .= "?size=" . escape ($size);
$url .= ";color=" . escape ($color);
#@ _MAKE_URL_2_
#@ _PRINT_URL_2_
print a ({-href => $url}, escapeHTML ($label));
#@ _PRINT_URL_2_
print "\n";

# URL-construction with encoding functions, method 2

#@ _MAKE_URL_3_
$url = sprintf ("%s?size=%s;color=%s",
                url (), escape ($size), escape ($color));
#@ _MAKE_URL_3_
#@ _PRINT_URL_3_
print a ({-href => $url}, escapeHTML ($label));
#@ _PRINT_URL_3_
print "\n";
