This directory contains the Perl scripts developed in Chapter 8.
The web directory contains the Web scripts and the sampdb.cnf file.
The sampdb.cnf file should be installed in the Apache configuration
directory (e.g., /usr/local/apache/conf).  The Web scripts should be
installed in Apache's CGI script directory (e.g., /usr/local/apache/cgi-bin)

count_members.pl
    Script to print the number of the Historical League members
dump_members.pl
    Script to produce tab-delimited list of Historical League members
dump_members2.pl
    Like dump_members.pl, but with explicit error processing
edit_member.pl
    Script for editing Historical League member entries
gen_dir.pl
    Script to generate Historical League directory
interests.pl
    Script to find Historical League members with a given interest
need_renewal.pl
    Script to find Historical League members who need to renew membership
renewal_notify.pl
    Script to notify Historical League members who need to renew membership
    (requires sendmail)
renewal_notify2.pl
    Same as renewal_notify.pl, but uses the Mail::Sendmail module to send
    mail rather than the sendmail program.  To install Mail::Sendmail,
    use CPAN under UNIX:
        # perl -MCPAN -e shell
        cpan> install Mail::Sendmail
    or use PPM under Windows:
        C:\> ppm
        ppm> install Mail::Sendmail
show_member.pl
    Show Historical League member entries
show_scores.pl
    Script to display scores from gradebook for a given date
skel.pl
    Skeleton that can be used as a framework for developing new DBI
    scripts.  It handles command-line option parsing and option file
    reading.  (Many of the other scripts in this directory are based
    on it.)
tabular.pl
    Script to run query and produce tabular-format output
transaction.pl
    Demonstrates how DBI transaction abstraction mechanism works.
version.pl
    Script to display the DBI and DBD::mysql version numbers.
win_opt_file.pl
    Demonstrates how to use an option file under Windows when the
    filename contains a colon. (Colon is the DBI DSN separator, so
    colons in filenames are ambiguous.)
