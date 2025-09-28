
-- ----------------------------

use companydb;
#1. Auflisten aller Jobs einer Firma, wobei gleiche Spaltenwerte verhindert
#werden.
select distinct e_job from e_emp;

#2. Angabe eines Alias-Namen für die Spaltenüberschriften DNAME - DEPARTMENT,
#DEPTNO - DEPTNUMMER der Tabelle DEPT.
use companydb;
select d_dname as DEPARTMENT,
d_deptno as DEPTNUMMER from d_dept;

#3. Auflisten aller Mitarbeiter die mehr Provision als Gehalt verdienen.
use companydb;
select *
from e_emp
where e_comm > e_sal;

#4. Auflisten aller Manager und Verkäufer die mehr als 1.500.- verdienen.
use companydb;
select * from e_emp
where (e_job = "manager" or e_job = "salesman") and e_sal > 1500;

#5. Auflisten aller Mitarbeiter die zwischen 1.200.- und 1.300.- verdienen. (Between, >=
#<=)
use companydb;
select * from e_emp 
where e_sal >= 1200 and e_sal <= 1300;

#6. Auflisten aller Mitarbeiter die weniger als 1.200.- und mehr als 1.300.- verdienen.
use companydb;
select * from e_emp 
where e_sal < 1200 or e_sal > 1300;

#7. Auflisten aller Mitarbeiter, die weder Büroangestellte noch Analytiker noch Verkäufer
#sind.
use companydb;
select * from e_emp
where not (e_job = "clerk" or e_job = "analyst" or e_job = "salesman");

#8. Ausgabe aller Mitarbeiter (alle Daten aus Mitarbeiter + Department-name) aus
#Abteilung 30 absteigend geordnet nach ihrem Gehalt.
use companydb;
select e.*, d.d_dname
from e_emp e
join d_dept d on e.e_d_deptno = d.d_deptno
where e.e_d_deptno = 30
order by e.e_sal desc;

#9. Ausgabe der Gehaltsstufe jedes Mitarbeiters (e_ename, s_sgrade, e_sal)
select e.e_ename, s.s_grade, e.e_sal
from e_emp e
join s_salgrade s 
on e.e_sal between s.s_losal and s.s_hisal;

#10. Ausgabe aller Abteilungen und deren Mitarbeiter (auch Abteilungen ohne Mitarbeiter)
select d.d_dname, e.e_ename
from d_dept d
left join e_emp e on d.d_deptno = e.e_d_deptno;

#11. Ausgabe aller Abteilungen, die keine Mitarbeiter beschäftigen
select *
from d_dept
where d_deptno not in (select e_d_deptno from e_emp);

#12. Ausgabe des gesamten Gehalts (Gehalt + Provision) aller Verkäufer
select e_ename, (e_sal + ifnull(e_comm, 0)) as total_salary
from e_emp
where e_job = 'salesman';

#13. Durchschnittliches Gehalt aller Verkäufer (Gehalt+Provision), hochgerechnet auf ein Jahr
select avg (e_sal + ifnull(e_comm, 0)) * 12 as avg_year_salary
from e_emp
where e_job = 'salesman';

#14. Anzahl der Mitarbeiter pro Job
select e_job, count(*) as num_employees
from e_emp
group by e_job;







