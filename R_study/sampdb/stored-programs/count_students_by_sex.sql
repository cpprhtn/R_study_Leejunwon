# Compute student counts by sex.
# Uses OUT variables to pass values back from procedure to caller.

DROP PROCEDURE IF EXISTS count_students_by_sex;
delimiter $
#@ _FRAG_
CREATE PROCEDURE count_students_by_sex (OUT p_male INT, OUT p_female INT)
BEGIN
  SET p_male = (SELECT COUNT(*) FROM student WHERE sex = 'M');
  SET p_female = (SELECT COUNT(*) FROM student WHERE sex = 'F');
END;
#@ _FRAG_
$
delimiter ;
CALL count_students_by_sex(@male_count, @female_count);
SELECT @male_count, @female_count;
