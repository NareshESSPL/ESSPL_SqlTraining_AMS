Create database AccountManagementSystem1
go

use AccountManagementSystem1
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

insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
VALUES 
('BITTU KUMAR','1994-02-23','2025-03-12',5000.00,123484,994937238,'admin')


insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
VALUES 
('HEMANT KUMAR','2002-08-19','2025-03-12',4890.00,138920,996578392,'admin'),
('NITISH KUMAR','1932-03-23','2025-03-02',6000.00,138334,993928372,'admin');

select * from AMS.[User];
insert into AMS.Account (AccountNo,IsSaving,CreatedBy)
VALUES
(138920,1,'admin'),
(138334,0,'admin');

sp_help'AMS.Account';
select * from AMS.Account;

insert into AMS.UserAccountMapping( UserID,AccountID ,CreatedBy)
VALUES
(2,1,'admin'),
(3,2,'admin');

select * from AMS.UserAccountMapping;

sp_help'AMS.UserAccountMapping';

insert into AMS.AccountTransaction(AccountID, Amount,IsDebit, CreatedBy)
VALUES
(1,4890,1,'admin'),
(2,6000,0,'admin');

select * from AMS.AccountTransaction;

/*insert into AMS.Address(AddressID,UserID,AddressDetail,CreatedBy)
VALUES
(

)*/

CREATE procedure AMS.PROC_USER_AND_ADDRESS_INSERT
   @UserName NVarchar(250),
   @DOB DateTime,
   @DOJ DateTime,
   @Balance Decimal(10,6),
   @AccountNo Int,
   @MobileNo Int,
   @AddressDetail NVARCHAR(MAX),
   @CreatedBy Varchar(250) = 'defaultuser'
as begin
   declare @UserId  Bigint;
   insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy) values
   (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy)

   set @UserId = scope_identity();
   insert into AMS.[Address](UserId,AddressDetail,CreatedBy)
   Values(@UserId, @AddressDetail, @CreatedBy)
end

EXEC AMS.PROC_USER_AND_ADDRESS_INSERT 'TEST1','2020-11-23','2025-04-12',5000.00,348373,993487321,'TEST_USER','TEST_ADDRESS_1';

SELECT * FROM AMS.[USER];
SELECT * FROM AMS.[Address];

alter procedure AMS.PROC_USER_AND_ADDRESS_INSERT
   @UserName NVarchar(250),
   @DOB DateTime,
   @DOJ DateTime,
   @Balance Decimal(10,6),
   @AccountNo Int,
   @MobileNo Int,
   @AddressDetail NVARCHAR(MAX),
   @IsSaving BIT,
   @Amount  DECIMAL(10,6),
   @IsDebit BIT,
   @CreatedBy Varchar(250) = 'defaultuser'

as begin
   
   insert into AMS.[User](UserName,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
   values (@UserName,@DOB,@DOJ,@Balance,@AccountNo,@MobileNo,@CreatedBy);

   declare @userid Bigint;
   
   SET @userid = SCOPE_IDENTITY();

   insert into AMS.[Address](UserID,AddressDetail,CreatedBy) values(@userid,@AddressDetail,@CreatedBy);

   insert into AMS.[Account](AccountNo ,IsSaving ,CreatedBy)values(@AccountNo,@IsSaving,@CreatedBy);

   declare @accountid BIGINT;
  set @accountid = SCOPE_IDENTITY();

   insert into AMS.[UserAccountMapping]( UserID ,
    AccountID,CreatedBy)values(@userid ,
    @accountid,@CreatedBy);

	insert into AMS.[AccountTransaction]( AccountID , Amount ,IsDebit , CreatedBy) values(@accountid,@Amount,@IsDebit,@CreatedBy);
END;

exec AMS.PROC_USER_AND_ADDRESS_INSERT 'adarsh','2024-01-23','2025-03-12',5000.00,123456,987654321,'Mumbai',
1,2000.00,0,'admin';

select * from AMS.[User];
select * from AMS.Address;
select * from AMS.Account;
select * from AMS.UserAccountMapping;
select * from AMS.AccountTransaction;

