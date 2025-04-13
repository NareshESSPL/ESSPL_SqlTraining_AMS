CREATE DATABASE Preeti;
go
USE Preeti;
go
CREATE TABLE [User](
UserID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserName NVARCHAR(250) NOT NULL,
DOB DATETIME NOT NULL,
DOJ DATETIME NOT NULL,
Balance DECIMAL(10,6) NOT NULL,
MobileNo INT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go
SELECT * FROM [User];

DBCC CHECKIDENT('[User]',reseed,0);

-------------------------------------------

CREATE TABLE [Account](
AccountID BIGINT IDENTITY(1,1) NOT NULL,
AccountNo INT NOT NULL,
IsSaving BIT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go

DBCC CHECKIDENT('[Account]',reseed,0);
SELECT * FROM [Account];

ALTER TABLE [Account]
ADD CONSTRAINT pk_AccountId PRIMARY KEY(AccountId); 
go

CREATE TABLE [UserAccountMapping](
UserAccountMapping BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserID BIGINT NOT NULL,
AccountId BIGINT NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (UserID) REFERENCES [User](UserID)
);
go

DBCC CHECKIDENT('[UserAccountMapping]',reseed,0);

SELECT * FROM [UserAccountMapping];

CREATE TABLE [Address](
AddressID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
UserId BIGINT NOT NULL,
Address NVARCHAR(MAX) NOT NULL,
CreatedBY VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (UserId) REFERENCES [User](UserID)
);
go
DBCC CHECKIDENT('[Address]',reseed,0);
SELECT * FROM [Address];

CREATE TABLE [AccountTransaction](
AccountTransaction BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
Amount Decimal(10,6) NOT NULL,
IsDebit Bit NOT NULL,
CreatedBy VARCHAR(250) NOT NULL,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
go
DBCC CHECKIDENT('[AccountTransaction]',reseed,0);

SELECT * FROM [AccountTransaction];
go

------------------------------------------
-------------------------------------------
Create Procedure Proc_All_Table
@UserName nvarchar(250),
@DOB	datetime,
@DOJ	datetime,
@Balance	decimal(10, 6),
@AccountNo	int,
@IsSaving bit,
@MobileNo	int,
@Address nvarchar(max),
@Amount Decimal(10,6),
@IsDebit bit,
@CreatedBy	varchar(250) ='defaultUser'

as begin
    
   declare @UserID bigint
   declare @AccountID bigint

   insert into [User] (UserName, DOB, DOJ, Balance,MobileNo, CreatedBy) values
   (@UserName, @DOB, @DOJ, @Balance, @MobileNo, @CreatedBy)

   set @UserID = scope_identity()
     set @AccountID = scope_identity()

	insert into [Account] (AccountNo,IsSaving,CreatedBy)
	Values(@AccountNo,@IsSaving,@CreatedBy)

	insert into [UserAccountMapping] (UserID,AccountID,CreatedBy)
	Values (@UserID,@AccountID,@CreatedBy)


   insert into [Address](UserId,Address,CreatedBy) 
   values (@UserId, @Address, @CreatedBy)

   insert into [AccountTransaction] (Amount,IsDebit,CreatedBy)
   Values (@Amount,@IsDebit,@CreatedBy)
end

EXEC Proc_All_Table 'testing', '2025-02-02', '2025-02-02', 500, 123,1, 9876, 'test address',600,1
EXEC Proc_All_Table 'Preeti', '2003-04-03', '2024-03-09', 700, 456,1, 2876, 'Angul',700,0
EXEC Proc_All_Table 'Ankita', '2003-08-03', '2025-03-09', 680, 336,1, 2756, 'Koraput',800,0
EXEC Proc_All_Table 'Shrestha','2002-02-27', '2025-03-09',580, 256,0, 2656, 'cuttack',640,0
EXEC Proc_All_Table 'Rati', '2003-12-12', '2025-03-09', 690, 4516,1, 3756, 'Cuttack',870,0

SELECT * FROM [User];
SELECT * FROM [Account];
SELECT * FROM [UserAccountMapping];
SELECT * FROM [Address];
SELECT * FROM [AccountTransaction];