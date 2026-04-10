#------------------------------------------------------

drop database if exists 20241100_schooldbload;

create database 20241100_schooldbload;

use 20241100_schooldbload;

#---------------------------------------------------
SET GLOBAL local_infile = 1;

# Tabelle Gegenstande
create table s_subjects(
  s_id varchar(5) not null,
  s_text varchar(20) default null,
  s_date date null,
  primary key (s_id)
) engine=InnoDB;

load data local infile 'C:/Users/actio/Desktop/loaddata/Subjects.csv' 
into table s_subjects fields terminated by '|' enclosed by '"' lines terminated by '\r\n' ignore 1 lines
  (s_id,s_text, @s_date)
SET s_date = STR_TO_DATE(@s_date, '%d-%m-%Y');
