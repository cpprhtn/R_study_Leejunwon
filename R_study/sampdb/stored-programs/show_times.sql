# display current local and UTC times

DROP PROCEDURE IF EXISTS show_times;
delimiter $
CREATE PROCEDURE show_times()
BEGIN
  SELECT CURRENT_TIMESTAMP AS 'Local Time';
  SELECT UTC_TIMESTAMP AS 'UTC Time';
END$

delimiter ;
CALL show_times();
