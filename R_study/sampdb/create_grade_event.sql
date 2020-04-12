# create grade event table for grade-keeping project

DROP TABLE IF EXISTS grade_event;
#@ _CREATE_TABLE_
CREATE TABLE grade_event
(
  date     DATE NOT NULL,
  category ENUM('T','Q') NOT NULL,
  event_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (event_id)
) ENGINE=InnoDB;
#@ _CREATE_TABLE_
