# create absence table for grade-keeping project

DROP TABLE IF EXISTS absence;
#@ _CREATE_TABLE_
CREATE TABLE absence
(
  student_id INT UNSIGNED NOT NULL,
  date       DATE NOT NULL,
  PRIMARY KEY (student_id, date),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
) ENGINE=InnoDB;
#@ _CREATE_TABLE_
