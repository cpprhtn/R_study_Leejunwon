DROP TABLE IF EXISTS web_session;
CREATE TABLE web_session (last_visit DATETIME);
DROP EVENT IF EXISTS expire_web_session;
delimiter //
#@ _FRAG_
CREATE EVENT expire_web_session
  ON SCHEDULE EVERY 4 HOUR
  DO
    DELETE FROM web_session
    WHERE last_visit < CURRENT_TIMESTAMP - INTERVAL 1 DAY;
#@ _FRAG_
//
delimiter ;
SHOW CREATE EVENT expire_web_session\G
