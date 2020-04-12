# Given a student ID and an information type, return that information
# for the student, NULL if the ID is not found. Raise a signal if
# the information type is bad.

DROP FUNCTION IF EXISTS student_info;
delimiter $
#@ _FRAG_
CREATE FUNCTION student_info (p_id INT UNSIGNED, p_info_type VARCHAR(100))
RETURNS VARCHAR(100)
READS SQL DATA
BEGIN
  DECLARE v_info VARCHAR(100) DEFAULT NULL;
  CASE p_info_type
    WHEN 'name' THEN
      SELECT name INTO v_info FROM sampdb.student
      WHERE student_id = p_id;
    WHEN 'sex' THEN
      SELECT sex INTO v_info FROM sampdb.student
      WHERE student_id = p_id;
    ELSE -- unknown information type
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Unknown information type';
  END CASE;
  RETURN v_info;
END;
#@ _FRAG_
$
delimiter ;
SELECT student_info(1, 'name');
SELECT student_info(1, 'sex');
SELECT student_info(999, 'name'); -- no such student
SELECT student_info(1, 'bad-info-type'); -- no such info type
