Create database BankingManagementSystem
go

use BankingManagementSystem
go

create Schema BMS;
go

-----------USER -----
CREATE TABLE BMS.[User]
(
  UserID BigInt Identity(1,1) Not Null,
  UserName NVarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  AccountNo BigInt Not Null,
  MobileNo BigInt Not Null,
  CreatedBy Varchar(250) Not Null,
 
 );

 ----------DROP TABLE BMS.[User]
 ALTER TABLE BMS.[User]
ADD CONSTRAINT [PK_BMS_User_UserID]  PRIMARY KEY  (UserID);



 INSERT INTO BMS.[User](
Username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
VALUES
('KHUSHBOO','2004-01-26','2025-04-03','1800.75','12345678','1234567890','KHUSHBOO'),
('GAUTAM','2004-04-28','2025-04-03','1700.75','98765432','0987654321','GAUTAM'),
('BABE','2008-04-18','2025-04-03','1000.75','98765431','0987654421','BABE'),
('KHUSHBOO','2004-01-26','2025-04-03','1000.75','12345678','1234567890','KHUSHBOO');

 Select * from BMS.[User];

 --------------ACCOUNT-----------------


 CREATE TABLE BMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);


ALTER TABLE BMS.Account
ADD CONSTRAINT [PK_BMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE BMS.[Account]
ADD CONSTRAINT DF_BMS_Account_Created DEFAULT GETDATE() FOR Created;

INSERT INTO BMS.Account
(
AccountNo,IsSaving,CreatedBy
)
VALUES
('987654321','400','KHUSHI'),
('987546892','200','PINKI'),
('987654892','600','RINKI');



Select * from BMS.Account;
--drop table BMS.Account;


----------------USERACCOUNTMAPPING---------------

CREATE TABLE BMS.UserAccountMapping (
    UserAccountMappingID BIGINT NOT NULL IDENTITY(1,1),
    UserID BIGINT NOT NULL,
    AccountID BIGINT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL,
);


ALTER TABLE BMS.[UserAccountMapping]
ADD CONSTRAINT PK_BMS_UserAccountMappingID_UserAccountMappingID PRIMARY KEY  (UserAccountMappingID);

ALTER TABLE BMS.[UserAccountMapping]
ADD CONSTRAINT DF_BMS_UserAccountMappingID_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE BMS.[UserAccountMapping]
ADD CONSTRAINT [FK_BMS_UserAccountMapping_UserID] FOREIGN KEY (UserID) REFERENCES BMS.[User](UserID);

ALTER TABLE BMS.[UserAccountMapping]
ADD CONSTRAINT [FK_MBS_UserAccountMapping_AccountID] FOREIGN KEY (AccountID) REFERENCES BMS.Account(AccountID);

INSERT INTO BMS.UserAccountMapping
(
UserID ,AccountID, CreatedBy
)
VALUES
(1,2,'KHUSHI'),
(2,3,'RINKI'),
(3,2,'PINKI');




Select * from BMS.UserAccountMapping;

---------JOIN--------------------
CREATE PROCEDURE KG
AS BEGIN
Select
   u.UserID,u.Username,u.DOB,u.DOJ,u.Balance,
   u.AccountNo as UserAccountNo,u.MobileNo,a.AccountID,
   a.AccountNo as AccountTableAccountNo,a.IsSaving,uam.UserAccountMappingID,uam.Created as MappingCreatedDate
   from
   BMS.[User] u
   join 
   BMS.UserAccountMapping uam ON u.UserID=uam.UserID
   join
   BMS.Account a on uam.AccountID=a.AccountID
END

EXEC KG

-------------find the users who does not have accounts-------------------------
SELECT u.* FROM BMS.[User] u 
JOIN BMS.[UserAccountMapping] uam ON uam.UserID = u.UserID 
WHERE uAM.AccountID IS NULL
-----------------------------------------------------------------------------------------
--Find User, Account detail for User who has avrerage balance of more than 10000--------------------
Select
u.Username,u.Balance,

a.AccountNo 
from
BMS.[User] u
join 
BMS.UserAccountMapping uam ON u.UserID=uam.UserID
join
BMS.Account a on uam.AccountID=a.AccountID
GROUP BY u.UserID
	  HAVING AVG(u.Balance) > 10000;


