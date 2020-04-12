#!/usr/bin/perl
# tabular.pl - run a query and print output in tabular (boxed) format

use strict;
use warnings;
use DBI;

# host, user, password are assumed to come from option file

my $dsn = "DBI:mysql:sampdb;mysql_read_default_group=client";
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, undef, undef, \%conn_attrs);

#@ _MAIN_BODY_
my $sth = $dbh->prepare (qq{
            SELECT last_name, first_name, suffix, city, state
            FROM president ORDER BY last_name, first_name
          });
$sth->execute (); # attributes should be available after this call

# actual maximum widths of column values in result set
my @wid = @{$sth->{mysql_max_length}};
# number of columns in result set
my $ncols = $sth->{NUM_OF_FIELDS};

# adjust column widths if data values are narrower than column headings,
# or than the word "NULL" for columns that can be NULL
for (my $i = 0; $i < $ncols; $i++)
{
  my $name_wid = length ($sth->{NAME}->[$i]);
  $wid[$i] = $name_wid if $wid[$i] < $name_wid;
  $wid[$i] = 4 if $sth->{NULLABLE}->[$i] && $wid[$i] < 4;
}

# print tabular-format output
print_dashes (\@wid, $ncols);             # row of dashes
print_row ($sth->{NAME}, \@wid, $ncols);  # column headings
print_dashes (\@wid, $ncols);             # row of dashes
while (my $ary_ref = $sth->fetchrow_arrayref ())
{
  print_row ($ary_ref, \@wid, $ncols);    # row data values
}
print_dashes (\@wid, $ncols);             # row of dashes
#@ _MAIN_BODY_

$dbh->disconnect ();

#@ _PRINT_FUNCTIONS_
sub print_dashes
{
my $wid_ary_ref = shift;  # reference to array of column widths
my $cols = shift;         # number of columns

  for (my $i = 0; $i < $cols; $i++)
  {
    print "+", "-" x ($wid_ary_ref->[$i]+2);
  }
  print "+\n";
}

# print row of data.  (doesn't right-align numeric columns)

sub print_row
{
my $val_ary_ref = shift;  # reference to array of column values
my $wid_ary_ref = shift;  # reference to array of column widths
my $cols = shift;         # number of columns

  for (my $i = 0; $i < $cols; $i++)
  {
    printf "| %-*s ", $wid_ary_ref->[$i],
           defined ($val_ary_ref->[$i]) ? $val_ary_ref->[$i] : "NULL";
  }
  print "|\n";
}
#@ _PRINT_FUNCTIONS_
