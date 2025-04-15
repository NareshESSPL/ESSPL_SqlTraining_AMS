create table AppUser 
(
 UserID int,
 UserName varchar(250)
)

create table AppRole
(
  RoleID int,
  RoleName varchar(250)
)

create table AppUserRoleMapping
(  
  RoleID int,
  UserID int
)

select * from AppUser u join AppUserRoleMapping a on u.UserID = a.UserID

select * from AppUser u where u.UserID in (select userid from AppUserRoleMapping);

/*
**
  Corelated subquery
**
*/
select u.UserID,
		( 
		  select top 1 RoleID from AppUserRoleMapping a where u.UserID = a.UserID
		) as roleid
from AppUser u

SELECT last_name, salary, department_id
 FROM employees outer
 WHERE salary >
                (SELECT AVG(salary)
                 FROM employees
                 WHERE department_id =
                        outer.department_id group by department_id);

