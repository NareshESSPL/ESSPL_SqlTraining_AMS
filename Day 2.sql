create database AccountManagementSystem
go
use AccountManagementSystem
go

create Schema AMS;
go

CREATE TABLE AMS.[User]
(
  UserID BigInt Identity(1,1) Not Null,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  AccountNo Int Not Null,
  MobileNo Int Not Null,
  CreatedBy Varchar(250) Not Null,
  Created DateTime Not Null,
 )

ALTER TABLE AMS.[User]
ADD CONSTRAINT [PK_AMS_User_UserID]  PRIMARY KEY  (UserID);

ALTER TABLE AMS.[User]
ADD CONSTRAINT DF_AMS_User_Created DEFAULT GETDATE() FOR Created;

insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('Manjusha','2025-MARCH-07','09-APRIL-2002',1800.00,79888,98357,'Riya');
insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('Manju','2025-MARCH-07','09-APRIL-2002',1800.00,79888,98357,'Riya');
insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('M','2025-MARCH-07','09-APRIL-2002',1800.00,79888,98357,'Riya');
insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('Ma','2025-MARCH-07','09-APRIL-2002',1800.00,79888,98357,'Riya');
insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('Manjus','2025-MARCH-07','09-APRIL-2002',1800.00,79888,98357,'Riya');


delete from AMS.[User]  
DBCC CHECKIDENT ('AMS.[User]',RESEED,0);
go

set identity_insert AMS.[User] OFF;

select * from AMS.[User];

