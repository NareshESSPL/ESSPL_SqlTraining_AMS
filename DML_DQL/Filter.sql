alter table Employee add DOJ DateTime NULL
select * from Employee where EmployeeID = 1
select * from Employee where Name = 'Ankita'
select * from Employee where Name like '%k%'
select * from Employee where Name like 'a%'
select * from Employee where Name like '%K%' and EmployeeID < 2
select * from Employee where DOJ > '2000-01-01'
select * from Employee where DOJ between '2000-09-01' and '2000-11-30 11:58:00.000'
select * from Employee where EmployeeID IN (1,2)
select * from Employee where EmployeeID IN (SELECT EmployeeID FROM Employee WHERE ManagerID = 2)
select * from Employee Where EmployeeID = 1 OR EmployeeID = 3


select emp.EmployeeID, emp.ManagerID, emp.Name EmpName, 

case man.Name
          when 'Rakesh' then 'R'		  
          when 'Suresh' then 'S'		  
          when 'Ankita' then 'A'
		  else 'I am the best'
end
as Manager,
IIF(man.Name = 'ankita', 'Director', 'Employee') Designation

from Employee emp left join Employee man 
on emp.ManagerID = man.EmployeeID

select * from Employee order by name

select * from Employee order by name desc, EmployeeID desc




