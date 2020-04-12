#!/usr/bin/perl
# edit_member.pl - edit Historical League member entries from the command line

# program ignores validation currently

use strict;
use warnings;
use DBI;

# parse connection parameters from command line if given

use Getopt::Long;
$Getopt::Long::ignorecase = 0; # options are case sensitive
$Getopt::Long::bundling = 1;   # -uname = -u name, not -u -n -a -m -e

# default parameters - all undefined initially
my ($host_name, $password, $port_num, $socket_name, $user_name);

GetOptions (
  # =i means an integer value is required after option
  # =s means a string value is required after option
  "host|h=s"      => \$host_name,
  "password|p=s"  => \$password,
  "port|P=i"      => \$port_num,
  "socket|S=s"    => \$socket_name,
  "user|u=s"      => \$user_name
) or exit (1);

# construct data source
my $dsn = "DBI:mysql:sampdb";
$dsn .= ";host=$host_name" if $host_name;
$dsn .= ";port=$port_num" if $port_num;
$dsn .= ";mysql_socket=$socket_name" if $socket_name;
$dsn .= ";mysql_read_default_group=client";

# connect to server
my %conn_attrs = (RaiseError => 1, PrintError => 0, AutoCommit => 1);
my $dbh = DBI->connect ($dsn, $user_name, $password, \%conn_attrs);

#@ _GET_COL_INFO_
my @col_name = ();       # array of column names
my %nullable = ();       # column nullability, keyed on column name
# get member table column names
my $sth = $dbh->prepare (qq{
            SELECT COLUMN_NAME, UPPER(IS_NULLABLE)
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ?
          });
$sth->execute ("sampdb", "member");
while (my ($col_name, $is_nullable) = $sth->fetchrow_array ())
{
  push (@col_name, $col_name);
  $nullable{$col_name} = ($is_nullable eq "YES");
}
#@ _GET_COL_INFO_

#@ _MAIN_LOOP_
if (@ARGV == 0) # if no arguments were given, create a new entry
{
  # pass reference to array of column names
  new_member (\@col_name);
}
else            # otherwise edit entries using arguments as member IDs
{
  # save @ARGV, then empty it so that when the script reads from
  # STDIN, it doesn't interpret @ARGV contents as input filenames
  my @id = @ARGV;
  @ARGV = ();
  # for each ID value, look up the entry, then edit it
  while (my $id = shift (@id))
  {
    $sth = $dbh->prepare (qq{
             SELECT * FROM member WHERE member_id = ?
           });
    $sth->execute ($id);
    my $entry_ref = $sth->fetchrow_hashref ();
    $sth->finish ();
    if (!$entry_ref)
    {
      warn "No member exists with member ID = $id\n";
      next;
    }
    # pass reference to array of column names and reference to entry
    edit_member (\@col_name, $entry_ref);
  }
}
#@ _MAIN_LOOP_

$dbh->disconnect ();

# ask a question, prompt for an answer

#@ _X_PROMPT_
sub prompt
{
my $str = shift;

  print STDERR $str;
  chomp ($str = <STDIN>);
  return ($str);
}
#@ _X_PROMPT_

# Given a column name and a reference to an entry hash, prompt for
# a new column value.  If the hash is not undef, show the current
# column value in the prompt so user can see it.

# NOTE:
# This is the version originally described in the book.  col_prompt()
# as follows is the modified version that validates the expiration date.
# To use this version instead, rename col_prompt to col_prompt1, and
# and rename col_prompt0 to col_prompt.

sub col_prompt0
#@ _COL_PROMPT0_
{
my ($col_name, $entry_ref) = @_;

  my $prompt = $col_name;
  if (defined ($entry_ref))
  {
    my $cur_val = $entry_ref->{$col_name};
    $cur_val = "NULL" if !defined ($cur_val);
    $prompt .= " [$cur_val]";
  }
  $prompt .= ": ";
  print STDERR $prompt;
  my $str = <STDIN>;
  chomp ($str);
  return ($str);
}
#@ _COL_PROMPT0_

# prompt for a column value; show current value in prompt if
# $show_current is true

sub col_prompt
#@ _COL_PROMPT1_
{
my ($col_name, $entry_ref) = @_;

loop:
  my $prompt = $col_name;
  if (defined ($entry_ref))
  {
    my $cur_val = $entry_ref->{$col_name};
    $cur_val = "NULL" if !defined ($cur_val);
    $prompt .= " [$cur_val]";
  }
  $prompt .= ": ";
  print STDERR $prompt;
  my $str = <STDIN>;
  chomp ($str);
  # perform rudimentary check on the expiration date
  if ($str && $col_name eq "expiration")  # check expiration date format
  {
    if ($str !~ /^\d+\D\d+\D\d+$/)
    {
      warn "$str is not a legal date, try again\n";
      goto loop;
    }
  }
  return ($str);
}
#@ _COL_PROMPT1_

