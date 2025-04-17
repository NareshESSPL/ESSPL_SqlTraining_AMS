USE AccountManagementSystem;
GO

CREATE function AMS.[GetFinalBill]
(
 @Invoice float
)
 returns float
 AS
 BEGIN
  return @Invoice * 0.18 + @Invoice * 0.02
 END

 PRINT AMS.[GetFinalBill] (100)

 --------------------------------
 -- Altering the Function
 ALTER function AMS.[GetFinalBill]
(
 @Invoice float
)
 returns float
 AS
 BEGIN
  return @Invoice * 0.18 + @Invoice * 0.02 + 10

 END

 PRINT AMS.[GetFInalBill](200)
 ----------------------------------------

 /*
 Class Exercise
 */
-- Funtion
create function func_testing (@id INT)
returns @temp table (id int)
as
begin
 insert into @temp values (1);
 insert into @temp values (2);
 
 return
end


select * from dbo.func_testing(1);

use AccountManagementSystem;
go
create schema test;
go;


Select * into test.[User] from AMS.[User];
Select * into test.[Account] from AMS.[Account];
Select * into test.[Address] from AMS.[Address];
Select * into test.[UserAccountMapping] from AMS.[UserAccountMapping]
Select * into test.[AccountTransaction] from AMS.[AccountTransaction];
go

sp_help 'test.[user]'
sp_help 'test.[account]'
sp_help 'test.[address]'
sp_help 'test.[accounttransaction]'
sp_help 'test.[USERaccountmapping]'
go

create proc AMS.TestSP
as
begin
  truncate table AMS.AccountTransaction;
  truncate table AMS.UserAccountMapping;
  
  delete from AMS.Account;
  DBCC CHECKIDENT ('AMS.Account', RESEED, 0)
  
  truncate table AMS.[Address]
  
  delete from AMS.[User]
  DBCC CHECKIDENT ('AMS.[User]', RESEED, 0)


  declare 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month, 1, cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate(),
	@AddressDetail nvarchar(max) = 'TestAddress';

  declare @count int = 0;
  
  WHILE @count < =1000
  BEGIN
  --Do not delete
  select @count = @count + 1

  -- Scope Identity
  	declare @Userid BIGINT, @Accountid BIGINT;

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [Balance], [AccountNo], [MobileNo], [CreatedBy], [Created])
  values(@UserName + cast(@count as varchar),
         dateadd(month,1, @DOB), 
		 dateadd(day, -1, @DOJ),
		 @Balance + @count,
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 );
	set @Userid = SCOPE_IDENTITY();

	insert into AMS.[Address] ([Userid], [AddressDetail], [CreatedBy], [Created])
  values(
         @Userid,
		 @AddressDetail,
		 @CreatedBy,
		 @Created
		 );
  END

 select * from AMS.[User]
 select * from AMS.[Address]

end

exec test.TestSP



USE [master]
GO
/****** Object:  Database [Testing]    Script Date: 14-04-2025 11:33:17 ******/
CREATE DATABASE [Testing]
go

USE [Testing]
GO

/****** Object:  Schema [AMS]    Script Date: 14-04-2025 11:33:17 ******/
CREATE SCHEMA [AMS]
GO
/****** Object:  UserDefinedDataType [AMS].[PhoneNo]    Script Date: 14-04-2025 11:33:17 ******/
CREATE TYPE [AMS].[PhoneNo] FROM [varchar](10) NULL
GO
/****** Object:  UserDefinedDataType [dbo].[PhoneNo]    Script Date: 14-04-2025 11:33:17 ******/
CREATE TYPE [dbo].[PhoneNo] FROM [varchar](10) NULL
GO
/****** Object:  UserDefinedTableType [AMS].[BasicUser]    Script Date: 14-04-2025 11:33:17 ******/
CREATE TYPE [AMS].[BasicUser] AS TABLE(
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](100) NULL,
	[phoneNo] [AMS].[PhoneNo] NULL,
	PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedTableType [AMS].[udt_Account]    Script Date: 14-04-2025 11:33:17 ******/
