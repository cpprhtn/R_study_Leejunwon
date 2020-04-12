@echo off
REM init_all_tables.bat - create and load the sampdb tables

REM Usage:
REM init_all_tables.bat [options] db_name

REM options may be connection parameters if you need to specify them:
REM init_all_tables.bat -p -u sampadm db_name

if not "%1" == "" goto LOAD
  @echo Usage: init_all_tables [options] db_name
  goto DONE

:LOAD
mysql -e "source init_all_tables.sql" %*
:DONE