# display contents of an entry

sub show_member
{
# references to an array of column names and to the entry hash
my ($col_name_ref, $entry_ref) = @_;

  print "\n";
  foreach my $col_name (@{$col_name_ref})
  {
    my $col_val = $entry_ref->{$col_name};
    $col_val = "NULL" if !defined ($col_val);
    printf "%s: %s\n", $col_name, $col_val;
  }
}

# create new member entry

#@ _NEW_MEMBER_
sub new_member
{
my $col_name_ref = shift; # reference to array of column names
my $entry_ref = { };    # create new entry as a hash

  return unless prompt ("Create new entry (y/n)? ") =~ /^y/i;
  # prompt for new values; user types in new value, or Enter
  # to leave value unchanged, "NONE" to clear the value, or
  # "EXIT" to exit without creating the record.
  foreach my $col_name (@{$col_name_ref})
  {
    next if $col_name eq "member_id";   # skip key field
    my $col_val = col_prompt ($col_name, undef);
    next if $col_val eq "";             # user pressed Enter
    return if uc ($col_val) eq "EXIT";  # early exit
    if (uc ($col_val) eq "NONE")
    {
      # enter NULL if column is nullable, empty string otherwise
      $col_val = ($nullable{$col_name} ? undef : "");
    }
    $entry_ref->{$col_name} = $col_val;
  }
  # show values, ask for confirmation before inserting
  show_member ($col_name_ref, $entry_ref);
  return unless prompt ("\nInsert this entry (y/n)? ") =~ /^y/i;

  # construct an INSERT query, then issue it.
  my $stmt = "INSERT INTO member";
  my $delim = " SET "; # put "SET" before first column, "," before others
  foreach my $col_name (@{$col_name_ref})
  {
    # only specify values for columns that were given one
    next if !defined ($entry_ref->{$col_name});
    # quote() quotes undef as the word NULL (without quotes),
    # which is what we want.  Columns that are NOT NULL are
    # assigned their default values.
    $stmt .= sprintf ("%s %s=%s", $delim, $col_name,
                      $dbh->quote ($entry_ref->{$col_name}));
    $delim = ",";
  }
  $dbh->do ($stmt) or warn "Warning: new entry not created!\n"
}
#@ _NEW_MEMBER_

# edit existing contents of an entry

#@ _EDIT_MEMBER_
sub edit_member
{
# references to an array of column names and to the entry hash
my ($col_name_ref, $entry_ref) = @_;

  # show initial values, ask for okay to go ahead and edit
  show_member ($col_name_ref, $entry_ref);
  return unless prompt ("\nEdit this entry (y/n)? ") =~ /^y/i;
  # prompt for new values; user types in new value, or Enter
  # to leave value unchanged, "NONE" to clear the value, or
  # "EXIT" to exit without changing the record.
  foreach my $col_name (@{$col_name_ref})
  {
    next if $col_name eq "member_id";   # skip key field
    my $col_val = col_prompt ($col_name, $entry_ref);
    next if $col_val eq "";             # user pressed Enter
    return if uc ($col_val) eq "EXIT";  # early exit
    if (uc ($col_val) eq "NONE")
    {
      # enter NULL if column is nullable, empty string otherwise
      $col_val = ($nullable{$col_name} ? undef : "");
    }

    $entry_ref->{$col_name} = $col_val;
  }
  # show new values, ask for confirmation before updating
  show_member ($col_name_ref, $entry_ref);
  return unless prompt ("\nUpdate this entry (y/n)? ") =~ /^y/i;

  # construct an UPDATE query, then issue it.
  my $stmt = "UPDATE member";
  my $delim = " SET "; # put "SET" before first column, "," before others
  foreach my $col_name (@{$col_name_ref})
  {
    next if $col_name eq "member_id"; # skip key field
    # quote() quotes undef as the word NULL (without quotes),
    # which is what we want.
    $stmt .= sprintf ("%s %s=%s", $delim, $col_name,
                      $dbh->quote ($entry_ref->{$col_name}));
    $delim = ",";
  }
  $stmt .= " WHERE member_id = " . $dbh->quote ($entry_ref->{member_id});
  $dbh->do ($stmt) or warn "Warning: entry not undated!\n"
}
#@ _EDIT_MEMBER_
