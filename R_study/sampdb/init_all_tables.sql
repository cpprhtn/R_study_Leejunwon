# The grade-keeping tables have foreign key relationships, so:
# - Drop them in child-parent order
# - Create them in parent-child order

# USHL tables
source create_member.sql;
source create_president.sql;
source insert_member.sql;
source insert_president.sql;

# grade-keeping project tables - must drop in proper order
DROP TABLE IF EXISTS absence, score, grade_event, student;
source create_student.sql;
source create_grade_event.sql;
source create_score.sql;
source create_absence.sql;
source insert_student.sql;
source insert_grade_event.sql;
source insert_score.sql;
source insert_absence.sql;
