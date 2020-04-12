# Script that gives access privileges to a user for the sampdb
# database.
# Change user and password to add privileges for different user.
CREATE USER 'sampadm'@'localhost' IDENTIFIED BY 'secret';
GRANT ALL ON sampdb.* TO 'sampadm'@'localhost';
