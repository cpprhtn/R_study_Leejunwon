# Count the number of presidents born in a given year

DROP FUNCTION IF EXISTS count_born_in_year;
delimiter $
CREATE FUNCTION count_born_in_year(p_year INT)
RETURNS INT
READS SQL DATA
BEGIN
  RETURN (SELECT COUNT(*) FROM president WHERE YEAR(birth) = p_year);
END$
delimiter ;

SELECT count_born_in_year(1908);
SELECT count_born_in_year(1913);
