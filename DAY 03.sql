CREATE DATABASE AccountManagementSystem
go

USE AccountManagementSystem
go

CREATE SCHEMA AMS;
GO

CREATE TABLE AMS.[User](
UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
DateOfBirth DATETIME NOT NULL,
DateOfJoining DATETIME NOT NULL,
Balance DECIMAL(10,6),
MobileNumber INT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

ALTER TABLE AMS.[User]
ALTER COLUMN MobileNumber BIGINT;

select * from AMS.[User];

INSERT INTO AMS.[User] (UserName, DateOfBirth, DateOfJoining, Balance, MobileNumber, CreatedBy, CreatedDate)
VALUES
    ('Jane', '1990-01-01', '2025-04-08', 1000.50, 1234567890, 'Admin', CURRENT_TIMESTAMP),
    ('Anant', '1985-03-15', '2025-04-08', NULL, 9876543210, 'Admin', CURRENT_TIMESTAMP),
    ('Brown', '1992-07-22', '2025-04-08', 500.00, 1122334455, 'Admin', CURRENT_TIMESTAMP);





CREATE TABLE AMS.[Account](
AccountID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

select * from AMS.[Account];

INSERT INTO AMS.[Account] (UserName, IsSaving, CreatedBy, CreatedDate)
VALUES
    ( 'ABC', 0, 'Admin', CURRENT_TIMESTAMP),
    ('DHF', 1, 'Admin', CURRENT_TIMESTAMP),
    ('adsd', 1, 'Admin', CURRENT_TIMESTAMP);

ALTER TABLE AMS.[Account]
ADD AccountNo INT NOT NULL DEFAULT 100;

UPDATE AMS.[Account]
SET AccountNo = 2
WHERE UserName = 'ABC';

UPDATE AMS.[Account]
SET AccountNo = 3
WHERE UserName = 'DHF'; 

UPDATE AMS.[Account]
SET AccountNo = 5
WHERE UserName = 'adsd'; 





CREATE TABLE AMS.[UserAccountMapping](
UserAccountMappingID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																													
AccountID BIGINT NOT NULL,		
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()

CONSTRAINT FK_UserAccountMapping_User FOREIGN KEY(UserID)
REFERENCES AMS.[User](UserID),
CONSTRAINT
FK_UserAccountMapping_Account FOREIGN KEY (AccountID)
REFERENCES AMS.[Account](AccountID)
);

select * from AMS.[UserAccountMapping];
INSERT INTO AMS.[UserAccountMapping] (UserID, AccountID, CreatedBy, CreatedDate)
VALUES
    ( 11, 1, 'Admin', CURRENT_TIMESTAMP),
    ( 12, 2, 'Admin', CURRENT_TIMESTAMP),
    ( 13, 3, 'Admin', CURRENT_TIMESTAMP);




CREATE TABLE AMS.[Address](
AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,
Address NVARCHAR(MAX) NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Address_User
FOREIGN KEY(UserID)
REFERENCES AMS.[User](UserID)
);

select * from AMS.[Address];

INSERT INTO AMS.[Address] (UserID, Address, CreatedBy, CreatedDate)
VALUES
    ( 11,  'Vani vihar', 'Admin', CURRENT_TIMESTAMP),
    ( 12, 'jaydev vihar' , 'Admin', CURRENT_TIMESTAMP),
    ( 13, 'acharya vihar', 'Admin', CURRENT_TIMESTAMP);





CREATE TABLE AMS.[AccountTransaction](
AccountTransactionID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
AccountID BIGINT NOT NULL,
Amount DECIMAL(10,6) NOT NULL,
IdDebt BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),

CONSTRAINT FK_Transaction_Account
FOREIGN KEY(AccountID)
REFERENCES AMS.[Account](AccountID)
);

select * from AMS.[AccountTransaction];

INSERT INTO AMS.[AccountTransaction] (AccountID, Amount, IdDebt, CreatedBy, CreatedDate)
VALUES
    ( 1, 1000.50, 0, 'Admin', CURRENT_TIMESTAMP),
    ( 2, 100, 1, 'Admin', CURRENT_TIMESTAMP),
    ( 3, 500.00, 0, 'Admin', CURRENT_TIMESTAMP);


	

SELECT * FROM AMS.[User] as a
LEFT JOIN AMS.Address as b
ON a.UserID=b.UserID
WHERE a.UserID<7

CREATE TABLE AMS.CreditCard(
CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
UserID BIGINT,
MobileNo VARCHAR(10),
CardNo VARCHAR(16)
)
INSERT INTO AMS.CreditCard	VALUES(13, 92486234, 555);
INSERT INTO AMS.CreditCard	VALUES(245, 92365475, 998);
INSERT INTO AMS.CreditCard	VALUES(NULL, 8364245, NULL);

SELECT * FROM AMS.CreditCard

SELECT * FROM AMS.[User] as a
CROSS JOIN AMS.CreditCard AS b



Create table CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into CreditCardOffer values (1, 'Offer1')
insert into CreditCardOffer values (2, 'Offer2')
insert into CreditCardOffer values (Null, 'Offer2')

SELECT * FROM CreditCardOffer as a
CROSS JOIN AMS.CreditCard AS b










DROP table Employee
(
  EmployeeID BIGINT  NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Name VARCHAR(MAX)
)


insert into Employee values (1, Null, 'Ankita')
insert into Employee values (2, 1, 'Rakesh')
insert into Employee values (3, 2,'Naresh')
insert into Employee values (4, 2,'Suresh')

SELECT a.name, a.EmployeeID, b.ManagerID, b.Name AS Reports_to FROM Employee as a
LEFT JOIN Employee AS b 
ON  a.ManagerID=b.EmployeeID

SELECT * FROM Employee ORDER BY EmployeeID DESC, Name ASC
SELECT * FROM Employee WHERE Name LIKE '%s_'
SELECT * FROM Employee WHERE Name LIKE '%s_'
SELECT * FROM Employee WHERE Name LIKE '%s_'

SELECT * FROM Employee WHERE DOJ > '2001-04-02'
SELECT * FROM Employee WHERE DOJ BETWEEN '2001-04-02' AND '2009-09-08'
SELECT * FROM Employee WHERE EmployeeID IN (1,2)
SELECT * FROM Employee WHERE EmployeeID IN (SELECT EmployeeID FROM Employee WHERE ManagerID=2)

SELECT emp.EmployeeID, emp.ManagerID, emp.Name AS EmpName, MAN.Name,
CASE man.Name  
WHEN 'Rakesh' then 'R'
WHEN 'Naresh' then 'N'
WHEN 'Ankita' then 'A'
ELSE 'HERE'
END AS Manager

FROM Employee AS emp LEFT JOIN Employee AS man ON emp.ManagerID = MAN.EmployeeID




SELECT emp.EmployeeID, emp.ManagerID, emp.Name AS EmpName, MAN.Name,
CASE MAN.Name  
	WHEN 'Rakesh' then 'R'
	WHEN 'Naresh' then 'N'
	WHEN 'Ankita' then 'A'
	ELSE 'HERE'
END 
AS Manager,
IIF(MAN.Name='ankita', 'Director', 'Employee') Designation

FROM Employee AS emp LEFT JOIN 
Employee AS MAN ON emp.ManagerID = MAN.EmployeeID



Create table Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  Grade Char(1),
  Salary Decimal(10, 6),
  [Name] VARCHAR(250),
  DOJ DateTime 
)

