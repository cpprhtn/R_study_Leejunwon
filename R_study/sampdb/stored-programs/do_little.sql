# Stored procedure that doesn't do a lot.
DROP PROCEDURE IF EXISTS do_little;
DROP PROCEDURE IF EXISTS do_nothing;
delimiter $
#@ _FRAG_
CREATE PROCEDURE do_little ()
BEGIN
  DO SLEEP(1);
END;

CREATE PROCEDURE do_nothing ()
BEGIN
END;
#@ _FRAG_
$
delimiter ;
CALL do_little();
CALL do_nothing();
