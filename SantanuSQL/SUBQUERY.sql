

use BankingManagementSystem;
select * from employee where name like '%k%' and EmpId < 2;

alter table employee add doj datetime null;
GO



select * from employee where doj > '2000-09-01'

insert into employee (empID,ManagerId,Name,doj)
values (1,1'Ankita','2002-04-27');

select emp.empID , emp.ManagerID, emp.Name EmpName, man.name manager,

case man.Name
when 'rakesh' then'r'
when 'suresh' then 's'
when 'ankita' then 'a'
else 'I am the boss'
end as Manager,
IIF(man.name = 'ankita','director','employee') designation
from employee emp left join employee man
on emp.managerID = man.EmpID;

select * from employee order by name desc, EmpId asc;



Create table Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  Grade Char(1),
  Salary Decimal(10, 6),
  [Name] VARCHAR(250),
  DOJ DateTime 
)

insert into Employee values (1, 'A', 1000, 'Ankita', getdate())
insert into Employee values (2, 'B', 2000, 'Rakesh', getdate())
insert into Employee values (3, 'C', 3000, 'Naresh', getdate())
insert into Employee values (4, 'A', 3000, 'Suresh', getdate())
insert into Employee values (6, 'B', 5000,  'Mahesh', getdate())
insert into Employee values (7, 'C', 6000,  'Mahesh', getdate())

select * from Employee;

select Grade, max(Salary) MAX_SALARY from employee group by Grade;
select Grade, min(Salary) MIN_SALARY from employee group by Grade;
select Grade, avg(Salary), COUNT(*) AVG_SALARY from employee group by Grade;
select Grade, sum(Salary) SUM_SALARY from employee group by Grade;

--query to check who is getting more avg salary in his/her job grade

select * from employee emp
join
(
select grade, avg(salary) as avg_salary
from employee group by grade
) as salary_compare 
 on emp.Grade = salary_compare.Grade and emp.Salary > salary_compare.avg_salary

 select * from employee emp
 join
 (select grade, avg(salary), count(*)
 from employee group by Grade) as avg grade
 ON emp.grade = avg_grade.grade and emp.salary > avg_salary;




