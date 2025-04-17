
-- Joins the two tables
SELECT * FROM BMS.[USER] U
JOIN BMS.[Address] A ON U.UserID = A.UserID;

--Sub Query:
select * from BMS.[User] U where U.UserID in (select A.UserID FROM BMS.[Address] A);

INSERT INTO BMS.[User] (Username, DOB, DOJ, Balance, MobileNo, CreatedBy, Created)
VALUES 
('Satya Nadella','1985-01-15','2020-06-01', 1000.50, 12345678, 'Admin', GETDATE());
GO

ALTER TABLE BankingManagementSystem.BMS.[Address]
ALTER COLUMN Address VARCHAR(250) NULL;

INSERT INTO BMS.[Address] (Username,UserID, CreatedBy,CreatedDate)
VALUES 
('John Doe',1, 'Admin',GETDATE())

SELECT *
FROM BankingManagementSystem.BMS.[USER] U
JOIN BankingManagementSystem.BMS.[Address] A ON U.UserID = A.UserID WHERE A.Address is null;


SELECT * FROM BMS.[user];


CREATE TABLE BMS.CreditCard
(
  CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
  UserID BIGINT,
  MobileNo VARCHAR(10),
  CardNo VARCHAR(16)
);
go


INSERT INTO BMS.CreditCard VALUES(1, 1111111, 111);
INSERT INTO BMS.CreditCard VALUES(2, 1111111, null);
INSERT INTO BMS.CreditCard VALUES(111, 8888, null);

SELECT * FROM BMS.[CreditCard];

SELECT C.CreditCard,C.UserID FROM BMS.[User] AS U
RIGHT JOIN BMS.[CreditCard] AS C on U.UserId = C.UserId;

Create table CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into CreditCardOffer values (1, 'Offer1')
insert into CreditCardOffer values (2, 'Offer2')
insert into CreditCardOffer values (Null, 'Offer2')

SELECT * FROM CreditCardOffer CROSS JOIN BMS.[CreditCard];

Create table Employee
(
 EmpID BIGINT NOT NULL PRIMARY KEY,
 ManagerID BIGINT,
 Name VARCHAR(250)
);
GO

insert into Employee values (1, Null, 'Ankita')
insert into Employee values (2, 1, 'Rakesh')
insert into Employee values (3, 2,'Naresh')
insert into Employee values (4, 2,'Suresh'); 
GO

SELECT * FROM EMPLOYEE;

SELECT emp.EmpID,EMP.ManagerID,EMP.Name EmpName, MAN.Name ManagerName
FROM Employee AS EMP
LEFT JOIN Employee AS MAN ON EMP.ManagerID = MAN.EmpID;
