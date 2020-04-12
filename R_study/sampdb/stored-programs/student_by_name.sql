# Given a student name, return the corresponding student ID,
# or NULL if the name is not found

DROP FUNCTION IF EXISTS student_by_name;
delimiter $
#@ _FRAG_
CREATE FUNCTION student_by_name (p_name VARCHAR(20))
RETURNS INT UNSIGNED
READS SQL DATA
BEGIN
  DECLARE v_id INT DEFAULT NULL;
  SELECT student_id FROM student WHERE name = p_name INTO v_id;
  RETURN v_id;
END;
#@ _FRAG_
$
delimiter ;
SELECT student_by_name('Kyle');
SELECT student_by_name('no-such-student');
