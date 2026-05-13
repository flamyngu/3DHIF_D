drop database if exists companydb;
create database if not exists companydb;
use companydb;

create table d_dept (
  d_deptno decimal(10,0) not null primary key,
  d_dname char(20) default null,
  d_loc char(20) default null
)engine=innodb;


insert into d_dept values (10,'accounting','new york');
insert into d_dept values (20,'research','dallas');
insert into d_dept values (30,'sales','chicago');
insert into d_dept values (40,'operations','boston');


create table e_emp (
  e_empno decimal(10,0) not null primary key,
  e_ename char(20) default null,
  e_job char(20) default null,
  e_e_mgr decimal(10,0) default null,
  e_hiredate date default null,
  e_sal decimal(10,0) default null,
  e_comm decimal(5,0) default null,
  e_d_deptno decimal(10,0) not null,
  e_p_projno decimal(10,0)
)engine=innodb;

insert into e_emp values (7369,'smith','clerk',7902,'1980-12-17',800,null,20,101);
insert into e_emp values (7499,'allen','salesman',7698,'1981-2-20',1600,300,30,103);
insert into e_emp values (7521,'ward','salesman',7698,'1981-2-22',1250,500,30,103);
insert into e_emp values (7566,'jones','manager',7839,'1981-4-2',2975,null,20,101);
insert into e_emp values (7654,'martin','salesman',7698,'1981-9-28',1250,1400,30,103);
insert into e_emp values (7698,'blake','manager',7839,'1981-5-1',2850,null,30,101);
insert into e_emp values (7782,'clark','manager',7839,'1981-6-9',2450,null,10,101);
insert into e_emp values (7788,'scott','analyst',7566,'1982-12-19',3000,null,20,101);
insert into e_emp values (7839,'king','president',null,'1981-11-17',5000,null,10,102);
insert into e_emp values (7844,'turner','salesman',7698,'1981-9-8',1500,null,30,101);
insert into e_emp values (7876,'adams','clerk',7788,'1983-1-12',1100,null,20,101);
insert into e_emp values (7900,'james','clerk',7698,'1981-12-3',950,null,30,102);
insert into e_emp values (7902,'ford','analyst',7566,'1981-12-3',3000,null,20,101);
insert into e_emp values (7934,'miller','clerk',7782,'1982-1-23',1300,null,10,102);

create table p_projects(
  p_projno decimal(10,0) primary key,
  p_pname varchar(50) not null,
  p_budget decimal(10) not null
) engine=innodb;

insert into p_projects values(101, 'ALPHA', 250);
insert into p_projects values(102, 'BETA', 175);
insert into p_projects values(103, 'GAMMA', 95);

create table s_salgrade (
  s_grade decimal(2,0) not null primary key,
  s_losal decimal(10,0) default null,
  s_hisal decimal(10,0) default null
)engine=innodb;


insert into s_salgrade values (1,700,1200);
insert into s_salgrade values (2,1201,1400);
insert into s_salgrade values (3,1401,2000);
insert into s_salgrade values (4,2001,3000);
insert into s_salgrade values (5,3001,9000);

alter table e_emp add foreign key (e_e_mgr) references e_emp(e_empno)
on delete restrict
on update restrict;

alter table e_emp add foreign key (e_d_deptno) references d_dept(d_deptno)
on delete restrict
on update restrict;

alter table e_emp add foreign key (e_p_projno) references p_projects(p_projno)
on delete restrict
on update restrict;
