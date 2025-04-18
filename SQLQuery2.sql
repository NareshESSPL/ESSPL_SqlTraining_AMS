/*
    Created By Shresth.
    Created Date:09/04/25
/*


Create database AccountManagementSystem
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

--ALTER TABLE AMS.[User]
--ADD CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY (UserID) REFERENCES AMS.AMS_User(UserID);

 go;
 
CREATE TABLE AMS.Account (
    AccountID BIGINT NOT NULL IDENTITY(1,1),
    AccountNo INT NOT NULL,
    IsSaving BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    CreatedDate DATETIME NOT NULL
);


ALTER TABLE AMS.Account
ADD CONSTRAINT [PK_AMS_Account_AccountID]  PRIMARY KEY  (AccountID);

ALTER TABLE AMS.[Account]
ADD CONSTRAINT DF_AMS_Account_Created DEFAULT GETDATE() FOR CreatedDate;

go;
 
 
CREATE TABLE AMS.AccountTransaction (
    AccountTransactionID BIGINT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
    Amount DECIMAL(10,6) NOT NULL,
    IsDebit BIT NOT NULL,
    CreatedBy VARCHAR(250) NOT NULL,
    Created DATETIME NOT NULL
);

alter table AMS.AccountTransaction alter column AccountID BIGINT NOT NULL

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT PK_AMS_AccountTransaction_AccountTransactionID PRIMARY KEY (AccountTransactionID);

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT DF_AMS_AccountTransaction_Created DEFAULT GETDATE() FOR Created;

ALTER TABLE AMS.AccountTransaction
ADD CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY (AccountID) REFERENCES AMS.Account(AccountID);

go;

CREATE TABLE AMS.UserAccountMapping (
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

go;

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

INSERT INTO AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) VALUES ('SHRESTH GAURAV','2001-08-09','2025-04-03',5000.00,123484,748833804,'admin')
    
INSERT INTO AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) 
  VALUES
('SHREYASH RAJPUT','2001-03-12','2025-03-12',4890.00,138920,969344207,'admin'),
('NITESH RAJ','1924-03-23','2025-04-03',6000.00,12345,987609212,'admin');
SELECT * FROM AMS.[User];
INSERT INTO AMS.Account(AccountNo,IsSaving,CreatedBy)
  VALUES
  (138920,1,'admin'),
  (138334,0,'admin');

  sp_help'AMS.Account';
  SELECT * FROM AMS.Account;

  
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


  INSERT INTO AMS.UserAccountMapping(UserID,AccountID,CreatedBy)
   VALUES
   (2,1,'admin'),
   (3,2,'admin');
    SELECT * FROM AMS.UserAccountMapping;

	sp_help 'AMS.UserAccountMapping';
	
	INSERT INTO AMS.AccountTransaction(AccountID,Amount,IsDebit,CreatedBy)
	 VALUES
	 (1,4874,1,'admin'),
	  (2,6000,0,'admin');

	  SP_help 'AMS.AccountTransaction';

   INSERT INTO AMS.Address(UserID,AddressDetail,CreatedBy)
   VALUES
   (2,'Delhi','admin'),
   (3,'Pune','admin');

   SP_help 'AMS.Address';

   CREATE PROCEDURE AMS.PROC_USER_INSERT
     @UserName nvarchar(250),
	 @DOB datetime,
	 @DOJ datetime,
	 @Balance decimal(10,6),
	 @AccountNo int,
	 @MobileNo int,
	 @AddressDetail nvarchar(max),
	 @CreatedBy Varchar(250)

	 as begin
	   declare @UserId Bigint;
	   insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
	   (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

	   set @UserId = SCOPE_IDENTITY()

	   insert into AMS.[Address](UserID,AddressDetail,CreatedBy)
	   values (@UserId,@AddressDetail,@CreatedBy)
	   end

	   EXEC AMS.PROC_USER_INSERT 'TEST1','2020-11-23', '2025-04-12',5000.00,3478921,809759213,'TEST_USER','TEST_ADDRESS_1';

	   SELECT * FROM AMS.[USER];
	   SELECT * FROM AMS.[Address];

	   CREATE PROCEDURE AMS.PROC_MainUser_INSERT
	   @UserName nvarchar(250),
	   @DOB datetime,
	   @DOJ datetime,
	   @Balance decimal(10,6),
	   @AccountNo int,
	   @MobileNo int,
	   @CreatedBy varchar(250)='defaultuser'

	   as begin
       insert into AMS.[USER](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
	   (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

	   end

----------------------------
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

exec AMS.Proc_UserAndAll_Insert 'Shresth', '2001-08-09', '2022-06-13', 3000.0, 12675678, 92754321, 'bgherb', 1, 8000.0, 0

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.Account;
SELECT * FROM AMS.UserAccountMapping;
SELECT * FROM AMS.AccountTransaction;
