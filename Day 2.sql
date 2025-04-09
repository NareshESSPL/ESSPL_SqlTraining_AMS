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