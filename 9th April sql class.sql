use AccountManagementSystem;

create Schema AMS;

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

CREATE TABLE AMS.Account (
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


INSERT INTO AMS.[User] ( UserName, DOB, DOJ, Balance, AccountNo , MobileNo , CreatedBy , Created)
VALUES
('Amit', 06-08-2025, 07-09-2040, 1000, 1009, 1234 , 'Ashis' , 06-08-2029),
('Aditya', 02-10-2004, 07-09-2010, 2000, 1309, 1934 , 'Pravati' , 06-08-2007),
('Shubham', 01-03-2002, 07-09-2008, 1280, 0009, 924 , 'Mukesh' , 06-08-2008);

INSERT INTO AMS.[User] ( UserName, DOB, DOJ, Balance, AccountNo , MobileNo , CreatedBy , Created)
VALUES
('Omm', 2004-03-09, 2008-09-10, 1000, 1009, 1234 , 'Ashis' , 2010-12-09);



INSERT INTO AMS.[User] ( UserName, DOB, DOJ, Balance, AccountNo , MobileNo , CreatedBy , Created)
VALUES
('Pramit','2004-03-09', '2008-09-10', 1000, 1009, 1234 , 'Ashis' , '2010-12-09');

INSERT INTO AMS.[User] ( UserName, DOB, DOJ, Balance, AccountNo , MobileNo , CreatedBy , Created)
VALUES
('Sanimi','2004-03-09', '2008-09-10', 1000, 1009, 1234 , 'Hitesh' , '2010-12-09');

DBCC CHECKIDENT ('AMS.[User]' , RESEED , 11);
go

alter procedure AMS.proc_userAddress_insert
	@UserName nvarchar(250),
	@DOB datetime,
	@DOJ datetime,
	@Balance decimal(10,6),
	@AccountNo int,
	@MobileNo int,
	@CreatedBy varchar(250) ,
	@AddressDetail nvarchar(max),
	@IsSaving BIT,
	@Created datetime,
	@Amount DECIMAL(10,6),
	@IsDebit BIT
as begin
	declare @userId bigint

	INSERT INTO AMS.[User] ( UserName, DOB, DOJ, Balance, AccountNo , MobileNo , CreatedBy , Created)
	VALUES (@UserName,@DOB,@DOJ, @Balance, @AccountNo, @MobileNo , @CreatedBy ,@Created);

	set @userId=SCOPE_IDENTITY()
	insert into AMS.Address(UserID,AddressDetail,CreatedBy)
	values (@userId,@AddressDetail,@CreatedBy)

	insert into AMS.Account(AccountNo,IsSaving,CreatedBy,Created) 
	values (@AccountNo,@IsSaving,@CreatedBy,@Created)

	declare @AccountID BIGINT;

	set @AccountID=SCOPE_IDENTITY();
	
	insert into AMS.UserAccountMapping(UserID,AccountID,CreatedBy,Created) 
	values (@userId,@AccountID,@CreatedBy,@Created)

	insert into AMS.AccountTransaction(AccountID,Amount,IsDebit,CreatedBy,Created) 
	values (@AccountID,@Amount,@IsDebit,@CreatedBy,@Created)
end
go

Exec AMS.proc_userAddress_insert 'Alok','2025-09-08','2025-09-08',129,12,234,'default','BBSR',0,'2025-09-08',23,1;

select * from AMS.Address;
select * from AMS.[User];
select * from AMS.Account;
select * from AMS.UserAccountMapping;
select * from AMS.AccountTransaction;