#!/usr/bin/perl
# gen_dirs.pl - generate Historical League membership list in various
# output formats
# (this version includes XML format)

use strict;
use warnings;
use DBI;

# host, user, password are assumed to come from option file

my $dsn = "DBI:mysql:sampdb;mysql_read_default_group=client";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);

#@ _TEXT_FORMAT_ENTRY_
sub text_format_entry
{
  printf "%s\n", format_name ($_[0]);
}
#@ _TEXT_FORMAT_ENTRY_

#@ _RTF_INIT_
sub rtf_init
{
  print "{\\rtf0\n";
  print "{\\fonttbl {\\f0 Times;}}\n";
  print "\\plain \\f0 \\fs24\n";
}
#@ _RTF_INIT_

#@ _RTF_CLEANUP_
sub rtf_cleanup
{
  print "}\n";
}
#@ _RTF_CLEANUP_

#@ _RTF_FORMAT_ENTRY_
sub rtf_format_entry
{
my $entry_ref = shift;

  printf "\\b Name: %s\\b0\\par\n", format_name ($entry_ref);
  my $address = "";
  $address .= $entry_ref->{street}
                if defined ($entry_ref->{street});
  $address .= ", " . $entry_ref->{city}
                if defined ($entry_ref->{city});
  $address .= ", " . $entry_ref->{state}
                if defined ($entry_ref->{state});
  $address .= " " . $entry_ref->{zip}
                if defined ($entry_ref->{zip});
  print "Address: $address\\par\n"
                if $address ne "";
  print "Telephone: $entry_ref->{phone}\\par\n"
                if defined ($entry_ref->{phone});
  print "Email: $entry_ref->{email}\\par\n"
                if defined ($entry_ref->{email});
  print "Interests: $entry_ref->{interests}\\par\n"
                if defined ($entry_ref->{interests});
  print "\\par\n";
}
#@ _RTF_FORMAT_ENTRY_

#@ _HTML_INIT_
sub html_init
{
  print "<html>\n";
  print "<head>\n";
  print "<title>U.S. Historical League Member Directory</title>\n";
  print "</head>\n";
  print "<body bgcolor=\"white\">\n";
  print "<h1>U.S. Historical League Member Directory</h1>\n";
}
#@ _HTML_INIT_

#@ _HTML_CLEANUP_
sub html_cleanup
{
  print "</body>\n";
  print "</html>\n";
}
#@ _HTML_CLEANUP_

#@ _HTML_FORMAT_ENTRY_
sub html_format_entry
{
my $entry_ref = shift;

  # Convert &, ", >, and < to the corresponding HTML entities
  # (&amp;, &quot;, &gt, &lt;)
  foreach my $key (keys (%{$entry_ref}))
  {
    next unless defined ($entry_ref->{$key});
    $entry_ref->{$key} =~ s/&/&amp;/g;
    $entry_ref->{$key} =~ s/\"/&quot;/g;
    $entry_ref->{$key} =~ s/>/&gt;/g;
    $entry_ref->{$key} =~ s/</&lt;/g;
  }
  printf "<strong>Name: %s</strong><br />\n", format_name ($entry_ref);
  my $address = "";
  $address .= $entry_ref->{street}
                if defined ($entry_ref->{street});
  $address .= ", " . $entry_ref->{city}
                if defined ($entry_ref->{city});
  $address .= ", " . $entry_ref->{state}
                if defined ($entry_ref->{state});
  $address .= " " . $entry_ref->{zip}
                if defined ($entry_ref->{zip});
  print "Address: $address<br />\n"
                if $address ne "";
  print "Telephone: $entry_ref->{phone}<br />\n"
                if defined ($entry_ref->{phone});
  print "Email: $entry_ref->{email}<br />\n"
                if defined ($entry_ref->{email});
  print "Interests: $entry_ref->{interests}<br />\n"
                if defined ($entry_ref->{interests});
  print "<br />\n";
}
#@ _HTML_FORMAT_ENTRY_

#@ _XML_INIT_
sub xml_init
{
  print "<?xml version=\"1.0\"?>\n";
  print "<members>\n";
}
#@ _XML_INIT_

