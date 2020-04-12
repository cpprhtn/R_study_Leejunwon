#!/usr/bin/perl
# flip_flop.pl - simple multiple-output-page CGI.pm script

use strict;
use warnings;
use CGI qw(:standard);

my $url;
my $this_page;
my $next_page;

# determine which page to display based on absence or presence
# of the pageb parameter

if (!defined (param ("pageb"))) # display page A w/link to page B
{
  $this_page = "A";
  $next_page = "B";
  $url = url () . "?pageb=1";
}
else                            # display page B w/link to page A
{
  $this_page = "B";
  $next_page = "A";
  $url = url ();
}

print header ();
print start_html (-title => "Flip-Flop: Page $this_page",
                  -bgcolor => "white");
print p ("This is Page $this_page. To select Page $next_page, "
         . a ({-href => $url}, "click here"));
print end_html ();

