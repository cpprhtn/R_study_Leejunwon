# create score table for grade-keeping project

# The PRIMARY KEY comprises two columns to prevent any combination
# of event_id/student_id from appearing more than once.

DROP TABLE IF EXISTS score;
#@ _CREATE_TABLE_
CREATE TABLE score
(
  student_id INT UNSIGNED NOT NULL,
  event_id   INT UNSIGNED NOT NULL,
  score      INT NOT NULL,
  PRIMARY KEY (event_id, student_id),
  INDEX (student_id),
  FOREIGN KEY (event_id) REFERENCES grade_event (event_id),
  FOREIGN KEY (student_id) REFERENCES student (student_id)
) ENGINE=InnoDB;
#@ _CREATE_TABLE_
