# create student table for grade-keeping project

DROP TABLE IF EXISTS student;
#@ _CREATE_TABLE_
CREATE TABLE student
(
  name       VARCHAR(20) NOT NULL,
  sex        ENUM('F','M') NOT NULL,
  student_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (student_id)
) ENGINE=InnoDB;
#@ _CREATE_TABLE_
