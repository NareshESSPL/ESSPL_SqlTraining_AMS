create database Bank_System;
use Bank_System;

create table [User]
(
  UserID BigInt Identity Not Null primary key,
  UserName Nvarchar(250) Not Null,
  DOB DateTime Not Null,
  DOJ DateTime Not Null,
  Balance Decimal(10,6),
  MobileNo Int Not Null,
  CreatedBy Varchar(250)Not Null,
  CreatedDate DateTime Not Null default getdate(), 
);


select * from [User];

create table [Account_New]
(
  AccountID BigInt Not Null primary key,
  AccountNo Int Not Null,
  IsSaving bit Not Null,
  CreatedBy Varchar(250) Not Null,
  CreateDate Datetime Not Null default getdate(),
  );
  
create table [UserAccMapping]
(
  UserAccountMapping BigInt Not Null primary key,
  UserID BigInt Not Null,
  AccountID BigInt Not Null,
  CreatedBy Varchar(250) Not Null,
  CreatedDate DateTime Not Null default getdate(),
  constraint [fk_User_ID]
  foreign key (UserID)
  references [User](UserID)
  );

create table [Address]
(
  AddressID BigInt Not Null,
  UserID BigInt Not Null,
  Address Nvarchar(250) Not Null,
  CreatedBy Varchar(250) Not Null,
  CreateDate Datetime Not Null default getdate(),
  primary key(AddressID),
  constraint [Fk_Add_User_ID]
  foreign key (UserID) 
  references [User] (UserID)
);
select * from [Address];
create table [ Acctransaction]
(
 AccountTransaction BigInt Not Null,
 Amount Decimal(10,6) Not Null primary key,
 IsDebit Bit Not Null,
 CreatedBy Varchar(250) Not Null,
 CreatedDate Datetime Not Null default getdate(),

);

dbcc checkident('User',reseed,0);
go
dbcc checkident('Account_New',reseed,0);
go
dbcc checkident('Address',reseed,0);
go
dbcc checkident('UserAccMapping',reseed,0);
go
dbcc checkident('Acctransaction',reseed,0);
go;

---------------
create procedure Proc_All_Table
 @UserName	nvarchar(250),
 @DOB	datetime,
 @DOJ	datetime,
 @Balance	decimal(10, 6),
 @AccountNo	int,
 @MobileNo	int,
 @Address nvarchar(max),
 @IsSaving bit,
 @Amount decimal(20,2),
 @IsDebit bit,
 @CreatedBy	varchar(250) = 'defaultuser'

as begin

   declare @UserID bigint
   declare @AccountID bigint

   insert into [User] (UserName, DOB, DOJ, Balance, MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @AccountNo, @MobileNo, @CreatedBy)

   set @UserId = scope_identity()
   set @AccountID =scope_identity()

   insert into [Account_New](AccountNo, IsSaving, CreatedBy)
   VALUES(@AccountNo, @IsSaving, @CreatedBy)

   insert into [Address](UserID,Address,CreatedBy) 
   values (@UserId,@Address, @CreatedBy)

   insert into [UserAccMapping](UserID, AccountID, CreatedBy)
   values(@UserID, @AccountID, @CreatedBy)

   Insert into [ Acctransaction]( Amount, IsDebit, CreatedBy)
   values( @Amount, @IsDebit, @CreatedBy)
end

exec Proc_All_Table 'mina', '2000-12-25', '2020-08-13', '2022-01-19', 12345, 8765, 'omm', 1, 5000, 1
exec Proc_All_Table 'rainy', '2012-01-2', '2018-09-13', '2019-01-15', 12345, 8765, 'riya', 1, 5000, 1
exec Proc_All_Table 'umaa', '2002-09-5', '2009-07-13', '2021-07-13', 12345, 8765, 'ashu', 1, 5000, 1
exec Proc_All_Table 'mita', '2002-11-14', '2005-06-13', '2002-08-17', 12345, 8765, 'preeti', 1, 5000, 1
exec Proc_All_Table 'rita', '2000-12-4', '2003-05-13', '2004-09-11', 12345, 8765, 'asish', 1, 5000, 1

SELECT * FROM [User];
SELECT * FROM [Address];
SELECT * FROM [Account];
SELECT * FROM [UserAccMapping];
SELECT * FROM [Acctransaction];
