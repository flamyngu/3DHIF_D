drop user if exists 'admin_company'@'localhost';
drop user if exists 'dept_manager'@'%';
drop user if exists 'hr_user'@'loaclhost';
drop user if exists 'report_user'@'localhost';
drop user if exists 'project_user'@'%';

#creating user admin_company
create user 'admin_company'@'localhost' identified by 'Admin123!';
flush privileges;

grant all privileges on companydb.* to 'admin_company'@'localhost'; #privileges for admin_company

#creating user dept_manager
create user 'dept_manager'@'%' identified by 'Manager123!';
flush privileges;

grant select, insert, update on companydb.d_dept to 'dept_manager'@'%'; #privileges for dept_manager

#create user hr_user
create user 'hr_user'@'loaclhost' identified by 'HR123!';
grant select, insert, update (e_sal, e_comm) on companydb.e_emp to 'hr_user'@'loaclhost'; #privileges for hr_user

#creating user project_user
create user 'project_user'@'%' identified by 'Project123!';
flush privileges;

grant select, insert on companydb.p_projects to 'project_user'@'%'; #privileges for dept_manager; #privileges for project_user

#create user report_user
create user 'report_user'@'loaclhost' identified by 'Report123!';
grant select on companydb.* to 'report_user'@'loaclhost'; #privileges for report_user
#FINISHED USER 5

#show permissions of all users
select * from mysql.db;

#more detailed per user
show grants for 'admin_company'@'localhost';
show grants for 'dept_manager'@'%';
show grants for 'hr_user'@'localhost';
show grants for 'project_user'@'%';
show grants for 'report_user'@'localhost';

#revoke insert permission from project_user on p_projects
revoke insert on companydb.p_projects from 'project_user'@'%';
flush privileges;

#grant update on column e_job to hr_user
grant update (e_job) on companydb.e_emp to 'hr_user'@'loaclhost';
flush privileges;
