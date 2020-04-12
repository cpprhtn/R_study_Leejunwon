# Display rows for presidents born in a given year

DROP PROCEDURE IF EXISTS show_born_in_year;
delimiter $
CREATE PROCEDURE show_born_in_year(p_year INT)
BEGIN
  SELECT first_name, last_name, birth, death
  FROM president
  WHERE YEAR(birth) = p_year;
END$
delimiter ;

CALL show_born_in_year(1908);
CALL show_born_in_year(1913);