#@ _XML_CLEANUP_
sub xml_cleanup
{
  print "</members>\n";
}
#@ _XML_CLEANUP_

#@ _XML_FORMAT_ENTRY_
sub xml_format_entry
{
my $entry_ref = shift;

  print "  <member>\n";
  # Convert <, >, ", and & to the corresponding XML entities
  # (&lt;, &gt;, &quot, &amp;)
  foreach my $key (keys (%{$entry_ref}))
  {
    next unless defined ($entry_ref->{$key});
    $entry_ref->{$key} =~ s/&/&amp;/g;
    $entry_ref->{$key} =~ s/\"/&quot;/g;
    $entry_ref->{$key} =~ s/>/&gt;/g;
    $entry_ref->{$key} =~ s/</&lt;/g;
    printf "    <$key>%s</$key>\n", $entry_ref->{$key};
  }
  print "  </member>\n";
}
#@ _XML_FORMAT_ENTRY_

#@ _SWITCHBOX_1_
#@ _SWITCHBOX_WITHOUT_HTML_A_
# switchbox containing formatting functions for each output format
my %switchbox =
(
  "text" =>                 # functions for plain text format
  {
    "init"    => undef,     # no initialization needed
    "entry"   => \&text_format_entry,
    "cleanup" => undef      # no cleanup needed
  },
  "rtf" =>                  # functions for RTF format
  {
    "init"    => \&rtf_init,
    "entry"   => \&rtf_format_entry,
    "cleanup" => \&rtf_cleanup
#@ _SWITCHBOX_WITHOUT_HTML_A_
  },
  "html" =>                 # functions for HTML format
  {
    "init"    => \&html_init,
    "entry"   => \&html_format_entry,
    "cleanup" => \&html_cleanup
#@ _SWITCHBOX_WITHOUT_HTML_B_
  },
  "xml" =>                  # functions for XML format
  {
    "init"    => \&xml_init,
    "entry"   => \&xml_format_entry,
    "cleanup" => \&xml_cleanup
  }
);
#@ _SWITCHBOX_WITHOUT_HTML_B_
#@ _SWITCHBOX_1_

#@ _SWITCHBOX_2_
my $formats = join (" ", sort (keys (%switchbox)));
# make sure one argument was specified on the command line
@ARGV == 1
  or die "Usage: gen_dirx.pl format_type\nPermitted formats: $formats\n";

# determine proper switchbox entry from argument on command line;
# if no entry is found, the format type is invalid
my $func_hashref = $switchbox{$ARGV[0]};

defined ($func_hashref)
  or die "Unknown format: $ARGV[0]\nPermitted formats: $formats\n";
#@ _SWITCHBOX_2_

#@ _MAIN_BODY_
# invoke the initialization function if there is one
&{$func_hashref->{init}} if defined ($func_hashref->{init});

# fetch and print entries if there is an entry formatting function
if (defined ($func_hashref->{entry}))
{
  my $sth = $dbh->prepare (qq{
              SELECT * FROM member ORDER BY last_name, first_name
            });
  $sth->execute ();
  while (my $entry_ref = $sth->fetchrow_hashref ("NAME_lc"))
  {
    # pass entry by reference to the formatting function
    &{$func_hashref->{entry}} ($entry_ref);
  }
}

# invoke the cleanup function if there is one
&{$func_hashref->{cleanup}} if defined ($func_hashref->{cleanup});
#@ _MAIN_BODY_

$dbh->disconnect ();

#@ _FORMAT_NAME_
sub format_name
{
my $entry_ref = shift;

  my $name = $entry_ref->{first_name} . " " . $entry_ref->{last_name};
  if (defined ($entry_ref->{suffix}))     # there is a name suffix
  {
    # no comma for suffixes of I, II, III, etc.
    $name .= "," unless $entry_ref->{suffix} =~ /^[IVX]+$/;
    $name .= " " . $entry_ref->{suffix}
  }
  return ($name);
}
#@ _FORMAT_NAME_