CREATE TYPE [AMS].[udt_Account] AS TABLE(
	[AccountID] [bigint] NULL,
	[AccountNo] [bigint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[udt_testing]    Script Date: 14-04-2025 11:33:17 ******/
CREATE TYPE [dbo].[udt_testing] AS TABLE(
	[id] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [AMS].[GetFinalBill]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [AMS].[GetFinalBill] 
(
  @Invoice float
)
returns float
as
begin

  return @Invoice * 0.18 + @Invoice * 0.02 + 10

end
GO
/****** Object:  UserDefinedFunction [dbo].[func_testing]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[func_testing] 
(
 @id int
)
returns @temp table
(
 id int
)
as
begin
 insert into @temp values (1)
 
 insert into @temp values (1)
 return
end
GO
/****** Object:  Table [AMS].[User]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[User](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](250) NOT NULL,
	[DOB] [datetime] NOT NULL,
	[DOJ] [datetime] NOT NULL,
	[AccountNo] [int] NOT NULL,
	[MobileNo] [int] NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_AMS_User_UserID] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AMS].[Account]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[Account](
	[AccountID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountNo] [int] NOT NULL,
	[IsSaving] [bit] NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
	[Balance] [decimal](10, 6) NULL,
 CONSTRAINT [PK_AMS_Account_AccountID] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AMS].[UserAccountMapping]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[UserAccountMapping](
	[UserAccountMappingID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[AccountID] [bigint] NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_AMS_UserAccountMappingID_UserAccountMappingID] PRIMARY KEY CLUSTERED 
(
	[UserAccountMappingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [AMS].[vw_account]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [AMS].[vw_account] as
select U.UserID,U.UserName, A.AccountID from
	 
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

left join AMS.[Account] A on M.AccountId = A.AccountID

where U.UserID > 70
GO
/****** Object:  Table [AMS].[AccountTransaction]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[AccountTransaction](
	[AccountTransactionID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountID] [bigint] NOT NULL,
	[Amount] [decimal](10, 6) NOT NULL,
	[IsDebit] [bit] NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_AMS_AccountTransaction_AccountTransactionID] PRIMARY KEY CLUSTERED 
(
	[AccountTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AMS].[Address]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[Address](
	[AddressID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NOT NULL,
	[AddressDetail] [nvarchar](max) NOT NULL,
	[CreatedBy] [varchar](250) NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_AMS_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AMS].[CreditCard]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AMS].[CreditCard](
	[CreditCard] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NULL,
	[MobileNo] [varchar](10) NULL,
	[CardNo] [varchar](16) NULL,
PRIMARY KEY CLUSTERED 
(
	[CreditCard] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CreditCardOffer]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CreditCardOffer](
	[CreditCardOfferID] [bigint] IDENTITY(1,1) NOT NULL,
	[CreditCardID] [bigint] NULL,
	[Offer] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[CreditCardOfferID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [bigint] NOT NULL,
	[Grade] [char](1) NULL,
	[Salary] [decimal](10, 6) NULL,
	[Name] [varchar](250) NULL,
	[DOJ] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IdentTets]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IdentTets](
	[name] [varchar](250) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[STG_User]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STG_User](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](100) NULL,
	[phoneNo] [AMS].[PhoneNo] NULL,
PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AMS].[Account] ADD  CONSTRAINT [DF_AMS_Account_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [AMS].[AccountTransaction] ADD  CONSTRAINT [DF_AMS_AccountTransaction_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [AMS].[Address] ADD  CONSTRAINT [DF_AMS_Address_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [AMS].[User] ADD  CONSTRAINT [DF_AMS_User_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [AMS].[UserAccountMapping] ADD  CONSTRAINT [DF_AMS_UserAccountMappingID_Created]  DEFAULT (getdate()) FOR [Created]
GO
ALTER TABLE [AMS].[AccountTransaction]  WITH CHECK ADD  CONSTRAINT [FK_AMS_AccountTransaction_AccountID] FOREIGN KEY([AccountID])
REFERENCES [AMS].[Account] ([AccountID])
GO
ALTER TABLE [AMS].[AccountTransaction] CHECK CONSTRAINT [FK_AMS_AccountTransaction_AccountID]
GO
ALTER TABLE [AMS].[Address]  WITH CHECK ADD  CONSTRAINT [FK_AMS_Address_UserID] FOREIGN KEY([UserID])
REFERENCES [AMS].[User] ([UserID])
GO
ALTER TABLE [AMS].[Address] CHECK CONSTRAINT [FK_AMS_Address_UserID]
GO
ALTER TABLE [AMS].[UserAccountMapping]  WITH CHECK ADD  CONSTRAINT [FK_AMS_UserAccountMapping_AccountID] FOREIGN KEY([AccountID])
REFERENCES [AMS].[Account] ([AccountID])
GO
ALTER TABLE [AMS].[UserAccountMapping] CHECK CONSTRAINT [FK_AMS_UserAccountMapping_AccountID]
GO
ALTER TABLE [AMS].[UserAccountMapping]  WITH CHECK ADD  CONSTRAINT [FK_AMS_UserAccountMapping_UserID] FOREIGN KEY([UserID])
REFERENCES [AMS].[User] ([UserID])
GO
ALTER TABLE [AMS].[UserAccountMapping] CHECK CONSTRAINT [FK_AMS_UserAccountMapping_UserID]
GO
/****** Object:  StoredProcedure [AMS].[Proc_User_Insert]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [AMS].[Proc_User_Insert]  
 @UserName nvarchar(250),  
 @DOB datetime,  
 @DOJ datetime,    
 @AccountNo int,  
 @MobileNo int,  
 @CreatedBy varchar(250) = 'defaultuser'  
as begin  
  insert into AMS.[User] (UserName, DOB, DOJ, AccountNo, MobileNo, CreatedBy) values  
  (@UserName, @DOB, @DOJ,  @AccountNo, @MobileNo, @CreatedBy)  
end  
GO
/****** Object:  StoredProcedure [AMS].[Proc_UserAndAddress_Insert]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [AMS].[Proc_UserAndAddress_Insert]  
 @UserName nvarchar(250),  
 @DOB datetime,  
 @DOJ datetime,  
 @Balance decimal(10, 6),  
 @AccountNo int,  
 @MobileNo int,  
 @AddressDetail nvarchar(max),  
 @CreatedBy varchar(250) = 'defaultuser'  
as begin  
      
   declare @UserId bigint  
  
   insert into AMS.[User] (UserName, DOB, DOJ, AccountNo, MobileNo, CreatedBy) values  
   (@UserName, @DOB, @DOJ, @AccountNo, @MobileNo, @CreatedBy)  
  
   set @UserId = scope_identity()  
  
   insert into AMS.[Address](UserId, AddressDetail, CreatedBy)   
   values (@UserId, @AddressDetail, @CreatedBy)  
  
end
GO
/****** Object:  StoredProcedure [AMS].[test_udt]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [AMS].[test_udt]
as
begin
  declare @buser as AMS.BasicUser
  insert into @buser values ('test2', 987654322),
                            ('test2', 987654322)

  select * from @buser
end
GO
/****** Object:  StoredProcedure [AMS].[test_udt2]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [AMS].[test_udt2]
 @acountList AMS.udt_Account readonly
as
begin
  select * from @acountList
   --print 'hello'
end
GO
/****** Object:  StoredProcedure [AMS].[TestSP]    Script Date: 14-04-2025 11:33:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [AMS].[TestSP]
 @MaxCount BIGINT =1000
as
begin
  truncate table AMS.AccountTransaction
  
  truncate table AMS.UserAccountMapping
  
  delete from AMS.Account
  DBCC CHECKIDENT ('AMS.Account', RESEED, 0)
  
  truncate table AMS.[Address]
  
  delete from AMS.[User]
  DBCC CHECKIDENT ('AMS.[User]', RESEED, 0)


  declare 
    @UserName [nvarchar](250) = 'test',
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate(),
	@IsSaving BIT = 1,
	@Address NVARCHAR(MAX) = 'test add',
	@userID BIGINT,
	@AccountID BIGINT,
	@Amount [decimal](10, 6) = 10,
	@IsDebit BIT = 0;

  declare @count int = 0;
  
  WHILE @count < = @MaxCount
  BEGIN
  --Do not delete
  select @count = @count + 1

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [AccountNo], [MobileNo],[CreatedBy],[Created])
  values(
         @UserName + cast(@count as varchar),
         dateadd(month,1, @DOB), 
		 dateadd(day, -1, @DOJ),
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 )
       
	   SET @UserID = SCOPE_IDENTITY();

        -- 2. Insert into Account_New
        INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
        VALUES (@AccountNo, @IsSaving, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- 3. Insert into Address
        INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
        VALUES (@UserID, @Address, @CreatedBy);

        -- 5. Insert into UserAccountMapping
        INSERT INTO AMS.[UserAccountMapping](UserID, AccountID, CreatedBy)
        VALUES (@UserID, @AccountID, @CreatedBy);

        -- 4. Insert into Acctransaction
        INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
        VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy);
		
  END

   select * from AMS.[User]   
   select * from AMS.[Address]
   select * from AMS.[Account]
   
   select * from AMS.[UserAccountMapping]
   
   select * from AMS.[AccountTransaction]

end
GO
USE [master]
GO
ALTER DATABASE [Testing] SET  READ_WRITE 
GO



use testing
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [AMS].[TestSP]
 @MaxCount BIGINT =1000
as
begin
  truncate table AMS.AccountTransaction
  
  truncate table AMS.UserAccountMapping
  
  delete from AMS.Account
  DBCC CHECKIDENT ('AMS.Account', RESEED, 0)
  
  truncate table AMS.[Address]
  
  delete from AMS.[User]
  DBCC CHECKIDENT ('AMS.[User]', RESEED, 0)


  declare 
    @TempUserName [nvarchar](250) = 'test',
	@UserName [nvarchar](250),
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date)),
	@DOJ [datetime] = getdate(),
	@Balance [decimal](10, 6) = 1000,
	@AccountNo [int] = 10001,
	@MobileNo [int] = 12345,
	@CreatedBy [varchar](250) = 'testdata',
	@Created [datetime] = getdate(),
	@IsSaving BIT = 1,
	@Address NVARCHAR(MAX) = 'test add',
	@userID BIGINT,
	@AccountID BIGINT,
	@Amount [decimal](10, 6) = 10,
	@IsDebit BIT = 0;

  declare @count int = 0;
  
  WHILE @count < = @MaxCount
  BEGIN
  --Do not delete
  select @count = @count + 1

  set @DOB = dateadd(month,1, @DOB)
  set @UserName = @TempUserName + cast(@count as varchar)
  set @DOJ = dateadd(day, -1, @DOJ)
  set @AccountNo = @AccountNo + @count
  set @MobileNo = @MobileNo + @count

  insert into AMS.[User] ([UserName], [DOB], [DOJ], [AccountNo], [MobileNo],[CreatedBy],[Created])
  values(
         @UserName + cast(@count as varchar),
         @DOB, 
		 dateadd(day, -1, @DOJ),
		 @AccountNo + @count,
		 @MobileNo + @count,
		 @CreatedBy,
		 @Created
		 )
       
	   SET @UserID = SCOPE_IDENTITY();

        -- 2. Insert into Account_New
        INSERT INTO AMS.[Account](AccountNo, IsSaving, CreatedBy)
        VALUES (@AccountNo, @IsSaving, @CreatedBy);

        SET @AccountID = SCOPE_IDENTITY();

        -- 3. Insert into Address
        INSERT INTO AMS.[Address](UserID, AddressDetail, CreatedBy)
        VALUES (@UserID, @Address, @CreatedBy);

        -- 5. Insert into UserAccountMapping
        INSERT INTO AMS.[UserAccountMapping](UserID, AccountID, CreatedBy)
        VALUES (@UserID, @AccountID, @CreatedBy);

        -- 4. Insert into Acctransaction
        INSERT INTO AMS.AccountTransaction(AccountID, Amount, IsDebit, CreatedBy)
        VALUES (@AccountID, @Amount, @IsDebit, @CreatedBy);
		
  END

   select * from AMS.[User]
   select * from AMS.[Address]
   select * from AMS.[Account]
   select * from AMS.[UserAccountMapping]
   select * from AMS.[AccountTransaction]

end

-- Executing the Stored Procedure
EXEC [AMS].[TestSP]
-----------------------------------------------------------------------
-----------------------------------------------------------------------
-----------------------------------------------------------------------

/*
  Query
*/

select * from ams.[user];

declare 
 @dob [datetime] = dateadd(month, 1, cast('1970-01-01' as Date))

print @dob
----------------------
declare @date datetime

-- to find user id and age
declare 
SELECT
    UserID,
    CASE
        WHEN MONTH(GETDATE()) > MONTH(dob) OR (MONTH(GETDATE()) = MONTH(dob) AND DAY(GETDATE()) >= DAY(dob))
        THEN DATEDIFF(YEAR, dob, GETDATE())
        ELSE DATEDIFF(YEAR, dob, GETDATE()) - 1
    END AS Age
FROM
    AMS.[User];

----------------
SELECT
    UserID,
    CASE
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 10 and 20 THEN 'A'
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 20 and 30 THEN 'B'
        WHEN DATEDIFF(YEAR, dob, GETDATE()) between 30 and 40 THEN 'C'
		WHEN DATEDIFF(YEAR, dob, GETDATE()) > 40 THEN 'D'
        ELSE 'Invalid Age'
    END AS AgeGroup, DOB, DATEDIFF(YEAR, dob, GETDATE()) AS Age
FROM
    AMS.[User]
	order by AgeGroup asc;
GO

----- Using Subquery
select distinct
 case
   when Age > 10 and Age < 20 then 'A'
   when age > 20 and age < 30 then 'B'
   when age > 30 and age < 40 then 'C'
   when age > 40 then 'D'
   else 'Invalid Age' 
end as AgeGroup
from
   (Select userid, DATEDIFF(YEAR, dob, GETDATE()) as Age, dob from ams.[User])
   AS x;
Go
--------------
--Other Way
select userid, dob, 
case
   when DATEDIFF(YEAR, dob, GETDATE()) > 10 and DATEDIFF(YEAR, dob, GETDATE()) < 20 then 'A'
   when DATEDIFF(YEAR, dob, GETDATE()) > 20 and DATEDIFF(YEAR, dob, GETDATE()) < 30 then 'B'
   when DATEDIFF(YEAR, dob, GETDATE()) > 30 and DATEDIFF(YEAR, dob, GETDATE()) < 40 then 'C'
   when DATEDIFF(YEAR, dob, GETDATE()) > 40 then 'D'
   else 'Invalid Age' 
end as AgeGroup
   from ams.[User]
Go
----------------------------------
-- Find the Average Balance

select avg(balance) AverageBalance, AgeGroup from(
select u.userid, u.dob, a.balance, 
case
   when DATEDIFF(YEAR, dob, GETDATE()) > 10 and DATEDIFF(YEAR, dob, GETDATE()) < 20 then 'A'
   when DATEDIFF(YEAR, dob, GETDATE()) > 20 and DATEDIFF(YEAR, dob, GETDATE()) < 30 then 'B'
   when DATEDIFF(YEAR, dob, GETDATE()) > 30 and DATEDIFF(YEAR, dob, GETDATE()) < 40 then 'C'
   when DATEDIFF(YEAR, dob, GETDATE()) > 40 then 'D'
   else 'Invalid Age' 
end AgeGroup
   from ams.[User]  u  
JOIN AMS.[UserAccountMapping] am on u.userid = am.userid
JOIN AMS.[Account] a on am.AccountID = a.AccountID)
as x group by x.AgeGroup;
   
GO