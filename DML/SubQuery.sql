select * from 
(
  select 1 as id, 2000 as salary, 'B' as grade 
) as x

join 
(
  select 1 as id, 'addres' as address
) as y

on x.id = y.id

select * from Employee emp

join

( 
  select Grade, AVG(Salary) AVG_SALARY, COUNT(*)  
  from Employee group by Grade
) as avg_grade

on emp.Grade = avg_grade.Grade and emp.Salary > AVG_SALARY


select * from AMS.[User] where UserID IN (SELECT UserID FROM AMS.Address) 