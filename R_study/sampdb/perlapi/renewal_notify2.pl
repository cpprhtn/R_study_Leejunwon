#!/usr/bin/perl
# renewal_notify2.pl - Notify Historical League members of need to renew
# membership.  (Requires the Mail::Sendmail module.)

# Arguments may be given as membership ID numbers, email addresses,
# or filenames.  ID numbers are identified as all numeric, email addresses
# as containing an "@" character, filenames as anything else.  Filenames
# are opened and values in the first column is interpreted as membership
# ID numbers or email addresses (but not, to avoid recursion, as filenames).

# This way you can specify members to notify directly on the command line,
# or you can list members in a file and have the program read the file for
# members to notify.  In particular, the output from need_renewal contains
# membership ID values in the first column.

use strict;
use warnings;
use DBI;
use Mail::Sendmail;

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

#@ _MAIN_LOOP_
if (@ARGV == 0)   # no arguments, read STDIN for values
{
  read_file (\*STDIN);
}
else
{
  while (my $arg = shift (@ARGV))
  {
    # interpret argument, with filename recursion
    interpret_argument ($arg, 1);
  }
}
#@ _MAIN_LOOP_

$dbh->disconnect ();

#@ _READ_FILE_
sub read_file
{
my $fh = shift;   # handle to open file
my $arg;

  while (defined ($arg = <$fh>))
  {
    # strip off everything past column 1, including newline
    $arg =~ s/\s.*//s;
    # interpret argument, without filename recursion
    interpret_argument ($arg, 0);
  }
}
#@ _READ_FILE_

#@ _INTERPRET_ARGUMENT_
sub interpret_argument
{
my ($arg, $recurse) = @_;

  if ($arg =~ /^\d+$/)    # numeric membership ID
  {
    notify_member ($arg);
  }
  elsif ($arg =~ /@/)     # email address
  {
    # get member_id associated with address
    # (there should be exactly one)
    my $stmt = qq{ SELECT member_id FROM member WHERE email = ? };
    my $ary_ref = $dbh->selectcol_arrayref ($stmt, undef, $arg);
    if (scalar (@{$ary_ref}) == 0)
    {
      warn "Email address $arg matches no entry: ignored\n";
    }
    elsif (scalar (@{$ary_ref}) > 1)
    {
      warn "Email address $arg matches multiple entries: ignored\n";
    }
    else
    {
      notify_member ($ary_ref->[0]);
    }
  }
  else                    # filename
  {
    if (!$recurse)
    {
      warn "filename $arg inside file: ignored\n";
    }
    else
    {
      open (IN, $arg) or die "Cannot open $arg: $!\n";
      read_file (\*IN);
      close (IN);
    }
  }
}
#@ _INTERPRET_ARGUMENT_

# notify member that membership will soon be in arrears

#@ _NOTIFY_MEMBER_
sub notify_member
{
my $member_id = shift;

  warn "Notifying $member_id...\n";
  my $stmt = qq{ SELECT * FROM member WHERE member_id = ? };
  my $sth = $dbh->prepare ($stmt);
  $sth->execute ($member_id);
  my @col_name = @{$sth->{NAME}};
  my $entry_ref = $sth->fetchrow_hashref ();
  $sth->finish ();
  if (!$entry_ref)                      # no member found!
  {
    warn "NO ENTRY found for member $member_id!\n";
    return;
  }
  if (!defined ($entry_ref->{email}))   # no email address in entry
  {
    warn "Member $member_id has no email address; no message was sent\n";
    return;
  }

$entry_ref->{email} = "paul\@localhost";
  # construct the message body
  my $message =<< "EOF";
Greetings.  Your membership in the U.S. Historical League is
due to expire soon.  We hope that you'll take a few minutes to
contact the League office to renew your membership.  The
contents of your member entry are shown following.  Please note
particularly the expiration date.

Thank you.

EOF
  foreach my $col_name (@col_name)
  {
    $message .= "$col_name:";
    $message .= " $entry_ref->{$col_name}"
            if defined ($entry_ref->{$col_name});
    $message .= "\n";
  }

  # construct hash containing message information
  my $from = (getlogin () || getpwuid ($<)) . "\@localhost";
  my %mailhash = (
    From  => $from,
    To    => $entry_ref->{email},
    Subject => "Your USHL membership is in need of renewal",
    Message => $message
  );
  sendmail (%mailhash)
    or die "Cannot send mail to $entry_ref->{email}: $!\n";
}
#@ _NOTIFY_MEMBER_
