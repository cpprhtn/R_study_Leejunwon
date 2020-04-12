sampdb distribution
Paul DuBois, paul@kitebird.com

This distribution contains files for use with the sampdb database
that is used for examples in the book "MySQL" (Fifth Edition)
published by Addison-Wesley Professional.  The distribution contains
several subdirectories, described following.

The latest version of this distribution and the errata list for the
book are available at:

    http://www.kitebird.com/mysql-book

If you find that files appear to be missing from this distribution or that
they differ from the printed text of the book, please let me know.

If you are using a database name other than "sampdb", substitute that
name wherever you see sampdb here or in the files.

Files often contain lines with "#@ _IDENTIFIER_" sequences.  You
can ignore these. They are just placemarkers that I use to block out
sections that are extracted for examples in the book.

----------------------------------------------------------------------

The following files are used in Chapter 1.  See that chapter for further
instructions.

createdb.sql
    Script to create the sampdb database:
        % mysql < createdb.sql
    This script requires that you have the CREATE privilege for the
    sampdb database, which means you'll likely need to run it as the
    MySQL root user.

adduser.sql
    Script that gives access privileges to a user for the sampdb
    database.  It's basically just a demonstration of the GRANT
    statement.  If you want to use it, you'll need to edit the
    name and password, and perhaps the database name:
        % mysql < adduser.sql
    This script requires that you have the GRANT privilege, which means
    you'll likely need to run it as the MySQL root user.

create_absence.sql
create_grade_event.sql
create_member.sql
create_president.sql
create_score.sql
create_student.sql
    Scripts to create the tables in the sampdb database:
        % mysql sampdb < create_absence.sql
        % mysql sampdb < create_grade_event.sql
        etc.

insert_absence.sql
insert_event.sql
insert_member.sql
insert_president.sql
insert_score.sql
insert_student.sql
    Scripts to insert the initial contents of the sampdb database tables:
        % mysql sampdb < insert_absence.sql
        % mysql sampdb < insert_event.sql
        etc.
    Another way to load the tables is to use the *.txt files with LOAD
    DATA or with the load_*.sql scripts.

absence.txt
event.txt
member.txt
president.txt
score.txt
student.txt
    Files containing raw data to be loaded into the sampdb tables.
    They can be used with LOAD DATA or with the load_*.sql scripts.

load_absence.sql
load_event.sql
load_member.sql
load_president.sql
load_score.sql
load_student.sql
    Scripts that load the contents of the *.txt files using LOAD DATA:
        % mysql sampdb < load_absence.sql
        % mysql sampdb < load_event.sql
        etc.

init_all_tables.sh
init_all_tables.bat
    UNIX and Windows scripts that create and load the sampdb tables.
    You can use these to make sure the tables are in a known state:
        % sh init_all_tables.sh sampdb
    or
        C:\> init_all_tables.bat sampdb

reload_table.sh
    Script to recreate and reload individual tables in the sampdb database.
    It runs mysql with the appropriate create_*.sql script and LOAD DATA
    statement to create the named tables and populate them:
        % reload_table.sh tbl_name ...
    The sampdb database name is hardwired in; change it as necessary.

----------------------------------------------------------------------

The following file can be used to create the member_pass table described
in Chapter 9.

derive_member_pass.sql
    Create the member_pass table that contains USHL member entry
    passwords:
        % mysql sampdb < derive_member_pass.sql
    The table is derived based on the contents of the member table.

----------------------------------------------------------------------

The subdirectories of the main distribution directory are as follows:

admin
    Administrative scripts, relating primarily to Chapters 12-14.
capi
    Example programs that use the MySQL C API
full-text
    Example table and data for FULLTEXT searching. See Chapter 2.
misc
    Some miscellaneous scripts.  Peruse and use if you find them useful.
perlapi
    Example programs that use the MySQL Perl DBI API
phpapi
    Example programs that use the MySQL PHP API.  The appfragment
    subdirectory contains the source for the examples that are
    shown in Appendix I.
ssl
    Sample SSL certificate and key files.  Used in Chapter 13.
stored-programs
    Sample stored programs. Many of these are used in Chapter 4, some
    are used elsewhere.

----------------------------------------------------------------------
