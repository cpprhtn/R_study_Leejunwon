#!/bin/sh

# init_all_tables.sh - create and load the sampdb tables

# Usage:
# sh init_all_tables.sh [options] db_name

# options may be connection parameters if you need to specify them:
# sh init_all_tables.sh -p -u sampadm

if [ $# -eq 0 ]; then
  echo "Usage: init_all_tables.sh [options] db_name" 1>&2
  exit 1
fi

mysql -e "source init_all_tables.sql" $*
