/*
Created Date : 09-04-2025
Created By : Suraj Kumar Sah
Desc : DML/DQL Opearions
*/

USE AccountManagementSystem;
GO

-- Display the Table data
SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[UserAccountMapping];
SELECT * FROM AMS.[AccountTransaction];

SELECT * FROM AMS.[User] INNER JOIN AMS.[Address] ON AMS.[User].UserID = AMS.[Address].UserID;

--Using Aliases
SELECT * FROM AMS.[User] AS U INNER JOIN AMS.[Address] AS A ON U.UserID = A.UserID;

--Filtering
SELECT * FROM AMS.[User] AS U WHERE U.UserID = 113;
SELECT * FROM AMS.[User] AS U WHERE U.UserID  IN (SELECT A.UserID FROM AMS.[Address] A);

--All the user who may or may not has addressdetails
SELECT * FROM AMS.[Address] AS A LEFT JOIN AMS.[User] AS U ON A.UserID = U.UserID WHERE A.AddressDetail = '';
SELECT * FROM AMS.[User] AS U LEFT JOIN AMS.[Address] AS A ON U.UserID = A.UserID;



-- CreditCard Table
CREATE TABLE AMS.[CreditCard]
(
  CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
  UserID BIGINT,
  MobileNo VARCHAR(10),
  CardNo VARCHAR(16)
);

INSERT INTO AMS.CreditCard VALUES(113, 1111, 1101);
INSERT INTO AMS.CreditCard VALUES(113, 1111, 1101);
INSERT INTO AMS.CreditCard VALUES(1111, 1111111, null);
INSERT INTO AMS.CreditCard VALUES(null, 8888, null);

SELECT * FROM AMS.[CreditCard];

--All details creditcard whose corresponding user details may or may not be present.
SELECT u.UserID AS 'UserKaUserID', u.username, c.CreditCard, c.MobileNo, c.UserID, c.CardNo AS 'CreditCardUserID' FROM ams.[User] u RIGHT JOIN ams.[CreditCard] c ON u.UserID = c.UserID;


/* Creating CreditCardOffer Table */
Create table AMS.[CreditCardOffer]
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
);

INSERT INTO AMS.[CreditCardOffer] VALUES (1, 'Offer1')
INSERT INTO AMS.[CreditCardOffer] VALUES (2, 'Offer2')
INSERT INTO AMS.[CreditCardOffer] VALUES (Null, 'Offer2')

SELECT * FROM AMS.[CreditCardOffer];
SELECT * FROM AMS.[CreditCard];
SELECT * FROM AMS.[User];

--Cross Join
SELECT * FROM AMS.[CreditCard] CROSS JOIN ams.[CreditCardOffer];


/*
Creating Employee Table in Default schema 'dbo' to demonstrate the use of SELF JOIN
*/
USE AccountManagementSystem;
CREATE TABLE Employee(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Namee VARCHAR(250),
  DOB DATETIME
);

INSERT INTO Employee VALUES (1, Null, 'Ankita', '1999-02-01');
INSERT INTO Employee VALUES (2, 1, 'Rakesh', '2002-03-01');
INSERT INTO Employee VALUES (3, 2,'Naresh', '1989-04-01');
INSERT INTO Employee VALUES (4, 2,'Suresh', '2009-01-01');
INSERT INTO Employee VALUES (6, 4,'Suresh', GETDATE());
INSERT INTO Employee VALUES (7, 4,'Suresh', GETDATE());


SELECT * FROM Employee;

/* SELF JOIN */
SELECT Emp.namee AS 'Employee', Man.namee AS Manager from Employee Emp INNER JOIN Employee Man ON Emp.ManagerID=Man.EmployeeID;
SELECT Emp.namee AS 'Employee', Man.namee AS Manager from Employee Emp LEFT JOIN Employee Man ON Emp.ManagerID=Man.EmployeeID;
SELECT Emp.namee AS 'Employee', Man.namee AS Manager from Employee Emp RIGHT JOIN Employee Man ON Emp.ManagerID=Man.EmployeeID;

-- DISTINCT
-- Distinct manager names
SELECT DISTINCT Man.namee AS Manager from Employee Emp LEFT JOIN Employee Man ON Emp.ManagerID=Man.EmployeeID;


/*
  Filtering
*/
SELECT * from Employee;

-- Integer Filtering
SELECT * from Employee where EmployeeID = 2;
SELECT * from Employee where EmployeeID > 2;
SELECT * from Employee where EmployeeID BETWEEN 1 and 3;


