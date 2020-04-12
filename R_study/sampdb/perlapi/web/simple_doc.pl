#!/usr/bin/perl
# simple_doc.pl - produce simple HTML page

use strict;
use warnings;
use CGI qw(:standard);

print header ();
print start_html (-title => "My Simple Page", -bgcolor => "white");
print h1 ("Page Heading");
print p ("Paragraph 1.");
print p ("Paragraph 2.");
print end_html ();