CREATE PROCEDURE AMS.Proc_User_Insert
@Username nvarchar,
@DOB datetime,
@DOJ datetime,
@Balance decimal,
@AccountNo int,
@MobileNo int,
@CreatedBy varchar
AS
BEGIN
insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
(@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
end


exec AMS.Proc_User_Insert 'testing','2025-02-02','2025-02-02',500,123,9876,'testuser';
select * from AMS.[User];
alter procedure AMS.Proc_User_Insert
@UserName nvarchar(250),
@DOB datetime,
@DOJ datetime,
@Balance decimal(10,6),
@AccountNo int,
@MobileNo int,
@CreatedBy varchar(250)='defaultUser'
as begin 
insert into AMS.[User](UserName,DOB,DOJ,balance,AccountNo,MobileNo,CreatedBy) values (@UserName ,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
end
EXEC AMS.Proc_User_Insert'testing','2025-02-02','2025-02-02',500,123,9876,'testuser';
 
 create procedure AMS.proc_UserandAddress_Insert
 @UserName nvarchar(250),
 @DOB datetime,
 @DOJ datetime,
 @Balance decimal(10,6),
 @AccountNo int,
 @MobileNo int,
 @AddressDetail nvarchar(max),
 @Createdby varchar(250) = 'defaultUser'
 as begin
   declare @UserId bigint
   insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)values
   (@username,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)
   set @UserId = scope_identity()
   insert into AMS.[Address](UserId,AddressDetail,CreatedBy)
   values(@UserId,@addressdetail,@CreatedBy)
 end


 exec AMS.proc_UserandAddress_Insert 'testing','2025-02-02','2025-02-02',500,123,9876,'fg';


 select * from AMS.[User];
 select * from AMS.[Address];




CREATE TABLE AMS.[Address] (
    AddressID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AddressDetail NVARCHAR(MAX) NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT PK_AMS_Address_AddressID PRIMARY KEY (AddressID);

ALTER TABLE AMS.[Address]
ADD CONSTRAINT DF_AMS_Address_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[Address]
ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

insert into AMS.[Address] (UserID , AddressDetail ,CreatedBy)
   VALUES (1,'fhgfhgfg','manju'),
   (2,'fhgfhg','manju'),
   (3,'fhgfhgfg','manju')
;
select * from AMS.[Address];


create TABLE AMS.[Account] (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
	

	

    Created DATETIME NOT NULL
);


ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR Created;

Select * from AMS.[Account];

insert into AMS.[Account] Values (101,0,'Manju','09-09-2025'),
   (102,1,'manju','01-03-2025'),
   (103,0,'manju','09-09-2025'),
   (104,0,'man','03-09-2025')
;

delete from AMS.[Account] where AccountID=2;
DBCC CHECKIDENT ('AMS.[User]',RESEED,0);
CREATE TABLE AMS.AccountTransaction(
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
	AccountID BIGINT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE AMS.[AccountTransaction]
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);


insert into AMS.[AccountTransaction] values (1,23.66,0,'hgrd','09-09-2024'),
 (2,23.86,0,'hgrd','09-09-2024'),
(3,23.86,0,'hgrd','09-09-2024'),
 (1,23.56,0,'hgrd','09-09-2024');

create TABLE AMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);


ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT PK_AMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT DF_AMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES AMS.[User](UserID);

ALTER TABLE AMS.[UserAccountMapping]
ADD CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

insert into AMS.[UserAccountMapping] values (102,1,'hgrd','09-09-2024'),
 (103,2,'hgrd','09-09-2024'),
(104,3,'hgrd','09-09-2024'),
 (105,1,'hgrd','09-09-2024');

create procedure AMS.Proc_UserAndAll_Insert
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @AddressDetail nvarchar(max),
 @IsSaving bit,
 @Amount decimal(20,2),
 @IsDebit bit,
 @CreatedBy	varchar(250) = 'defaultuser'
as begin
    
   declare @UserID bigint
   declare @AccountID bigint

   insert into AMS.[User] (UserName, DOB, DOJ, Balance, AccountNo, MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

   set @UserId = scope_identity()

   insert into AMS.[Address](UserId, AddressDetail, CreatedBy) 
   values (@UserId, @AddressDetail, @CreatedBy)

   INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
   VALUES(@AccountNo, @IsSaving, @CreatedBy)

   set @AccountID = SCOPE_IDENTITY()

   INSERT INTO AMS.UserAccountMapping(UserID, AccountID, CreatedBy)
   VALUES(@UserID, @AccountID, @CreatedBy)
   
   INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
   VALUES(@AccountID, @Amount, @IsDebit, @CreatedBy)
end

exec AMS.Proc_UserAndAll_Insert 'Harihara', '2000-12-25', '2020-08-13', 1200.0, 12345678, 87654321, 'Himalaya', 1, 5000.0, 0

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[UserAccountMapping];
SELECT * FROM AMS.[AccountTransaction];

Select * from AMS.[User] Inner Join AMS.[Address] on  AMS.[User].UserID=AMS.[Address].UserID;

Select * from AMS.[User] u where u.UserID in (select a.userid from AMS.Address a);

insert into AMS.[User] (UserName,DOB,DOJ,Balance ,AccountNo ,MobileNo , CreatedBy )
VALUES ('Manj','2025-MARCH-04','10-APRIL-2002',1850.00,79988,98157,'Paro');

Select * from AMS.[User] as u Left Join AMS.[Address] as a on u.UserID=a.UserID;

CREATE TABLE AMS.CreditCard
 (
   CreditCard BIGINT IDENTITY(1,1) PRIMARY KEY,
   UserID BIGINT,
   MobileNo VARCHAR(10),
   CardNo VARCHAR(16)
 )
 
 insert into AMS.CreditCard values(102, 1111111, 111);
 insert into AMS.CreditCard values(105, 1111111, null);
 insert into AMS.CreditCard values(null, 8888, null);

 Select * from AMS.CreditCard;

 Select * from AMS.[User] as u Left Join AMS.[CreditCard] as c on u.UserID=c.UserID;

 Select * from AMS.[CreditCard] as c Right Join AMS.[User] as u on c.CreditCard = u.UserID;
 
 create table AMS.CreditCardOffer
(
  CreditCardOfferID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
  CreditCardID BIGINT,
  Offer VARCHAR(MAX)
)

insert into AMS.CreditCardOffer values (1, 'Offer1')
insert into AMS.CreditCardOffer values (2, 'Offer2')
insert into AMS.CreditCardOffer values (Null, 'Offer2')
select * from AMS.CreditCardOffer;

Select * from AMS.[CreditCard] Cross Join AMS.[CreditCardOffer];

create table AMS.Employee
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Name VARCHAR(250)
)

insert into AMS.[Employee] values (1, Null, 'Ankita')
insert into AMS.[Employee] values (2, 1, 'Rakesh')
insert into AMS.[Employee] values (3, 2,'Naresh')
insert into AMS.[Employee] values (4, 2,'Suresh')
insert into AMS.[Employee] values (6, 4, 'Mahesh' , GETDATE

Select * from AMS.[Employee];

select emp.EmployeeID,emp.ManagerID,emp.Name EmpName,man.Name Manager from AMS.[Employee] emp left join AMS.[Employee] man on emp.managerID = man.EmployeeID;


Select * from AMS.[Employee] as E1 ,AMS.[Employee] as E2
WHERE E2.EmployeeID = E1.EmployeeID;

Select * from AMS.[Employee] as E1 JOIN AMS.[Employee] as E2
ON E2.EmployeeID = E1.EmployeeID;

Select * from AMS.[Employee] as E1 LEFT JOIN AMS.[Employee] as E2
ON E2.EmployeeID = E1.EmployeeID;

Select * from AMS.[Employee] as E1 RIGHT JOIN AMS.[Employee] as E2
ON E2.EmployeeID = E1.EmployeeID;

Select * from AMS.[Employee] as E1 CROSS JOIN AMS.[Employee] as E2
;

alter table AMS.[Employee] add DOJ DateTime NULL

select * from AMS.[Employee] where EmployeeID=1;
select * from AMS.[Employee] where Name='Ankita';
select * from AMS.[Employee] where Name like '%k%';
select * from AMS.[Employee] where Name='a%';
select * from AMS.[Employee] where Name='%k%' and EmployeeID<2;
select * from AMS.[Employee] where DOJ > '2000-01-01';
select * from AMS.[Employee] where DOJ between '2000-01-01' and '2000-11-30 11:58:00.000';
select * from AMS.[Employee] where EmployeeID IN (1,2);
select * from AMS.[Employee] where EmployeeID IN (SELECT EmployeeID FROM Employee WHERE ManagerID =2);
select * from AMS.[Employee] where EmployeeID = 1 or EmployeeID=3;
alter table AMS.[Employee] drop column DOJ  ;
alter table AMS.[Employee] drop column DOJ1  ;
alter table AMS.[Employee] drop column DOJ0  ;

select emp.EmployeeID,emp.ManagerID,emp.Name EmpName,
case man.Name
				when 'Rakesh' then 'R'
				when 'Suresh' then 'S'
				when 'Ankita' then  'A'
				else 'I am the best'
end
as manager

from AMS.[Employee] emp left join AMS.[Employee] man
on emp.ManagerID=man.EmployeeID


select emp.EmployeeID,emp.ManagerID,emp.Name EmpName,
case man.Name
				when 'Rakesh' then 'R'
				when 'Suresh' then 'S'
				when 'Ankita' then  'A'
				else 'I am the best'
end
as manager

from AMS.[Employee] emp left join AMS.[Employee] man
on emp.ManagerID=man.EmployeeID


select emp.EmployeeID,emp.ManagerID,emp.Name EmpName,
case man.Name
				when 'Rakesh' then 'R'
				when 'Suresh' then 'S'
				when 'Ankita' then  'A'
				else 'I am the best'
end
as Manager,
IIF(man.Name = 'Ankita','Director','Employee')Designation

from AMS.[Employee] emp left join AMS.[Employee] man
on emp.ManagerID=man.EmployeeID

select * from AMS.[Employee] order by Name
select * from AMS.[Employee] order by Name desc,EmployeeID desc;
select * from AMS.[Employee] order by Name;



drop table AMS.[Employee]

create table AMS.[Employee]
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  ManagerID BIGINT,
  Name VARCHAR(250)
)

insert into Employee values (1, Null, 'Ankita')
insert into Employee values (2, 1, 'Rakesh')
insert into Employee values (3, 2,'Naresh')
insert into Employee values (4, 2,'Suresh')

Create table AMS.[Employee]
(
  EmployeeID BIGINT NOT NULL PRIMARY KEY,
  Grade Char(1),
  Salary Decimal(10, 6),
  [Name] VARCHAR(250),
  DOJ DateTime 
)

insert into AMS.[Employee] values (1, 'A', 1000, 'Ankita', getdate())
insert into AMS.[Employee] values (2, 'B', 2000, 'Rakesh', getdate())
insert into AMS.[Employee] values (3, 'C', 3000, 'Naresh', getdate())
insert into AMS.[Employee] values (4, 'A', 3000, 'Suresh', getdate())
insert into AMS.[Employee] values (6, 'B', 5000,  'Mahesh', getdate())
insert into AMS.[Employee] values (7, 'C', 6000,  'Mahesh', getdate())
insert into AMS.[Employee] values (8, 'C', 7000,  'Adam', getdate())


select Grade from AMS.[Employee] group by Grade;
select Grade,AVG(Salary),COUNT(*) AVG_Salary from AMS.[Employee] group by Grade;
select Grade,MIN(Salary) AVG_Salary from AMS.[Employee] group by Grade;
select Grade,MAX(Salary) AVG_Salary from AMS.[Employee] group by Grade;

Select Grade,AVG(Salary) AVG_SALARY,COUNT(*)
from AMS.[Employee] group by Grade having AVG(Salary)>2000;




Select * from 

(
select 1 as id,2000  as salary,'B' as  grade
)as  x
join
(select 1 as id,'address' as address) as y
on x.id=y.id;

Select * from AMS.[Employee] emp
join
(
select Grade,avg(Salary) AVG_Salary,COUNT(*) c
from AMS.[Employee] group by Grade
) as avg_grade

on emp.Grade = avg_grade.Grade and emp.salary >AVG_Salary;
