@ECHO OFF
REM interests.bat - find USHL members with particular interests
if not "%1" == "" goto SEARCH
  echo Please specify one keyword
  goto DONE
:SEARCH
mysql -e "SELECT last_name, first_name, email, interests FROM member WHERE interests LIKE '%%%1%%' ORDER BY last_name, first_name;" -t sampdb
:DONE
