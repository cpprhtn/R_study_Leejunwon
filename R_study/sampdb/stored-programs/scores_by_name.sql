# Display scores for a student given a student name

DROP PROCEDURE IF EXISTS scores_by_name;
delimiter $
#@ _FRAG_
CREATE PROCEDURE scores_by_name (p_name VARCHAR(20))
BEGIN
  DECLARE v_id INT DEFAULT NULL;
  # look up student ID from name
  SELECT student_id FROM student WHERE name = p_name INTO v_id;
  # use ID to look up and display scores
  SELECT p_name, score.* FROM score WHERE student_id = v_id;
END;
#@ _FRAG_
$
delimiter ;
CALL scores_by_name('Kyle');
CALL scores_by_name('no-such-name'); # should produce no output
