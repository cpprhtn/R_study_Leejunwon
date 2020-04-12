#!/usr/bin/perl
# param.pl - show how to get input parameters in Web scripts

# invoke like this from the command line:
# param.pl "my_param=value"
# or like this to supply no parameters:
# param.pl ""

use strict;
use warnings;
use CGI qw(:standard);

#@ _PARAM_NAMES_
my @param = param ();
#@ _PARAM_NAMES_
print "Parameter names: @param\n";

print "Parameter values:\n";
foreach my $param (@param)
{
  print $param, " = ", param ($param), "\n";
}

#@ _TEST_MY_PARAM_
my $my_param = param ("my_param");
print "my_param value: ", (defined ($my_param) ? $my_param : "not set"), "\n";
#@ _TEST_MY_PARAM_
