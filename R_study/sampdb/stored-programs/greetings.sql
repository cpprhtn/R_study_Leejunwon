# Display "Greetings, <name>!", using a name of "earthling" if the
# current user is anonymous.

DROP PROCEDURE IF EXISTS greetings;
delimiter $
#@ _FRAG_
CREATE PROCEDURE greetings ()
BEGIN
  # 77 = 16 for username + 60 for hostname + 1 for '@'
  DECLARE user CHAR(77) CHARACTER SET utf8;
  SET user = (SELECT CURRENT_USER());
  IF INSTR(user,'@') > 0 THEN
    SET user = SUBSTRING_INDEX(user,'@',1);
  END IF;
  IF user = '' THEN         # anonymous user
    SET user = 'earthling';
  END IF;
  SELECT CONCAT('Greetings, ',user, '!') AS greeting;
END;
#@ _FRAG_
$
delimiter ;
CALL greetings();
