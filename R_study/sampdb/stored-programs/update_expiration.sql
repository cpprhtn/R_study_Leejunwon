# Given USHL member ID and date, set the appropriate membership
# row's expiration to that date

DROP PROCEDURE IF EXISTS update_expiration;
delimiter $
#@ _FRAG_
CREATE PROCEDURE update_expiration (p_id INT UNSIGNED, p_date DATE)
BEGIN
  UPDATE member SET expiration = p_date WHERE member_id = p_id;
END;
#@ _FRAG_
$
delimiter ;
CALL update_expiration(61, CURDATE() + INTERVAL 1 YEAR);
CALL update_expiration(87, NULL); # lifetime membership

SELECT * FROM member WHERE member_id IN(61,87);
