#!/bin/sh
# rotate_fixed_logs.sh - rotate MySQL log file that has a fixed name

# Argument 1: log filename

if [ $# -ne 1 ]; then
  echo "Usage: $0 logname" 1>&2
  exit 1
fi

logname=$1

mv $logname.6 $logname.7
mv $logname.5 $logname.6
mv $logname.4 $logname.5
mv $logname.3 $logname.4
mv $logname.2 $logname.3
mv $logname.1 $logname.2
mv $logname $logname.1
mysqladmin flush-logs
