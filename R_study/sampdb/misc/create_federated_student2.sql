# Create federated student table for grade-keeping project,
# using a server definition and naming the server in the CONNECTION option.

DROP SERVER IF EXISTS fed_sampdb_server;
#@ _CREATE_SERVER_
CREATE SERVER fed_sampdb_server
FOREIGN DATA WRAPPER mysql
OPTIONS (
  USER 'sampadm',
  PASSWORD 'secret',
  HOST 'fed.example.com',
  DATABASE 'sampdb'
);
#@ _CREATE_SERVER_

DROP TABLE IF EXISTS federated_student2;
#@ _CREATE_TABLE_
CREATE TABLE federated_student2
(
  name       VARCHAR(20) NOT NULL,
  sex        ENUM('F','M') NOT NULL,
  student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (student_id)
) ENGINE = FEDERATED
CONNECTION = 'fed_sampdb_server/student';
#@ _CREATE_TABLE_
