# Return a value that is half of the input value

DROP FUNCTION IF EXISTS half;
delimiter $
#@ _FRAG_
CREATE FUNCTION half (p_value DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
  RETURN p_value / 2;
END;
#@ _FRAG_
$
delimiter ;
SELECT half(1), half(PI());
