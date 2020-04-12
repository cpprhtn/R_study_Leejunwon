# Create member_pass table for U.S. Historical League
# It generates a member_pass table containing a password for each
# member by calculating an MD5() checksum based on the member's name
# taking the first 8 characters.
# It also inserts a row for the fake member ID value of 0 that is used
# for the administrative password (use this password to get permission
# to edit any entry)

DROP TABLE IF EXISTS member_pass;
#@ _CREATE_TABLE_
CREATE TABLE member_pass
(
  member_id INT UNSIGNED NOT NULL PRIMARY KEY,
  password  CHAR(8)
);
#@ _CREATE_TABLE_
#@ _INSERT_PASSWORDS_
INSERT INTO member_pass (member_id, password)
  SELECT member_id, LEFT(MD5(RAND()), 8) AS password FROM member;
#@ _INSERT_PASSWORDS_
#@ _INSERT_ADMIN_PASS_
INSERT INTO member_pass (member_id, password) VALUES(0, 'bigshot');
#@ _INSERT_ADMIN_PASS_
