# Rotate general_log and slow_log tables in mysql database
DROP EVENT IF EXISTS mysql.rotate_log_tables;
delimiter $
#@ _FRAG_
CREATE EVENT mysql.rotate_log_tables
ON SCHEDULE EVERY 1 DAY
DO BEGIN
  DROP TABLE IF EXISTS general_log_tmp, general_log_old;
  CREATE TABLE general_log_tmp LIKE general_log;
  RENAME TABLE
    general_log TO general_log_old,
    general_log_tmp TO general_log;
  DROP TABLE IF EXISTS slow_log_tmp, slow_log_old;
  CREATE TABLE slow_log_tmp LIKE slow_log;
  RENAME TABLE
    slow_log TO slow_log_old,
    slow_log_tmp TO slow_log;
END;
#@ _FRAG_
$
delimiter ;
