# Given a grade event ID, display scores for event and
# return min/max scores for event in the OUT parameters.
# Simplifying assumption: Only INT columns are accessed.

DROP PROCEDURE IF EXISTS grade_event_stats;
delimiter $
#@ _PROC_DEFINITION_
CREATE PROCEDURE grade_event_stats
  (IN p_event_id INT, OUT p_min INT, OUT p_max INT)
BEGIN
  -- display scores for event
  SELECT student_id, score
    FROM score
    WHERE event_id = p_event_id
    ORDER BY student_id;
  -- store min/max event scores in OUT parameters
  SELECT MIN(score), MAX(score)
    FROM score
    WHERE event_id = p_event_id
    INTO p_min, p_max;
END;
#@ _PROC_DEFINITION_
$
delimiter ;

#@ _PROC_USE_
SET @p_min = NULL, @p_max = NULL; -- cause param vars to exist
CALL grade_event_stats(4, @p_min, @p_max);
SELECT @p_min, @p_max;
#@ _PROC_USE_
CALL grade_event_stats(0, @p_min, @p_max); -- should produce no output
SELECT @p_min, @p_max;
