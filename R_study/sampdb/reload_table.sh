#!/bin/sh

# recreate and reload table or tables in the sampdb database

if [ $# -lt 1 ]; then echo "Usage: $0 tbl_name" 1>&2; exit 1; fi

# change db_name as necessary
db_name=sampdb

for tbl_name in $*; do

mysql $db_name < create_$tbl_name.sql
mysql $db_name <<EOF
LOAD DATA LOCAL INFILE "$tbl_name.txt" INTO TABLE $tbl_name;
EOF

done
