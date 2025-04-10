use AccountManagementSystem
go

select * from AMS.[User] inner join AMS.[Address] on AMS.[User].UserId = AMS.[Address].UserID;
select * from AMS.[User] as u where u.UserID in (select a.UserID from AMS.[Address] a)
select * from AMS.[User] left join AMS.[Address] on AMS.[User].UserId = AMS.[Address].UserID;

CREATE TABLE AMS.CreditCard (
    UserID BIGINT PRIMARY KEY,
    MobileNo VARCHAR(10),
    Cardno VARCHAR(16) 
);

-- Insert record into the CreditCards table
INSERT INTO AMS.[CreditCard] (UserID, MobileNo, CardNo)
VALUES (101, '9876543210', '4123456789012345');
INSERT INTO AMS.[CreditCard] (UserID, MobileNo, CardNo)
VALUES (102, '9876543210', 'null');
INSERT INTO AMS.[CreditCard] (UserID, MobileNo, CardNo)
VALUES (12, '9876543210', 'null');
INSERT INTO AMS.[CreditCard] (UserID, MobileNo, CardNo)
VALUES (1, '9876543210', 'null');
INSERT INTO AMS.[CreditCard] (UserID, MobileNo, CardNo)
VALUES (2, '9876543210', '2343253');

select * from AMS.[User] left join AMS.[CreditCard] on AMS.[User].UserId = AMS.[CreditCard].UserID;
select * from AMS.[User] as u right join AMS.[CreditCard] as c on u.UserID = c.UserID; 

Create table AMS.CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into AMS.CreditCardOffer values (1, 'Offer1')
insert into AMS.CreditCardOffer values (2, 'Offer2')
insert into AMS.CreditCardOffer values (Null, 'Offer2')
insert into AMS.CreditCardOffer values (12, 'Offer2')

select * from AMS.CreditCardOffer
select * from AMS.CreditCardOffer as co cross join AMS.CreditCard c;

DROP table Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Name VARCHAR(250)
)

insert into Employee values (1, Null, 'Ankita')
insert into Employee values (2, 1, 'Rakesh')
insert into Employee values (3, 2,'Naresh')
insert into Employee values (4, 2,'Suresh')

ALTER TABLE Employee add DOJ DATETIME NULL;

select * from Employee as a left join Employee as b on a.EmployeeID = b.ManagerID
select * from Employee as a right join Employee as b on a.EmployeeID = b.ManagerID;

select * from Employee where EmployeeID = 1;
select * from Employee where Name = 'Ankita';
select * from Employee where Name like '%a%'  and EmployeeID <=2;
select * from Employee where DOJ > '2000-01-01';
select * from Employee where EmployeeID in (1,2);
select * from Employee where EmployeeID in (SELECT EmployeeID from Employee WHERE ManagerID = 2);
select * from Employee where EmployeeID = 1 OR EmployeeID =3;

select emp.EmployeeID ,emp.ManagerId, emp.Name as EmpName ,
case man.Name 
when 'Rakesh' then 'R'
when 'Suresh' then 'S'
when 'Ankita' then 'A'
else 'i am the boss'
end as Manager
from Employee as emp left join Employee as man on emp.ManagerID = man.EmployeeID;

select emp.EmployeeID ,emp.ManagerId, emp.Name as EmpName ,
case man.Name 
when 'Rakesh' then 'R'
when 'Suresh' then 'S'
when 'Ankita' then 'A'
else 'i am the boss'
end as Manager,
IIF(man.Name = 'ankita','Director','Employee') Designation
from Employee as emp left join Employee as man on emp.ManagerID = man.EmployeeID;

select * from Employee order by name;
select * from Employee order by name desc, EmployeeID desc;

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

select Grade, AVG(Salary) AVG_SALARY FROM Employee group by Grade;
select Grade, MIN(Salary) MIN_SALARY FROM Employee group by Grade;

select * from 
(
  select * from Employee
) as x

join 
(
  select AVG(Salary) avg_salary , Grade from Employee group by Grade
) as y

on x.Grade = y.Grade
where x.Salary > y.avg_salary;

-- ASSIGNMENT ANSWERS --

select * from AMS.[User];

select * from AMS.Account;

SELECT * FROM AMS.[UserAccountMapping];

-- user with more than avg balance

SELECT u.UserID,u.UserName,u.Balance,a.AccountID
	FROM AMS.[User] u
	Join
	AMS.[UserAccountMapping] map ON u.UserID=map.UserID
	join 
	AMS.[Account] a on map.AccountId=a.AccountID
	join 
	(Select AVG(u.Balance) as AVG_BAL  from AMS.[User] u)
	as ab on u.Balance>ab.AVG_BAL;

-- user having multiple account

SELECT 
    u.UserID,
    u.UserName,
    COUNT(uam.AccountID) AS TotalAccounts
FROM 
    ams.[User] u
JOIN 
    ams.UserAccountMapping uam ON u.UserID = uam.UserID
GROUP BY 
    u.UserID, u.UserName
HAVING 
    COUNT(uam.AccountID) > 1;

--user having no address

SELECT 
    u.UserID,
    u.UserName,
    u.MobileNo,
    u.Balance
FROM 
    ams.[User] u
LEFT JOIN 
    ams.Address a ON u.UserID = a.UserID
WHERE 
    a.AddressID IS  NULL
go