-- String Filtering
SELECT * from Employee where Namee LIKE 'R%';
SELECT * from Employee where Namee LIKE '%R';
SELECT * from Employee where Namee LIKE '%K%' AND EmployeeID = 2;
-- DATE Filtering
SELECT * from Employee where DOB < '2000-01-01';
SELECT * from Employee where DOB BETWEEN '2000-01-01' AND '2025-01-01';

-- IN Operator
SELECT * FROM Employee WHERE EmployeeID IN(1, 3);
SELECT * FROM Employee WHERE EmployeeID IN(SELECT EmployeeID FROM Employee WHERE ManagerID=2);

-- OR Operator
SELECT * FROM Employee WHERE EmployeeID=1 OR EmployeeID=3;

-- ISNULL() Function
SELECT * from Employee;
SELECT Emp.EmployeeID, Emp.ManagerID, Emp.Namee, ISNULL(Man.EmployeeID, 'Boss') 'Boss Boss', Emp.DOB
FROM Employee Emp INNER JOIN Employee Man ON Emp.ManagerID = Man.EmployeeID;

GO
-- CASE Statement

SELECT Emp.EmployeeID, Emp.ManagerID, Emp.Namee,
  CASE Man.Namee
    WHEN 'Rakesh' THEN 'R' 
	WHEN 'Naresh' THEN 'N' 
	WHEN 'Suresh' THEN 'S'
	WHEN 'Ankita' THEN 'A' 
    ELSE 'I am the Boss'
  END
AS Manager, 
IIF(Man.Namee='Ankita', 'Director', 'Employee') AS Designation
FROM Employee Emp LEFT JOIN Employee Man ON emp.ManagerID = man.EmployeeID;

 
-- ORDER BY Clause
SELECT * FROM Employee ORDER BY Namee;
SELECT * FROM Employee ORDER BY Namee ASC, EmployeeID DESC;


/* 
Creating table Employee1 to Demonstrate the GROUP BY clause along with Aggregate Functions

*/
CREATE TABLE Employee1
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  Grade Char(1),
  Salary Decimal(10, 6),
  Namee VARCHAR(250),
  DOJ DateTime 
);

INSERT INTO Employee1 VALUES (1, 'A', 1000, 'Ankita', getdate())
INSERT INTO Employee1 VALUES (2, 'B', 2000, 'Rakesh', getdate())
INSERT INTO Employee1 VALUES (3, 'C', 3000, 'Naresh', getdate())
INSERT INTO Employee1 VALUES (4, 'A', 3000, 'Suresh', getdate())
INSERT INTO Employee1 VALUES (6, 'B', 5000,  'Mahesh', getdate())
INSERT INTO Employee1 VALUES (7, 'C', 6000,  'Mahesh', getdate())

SELECT * FROM Employee1;

-- GROUP BY Clause with Aggregate Functions( AVG(), MAX(), MIN(), etc )
SELECT Grade, COUNT(Grade) 'Count', AVG(Salary) AvgSalary FROM Employee1 GROUP BY Grade;
SELECT Grade, COUNT(Grade) 'Count', MAX(Salary) AvgSalary FROM Employee1 GROUP BY Grade;
SELECT Grade, COUNT(Grade) 'Count', MIN(Salary) AvgSalary FROM Employee1 GROUP BY Grade;

SELECT Grade, AVG(Salary) AVG_SALARY FROM Employee1 GROUP BY Grade, Salary HAVING AVG(Salary) > 2000;

-- SubQuery
/* Find employees details grade-wise whose salary is greater than the average salary*/
-- Method-1 (Using JOIN - Use if dataset is huge)
SELECT Emp.Namee, Emp.Grade, Emp.Salary FROM Employee1 Emp 
INNER JOIN 
  (
	SELECT Grade, AVG(Salary) AVG_SALARY FROM Employee1 GROUP BY Grade
  )
AS Temp ON Emp.Grade=Temp.Grade 
WHERE
Emp.Salary > Temp.AVG_SALARY;

-- Method-2 (Using Subquery - Use if dataset is small)
SELECT Emp.Namee, Emp.Grade, Emp.Salary FROM Employee1 Emp
WHERE Salary > 
  (
    SELECT AVG(Salary) from Employee1 WHERE Grade = Emp.Grade
  );


-- Without creating Table 
select * from 
(
	select 1 as id, 2000 as salary, 'B' as grade
) as X
INNER JOIN
(
	select 1 as id, 'address' as address
) as Y ON X.id = Y.id;

select * from ams.[User] where UserID in (select UserID from ams.[Address]);

/*
When to use JOIN and SubQuery
 - When data is less in RHS side, use subquery
 - When data is huge in RHS side, use JOIN
*/