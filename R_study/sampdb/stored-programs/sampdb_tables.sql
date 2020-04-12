# Display names of tables in sampdb database
USE sampdb;
DROP PROCEDURE IF EXISTS sampdb_tables;
#@ _FRAG_
CREATE PROCEDURE sampdb_tables ()
  SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
  WHERE TABLE_SCHEMA = 'sampdb' ORDER BY TABLE_NAME;
#@ _FRAG_
CALL sampdb_tables();
