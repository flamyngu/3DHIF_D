drop database if exists schoolDB;
create database schoolDB;
USE schoolDB;
DROP TABLE IF EXISTS e_exams;
DROP TABLE IF EXISTS l_lessons;
DROP TABLE IF EXISTS c_classes;
DROP TABLE IF EXISTS r_rooms;
DROP TABLE IF EXISTS b_bosses;
DROP TABLE IF EXISTS t_teachers;
DROP TABLE IF EXISTS p_pupils;
DROP TABLE IF EXISTS s_subjects;

CREATE TABLE s_subjects (
    s_id INT NOT NULL AUTO_INCREMENT,
    s_text VARCHAR(45) DEFAULT NULL,
    PRIMARY KEY (s_id)
);

CREATE TABLE r_rooms (
    r_id VARCHAR(10) NOT NULL,
    r_seats INT DEFAULT NULL,
    PRIMARY KEY (r_id)
);

CREATE TABLE t_teachers (
    t_id CHAR(5) NOT NULL,
    t_name VARCHAR(45) DEFAULT NULL,
    t_firstname VARCHAR(45) DEFAULT NULL,
    t_birthdate DATE DEFAULT NULL,
    t_salary DECIMAL(10,2) DEFAULT NULL,
    t_t_boss CHAR(5) DEFAULT NULL,
    PRIMARY KEY (t_id)
);

CREATE TABLE b_bosses (
    b_t_subordinate CHAR(5) NOT NULL,
    b_type VARCHAR(45) DEFAULT NULL,
    b_t_boss CHAR(5) DEFAULT NULL,
    PRIMARY KEY (b_t_subordinate)
);

CREATE TABLE p_pupils (
    p_pupilnr INT NOT NULL,
    p_name VARCHAR(45) DEFAULT NULL,
    p_firstname VARCHAR(45) DEFAULT NULL,
    p_birthdate DATE DEFAULT NULL,
    p_address VARCHAR(45) DEFAULT NULL,
    p_c_class VARCHAR(6) DEFAULT NULL,
    PRIMARY KEY (p_pupilnr)
);

CREATE TABLE c_classes (
    c_id VARCHAR(6) NOT NULL,
    c_text VARCHAR(45) DEFAULT NULL,
    c_t_classteacher CHAR(5) DEFAULT NULL,
    c_p_classrepsubst INT DEFAULT NULL,
    c_p_classrep INT DEFAULT NULL,
    PRIMARY KEY (c_id)
);

CREATE TABLE l_lessons (
    l_c_class VARCHAR(6) NOT NULL,
    l_hour VARCHAR(4) NOT NULL,
    l_s_subject INT NOT NULL,
    l_t_teacher CHAR(5) DEFAULT NULL,
    l_r_room VARCHAR(6) DEFAULT NULL,
    PRIMARY KEY (l_c_class, l_hour, l_s_subject)
);

CREATE TABLE e_exams (
    e_date DATE NOT NULL,
    e_p_cand INT NOT NULL,
    e_s_subject INT NOT NULL,
    e_t_teacher CHAR(5) DEFAULT NULL,
    e_type ENUM('WP', 'FP') DEFAULT NULL,
    e_mark INT DEFAULT NULL,
    PRIMARY KEY (e_date, e_p_cand, e_s_subject)
);

ALTER TABLE t_teachers 
    ADD FOREIGN KEY (t_t_boss) REFERENCES t_teachers(t_id);

ALTER TABLE b_bosses 
    ADD FOREIGN KEY (b_t_subordinate) REFERENCES t_teachers(t_id),
    ADD FOREIGN KEY (b_t_boss) REFERENCES t_teachers(t_id);

ALTER TABLE p_pupils 
    ADD FOREIGN KEY (p_c_class) REFERENCES c_classes(c_id);

ALTER TABLE c_classes 
    ADD FOREIGN KEY (c_t_classteacher) REFERENCES t_teachers(t_id),
    ADD FOREIGN KEY (c_p_classrep) REFERENCES p_pupils(p_pupilnr),
    ADD FOREIGN KEY (c_p_classrepsubst) REFERENCES p_pupils(p_pupilnr);

ALTER TABLE l_lessons 
    ADD FOREIGN KEY (l_c_class) REFERENCES c_classes(c_id),
    ADD FOREIGN KEY (l_s_subject) REFERENCES s_subjects(s_id),
    ADD FOREIGN KEY (l_t_teacher) REFERENCES t_teachers(t_id),
    ADD FOREIGN KEY (l_r_room) REFERENCES r_rooms(r_id);

ALTER TABLE e_exams 
    ADD FOREIGN KEY (e_p_cand) REFERENCES p_pupils(p_pupilnr),
    ADD FOREIGN KEY (e_s_subject) REFERENCES s_subjects(s_id),
    ADD FOREIGN KEY (e_t_teacher) REFERENCES t_teachers(t_id);
