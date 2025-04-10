------------------------------------------------------JOINS-------------------------------------------------------
USE AccountManagementSystem
GO

--INNER JOIN
SELECT * FROM AMS.[User] AS u
INNER JOIN AMS.[Address] a ON(u.UserID = a.UserID)
--LEFT JOIN
SELECT * FROM AMS.[User]
LEFT JOIN AMS.[Address] ON(AMS.[User].UserID = AMS.[Address].UserID)

CREATE TABLE AMS.CreditCard
(
	CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
	UserID BIGINT,
	MobileNumber VARCHAR(10),
	CardNumber VARCHAR(16)
)
INSERT INTO AMS.CreditCard 
VALUES
	(71,1111111,1111),
	(1111,111111,NULL),
	(NULL, 8888, NULL);

INSERT INTO AMS.CreditCard 
VALUES
	(10,1111111,1111);

SELECT * FROM AMS.CreditCard
--LEFT JOIN
SELECT u.UserID U_uid, c.CreditCard, c.UserID c_uid, c.MobileNumber FROM AMS.[User] AS u 
LEFT JOIN AMS.CreditCard c ON(u.UserID = c.UserID)
--RIGHT JOIN
SELECT u.UserID U_uid, c.CreditCard, c.UserID c_uid, c.MobileNumber FROM AMS.[User] AS u 
RIGHT JOIN AMS.CreditCard c ON(u.UserID = c.UserID)


Create table AMS.CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into AMS.CreditCardOffer values (1, 'Offer1')
insert into AMS.CreditCardOffer values (2, 'Offer2')
insert into AMS.CreditCardOffer values (Null, 'Offer2')

SELECT * FROM AMS.CreditCardOffer;
--CROSS JOIN
SELECT * FROM AMS.CreditCard 
CROSS JOIN AMS.CreditCardOffer  


CREATE TABLE Employee
(
	EmployeeID BIGINT  NOT NULL PRIMARY KEY,
    ManagerID BIGINT,
    Name VARCHAR(MAX)
)

insert into Employee values (1, NULL, 'CAM')
insert into Employee values (2, 1,  'QAM')
insert into Employee values (3, 2, 'SAM')
insert into Employee values (4, 2, 'TAM')
insert into Employee values (5, 4, 'EAM', GETDATE())

SELECT * FROM Employee
--SELF JOIN
SELECT E1.Name, E1.EmployeeID, E2.ManagerID, E2.Name AS MANAGER  FROM Employee AS E1
LEFT JOIN Employee E2 ON(E1.ManagerID=E2.EmployeeID)

SELECT E1.Name, E1.EmployeeID, E2.ManagerID,
CASE E2.NAME
		WHEN 'TAM' THEN 'T'
		WHEN 'QAM' THEN 'Q'
		WHEN 'CAM' THEN 'C'
		ELSE 'I AM THE BEST'
END
AS MANAGER
FROM Employee AS E1
LEFT JOIN Employee E2 ON(E1.ManagerID=E2.EmployeeID)

-------------------------------------------------FILTERING-----------------------------------------------------------------------------

USE AccountManagementSystem
GO



ALTER TABLE Employee ADD DOJ DateTime NULL
--EXAMPLE
SELECT * FROM Employee WHERE EmployeeID = 1
SELECT * FROM Employee WHERE Name = 'CAM'
--LIKE EXAMPLE
SELECT * FROM Employee WHERE Name LIKE 'Q%'
--AND EXAMPLE
SELECT * FROM Employee WHERE Name LIKE '%A%' AND EmployeeID < 2
SELECT * FROM Employee WHERE DOJ > '2000-01-01'
--BETWEEN EXAMPLE
SELECT * FROM Employee WHERE DOJ BETWEEN '2000-01-01' AND '2000-10-31'
--IN EXAMPLE
SELECT * FROM Employee WHERE EmployeeID IN (1,2)
SELECT * FROM Employee WHERE EmployeeID IN (SELECT EmployeeID FROM Employee WHERE ManagerID = 2)
--OR EXAMPLE
SELECT * FROM Employee WHERE EmployeeID = 1 OR EmployeeID = 3
--CASE EXAMPLE
SELECT E1.Name, E1.EmployeeID, E2.ManagerID, E2.Name ,
CASE E2.NAME
		WHEN 'TAM' THEN 'T'
		WHEN 'QAM' THEN 'Q'
		WHEN 'CAM' THEN 'C'
		ELSE 'I AM THE BEST'
END
AS MANAGER
FROM Employee AS E1
LEFT JOIN Employee E2 ON(E1.ManagerID=E2.EmployeeID)
--IIF EXAMPLE
SELECT E1.Name, E1.EmployeeID, E2.ManagerID, E2.Name ,
CASE E2.NAME
		WHEN 'TAM' THEN 'T'
		WHEN 'QAM' THEN 'Q'
		WHEN 'CAM' THEN 'C'
		ELSE 'I AM THE BEST'
END
AS MANAGER,
IIF(E2.Name = 'CAM', 'Director', 'Employee') Designation
FROM Employee AS E1
LEFT JOIN Employee E2 ON(E1.ManagerID=E2.EmployeeID)

--ORDER EXAMPLE
SELECT * FROM Employee ORDER BY Name
SELECT * FROM Employee ORDER BY Name DESC
SELECT * FROM Employee ORDER BY EmployeeID DESC
--WHILE ARRANGING IN NAME IF SAME NAME IS THERE THEN ORDER BY ID
SELECT * FROM Employee ORDER BY Name DESC, EmployeeID DESC

--GROUPING
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
insert into Employee values (8, 'C', 7000,  'ADAM', getdate())

--GROUPING BY
SELECT Grade FROM Employee GROUP BY Grade
--SOME ATTRIBUTES ARE SUM(), AVG(), MAX(), MIN(), COUNT()
SELECT Grade,AVG(Salary) AVERAGE_SALARY FROM Employee GROUP BY Grade 
SELECT Grade,MAX(Salary) MAXIMUM_SALARY FROM Employee GROUP BY Grade 
SELECT Grade,MIN(Salary) MINIMUM_SALARY FROM Employee GROUP BY Grade 
SELECT Grade,SUM(Salary) SUM_OF_SALARY FROM Employee GROUP BY Grade 
--HAVING EXAMPLE
SELECT Grade,AVG(Salary) AVERAGE_SALARY FROM Employee GROUP BY Grade HAVING AVG(Salary) > 2000
--HAVING EXAMPLE WITH COUNT ATTRIUTE
SELECT Grade,AVG(Salary) AVERAGE_SALARY,COUNT(*) FROM Employee GROUP BY Grade HAVING AVG(Salary) > 2000
SELECT Grade,AVG(Salary) AVERAGE_SALARY,COUNT(*) FROM Employee GROUP BY Grade, Salary HAVING AVG(Salary) > 2000
SELECT Grade,AVG(Salary) AVERAGE_SALARY,COUNT(*) FROM Employee GROUP BY Salary, Grade HAVING AVG(Salary) > 2000
--TO FIND WHO HAVE MORE SALARY THAN GRADE AVERAGE SALARY IN THEIR RESPECTIVE GRADE
select * from 
(
  SELECT EmployeeID, Name, SALARY, Grade FROM Employee 
) as x

join 
(
  SELECT Grade,AVG(Salary) AVERAGE_SALARY FROM Employee GROUP BY Grade 
) as y

on x.Grade = y.Grade
WHERE x.Salary > y.AVERAGE_SALARY

