# Create federated student table for grade-keeping project,
# naming the connection parameters in the CONNECTION option.

DROP TABLE IF EXISTS federated_student;
#@ _CREATE_TABLE_
CREATE TABLE federated_student
(
  name       VARCHAR(20) NOT NULL,
  sex        ENUM('F','M') NOT NULL,
  student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (student_id)
) ENGINE = FEDERATED
CONNECTION = 'mysql://sampadm:secret@fed.example.com/sampdb/student';
#@ _CREATE_TABLE_
