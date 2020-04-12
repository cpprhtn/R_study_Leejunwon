# These are the queries used in the pres_quiz.php script to pull
# random rows from the president table.

# These queries work for any version of MySQL

#@ _PICK_PRESIDENT_PRE_3_23_2_
SELECT CONCAT(first_name, ' ', last_name) AS name,
CONCAT(city, ', ', state) AS place,
city*0+RAND() AS rand_val
FROM president ORDER BY rand_val LIMIT 1;
#@ _PICK_PRESIDENT_PRE_3_23_2_

#@ _PICK_BIRTHPLACES_PRE_3_23_2_
SELECT DISTINCT CONCAT(city, ', ', state) AS place,
city*0+RAND() AS rand_val
FROM president ORDER BY rand_val;
#@ _PICK_BIRTHPLACES_PRE_3_23_2_

# These queries work only as of MySQL 3.23.2

#@ _PICK_PRESIDENT_3_23_2_
SELECT CONCAT(first_name, ' ', last_name) AS name,
CONCAT(city, ', ', state) AS place
FROM president ORDER BY RAND() LIMIT 1;
#@ _PICK_PRESIDENT_3_23_2_

#@ _PICK_BIRTHPLACES_3_23_2_
SELECT DISTINCT CONCAT(city, ', ', state) AS place
FROM president ORDER BY RAND();
#@ _PICK_BIRTHPLACES_3_23_2_