insert into Employee values (1, 'A', 1000, 'kioo', getdate())
insert into Employee values (2, 'B', 2000, 'sdfas', getdate())
insert into Employee values (3, 'C', 3000, 'sdfs', getdate())
insert into Employee values (4, 'A', 3000, 'rghrgh', getdate())
insert into Employee values (6, 'B', 5000,  'dgrth', getdate())
insert into Employee values (7, 'C', 6000,  'bbbbbbbbbb', getdate())

SELECT Grade, AVG(Salary) AS AVG_SALARY FROM Employee GROUP BY Grade

SELECT Name, Salary FROM Employee
WHERE Salary>(SELECT AVG(Salary) FROM Employee )


SELECT E1.Name, E1.Salary, E1.Grade 
FROM Employee AS E1
WHERE E1.Salary>(SELECT AVG(E2.Salary)
				FROM Employee AS E2
				WHERE e1.Grade= e2.Grade
				)


select *  FROM Employee as x
join (
  select AVG(Salary) AS avg_sal, Grade FROM Employee GROUP BY Grade
) as y
on x.Grade = y.Grade
WHERE x.Salary > y.avg_sal



SELECT  MAX(Salary) AS MAX_SALARY FROM Employee 
SELECT  SUM(Salary) AS SUM_SALARY FROM Employee 
SELECT DISTINCT(Grade) FROM Employee 

SELECT COUNT(Grade) AS NoOf FROM Employee 



