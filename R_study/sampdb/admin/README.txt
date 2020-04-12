Some administrative scripts.

On Unix, either make sure they are executable (chmod +x script_name), or
invoke them like this:

sh script_name      (For shell scripts)
perl script_name    (For Perl scripts)

On Windows, you can invoke Perl scripts like this:

perl script_name

chk_mysql_opt_files.pl
  Script to verify that all per-user .my.cnf files are accessible only
  to their owners. You must run this as root.

rotate_fixed_logs.bat
  Log rotation script for Windows. Due to Windows file-locking semantics,
  you must stop the server while you use this script. (Otherwise, because
  the server has the current log open, you cannot rename it.)

rotate_fixed_logs.sh
  Log rotation script for Unix.


If you set up a cron job to run a script that invokes MySQL programs,
make sure that your PATH is set to include the directory where those
programs are located (or else modify the script to invoke the programs
by their full pathname).
