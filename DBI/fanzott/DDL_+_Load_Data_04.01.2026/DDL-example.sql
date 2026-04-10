# DDL to create a database
#------------------------------------------------------
# drop database if exists
drop database if exists schooldb;
# create database
create database schooldb;
# use database
use schooldb;
# create table
#------------------------------------------------------
# Table Pupil
create table p_pupils (
 p_pupilnr decimal(9,0) not null,
 p_name varchar(15) default null,
 p_firstname varchar(10) default null,
 p_birthdate date default null,
 p_address varchar(15) default null,
 p_c_class varchar(5) default null,
 primary key (p_pupilnr)
) engine=InnoDB;
#------------------------------------------------------
# Table Class
create table c_classes (
 c_classid varchar(5) not null,
 c_text varchar(100) default null,
 primary key (c_classid)
) engine=InnoDB;
# alter table
#------------------------------------------------------
# Alter table Pupil to define the foreign key
alter table p_pupils
add foreign key (p_c_class)
references c_classes(c_classid);