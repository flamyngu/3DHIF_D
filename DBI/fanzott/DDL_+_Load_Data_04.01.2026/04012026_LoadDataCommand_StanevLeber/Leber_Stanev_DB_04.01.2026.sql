USE mydb;

SET FOREIGN_KEY_CHECKS = 0;
SET GLOBAL local_infile = 1;

-- ============================================
-- TEACHERS
-- CSV: t_id|t_name|t_firstname|t_birthdate|t_salary|t_t_boss|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/teachers.csv'
INTO TABLE t_teachers
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(t_id, t_name, t_firstname, t_birthdate, t_salary, t_t_boss, @dummy);

-- ============================================
-- ROOMS
-- CSV: r_id|r_seats|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/rooms.csv'
INTO TABLE r_rooms
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(r_id, r_seats, @dummy);

-- ============================================
-- SUBJECTS
-- CSV: s_id|s_text|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/subject.csv'
INTO TABLE s_subjects
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(s_id, s_text, @dummy);

-- ============================================
-- PUPILS
-- CSV: p_pupilnr|p_name|p_firstname|p_birthdate|p_address|p_c_class|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/pupils.csv'
INTO TABLE p_pupils
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(p_pupilnr, p_name, p_firstname, p_birthdate, p_address, p_c_class, @dummy);

-- ============================================
-- CLASSES
-- CSV: c_id|c_text|c_t_classteacher|c_p_classrepsubst|c_p_classrep|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/classes.csv'
INTO TABLE c_classes
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(c_id, c_text, c_t_classteacher, c_p_classrepsubst, c_p_classrep, @dummy);

-- ============================================
-- LESSONS
-- CSV: l_c_class|l_hour|l_s_subject|l_t_teacher|l_r_room|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/lessons.csv'
INTO TABLE l_lessons
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(l_c_class, l_hour, l_s_subject, l_t_teacher, l_r_room, @dummy);

-- ============================================
-- EXAMS
-- CSV: e_date|e_p_cand|e_s_subject|e_t_teacher|e_type|e_mark|
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/exams.csv'
INTO TABLE e_exams
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(e_date, e_p_cand, e_s_subject, e_t_teacher, e_type, e_mark, @dummy);

-- ============================================
-- BOSSES
-- CSV: b_t_boss|btype|b_t_subordinate|
-- TABLE: b_t_subordinate|b_type|b_t_boss
-- ============================================
LOAD DATA LOCAL INFILE 'C:/Users/simon/Downloads/data_to_insert/data_to_insert/bosses.csv'
INTO TABLE b_bosses
FIELDS TERMINATED BY '|'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@b_t_boss, @b_type, @b_t_subordinate, @dummy)
SET
  b_t_subordinate = @b_t_subordinate,
  b_type          = @b_type,
  b_t_boss        = @b_t_boss;

SET FOREIGN_KEY_CHECKS = 1;
