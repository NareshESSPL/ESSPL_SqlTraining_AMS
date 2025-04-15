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
insert into Employee values (7, 'C', 7000,  'Adam', getdate())



select Grade, AVG(Salary) AVG_SALARY, COUNT(*)  
from Employee group by Grade having AVG(Salary) > 2000

select Grade, AVG(Salary) AVG_SALARY, COUNT(*) 
from Employee group by Grade, Salary having AVG(Salary) > 2000

select Grade, AVG(Salary) AVG_SALARY, COUNT(*) 
from Employee group by Salary, Grade having AVG(Salary) > 2000


select Grade, MIN(Salary) AVG_SALARY from Employee group by Grade
select Grade, MAX(Salary) AVG_SALARY from Employee group by Grade



