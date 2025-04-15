/*
Sub String
*/
GO
USE AccountManagementSystem;
GO

--Substring
DECLARE @Name Varchar(100), @Fname Varchar(100), @Lname Varchar(100), @LENgth INT;

SET @Name = 'Suraj Sah';
SET @Fname = SUBSTRING(@Name, 1, CHARINDEX(' ', @Name) - 1);
SET @Length = LEN(@Name);
DECLARE @FnameLENgth INT;
SET @FnameLENgth = LEN(@Fname);

SET @Lname = SUBSTRING(@Name, CHARINDEX(' ', @Name) + 1, LEN(@Name) - CHARINDEX(' ', @Name) + 1);

SELECT @Name FulLname, @LENgth 'Length', @Fname FirstName, @Lname LastName;
SELECT @Fname + ' ' + @Lname AS fULLname;

-- TRIMming string
SET @Name  = '   Suraj Sah   ';
SELECT LEN(TRIM(@Name)), LEN(LTRIM(@Name)), LEN(RTRIM(@Name));


/*
# Ways to fine tune the query(Repeated queries)
- SubcQuery
- CTE(Common Table Expression)-Alternative SubQuery
- Views

# Temp Table
# Local(Only for your session) and Global(Throughout the Database) Temporary table
 - Local: #temp_table
 - Global: ##temp_table

 Note : First check whether temp_table exists or not first. and if it does, drop it and then create again.

*/

/* find the account for each user having more than avg balance */
/*
    OPTION 1
*/
--drop table #temp_Account as it remain active in the session
IF OBJECT_ID('tempdb..#temp_Account') IS NOT NULL
DROP TABLE #temp_Account;

select U.UserID,U.UserName,U.Balance,A.AccountID INTO #temp_Account from
	 
AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

join AMS.[Account] A on M.AccountId = A.AccountID;


select * from #temp_Account;

/*
    OPTION 2
*/

IF OBJECT_ID('tempdb..#temp_account2') IS NOT NULL
DROP TABLE #temp_account2;

Create table #temp_account2
(
  UserID BIGINT primary key, -- Defining constraint is optional
  UserName Varchar(250),
  Balance decimal(10,6),
  AccountID int
);

--Inserting data into temp table
insert into #temp_account2

select U.UserID,U.UserName,U.Balance,A.AccountID from
AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID
 join AMS.[Account] A on M.AccountId = A.AccountID
where U.UserID > 20;


select * from #temp_Account2;

--Inserting data into temp table
insert into AMS.[User](username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values('Suresh','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash'),
	('Mukesj','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash');

select U.UserID,U.UserName,U.Balance,A.AccountID from
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID
left join AMS.[Account] A on M.AccountId = A.AccountID
where U.UserID > 20;

-- Dropping Temp table
DROP TABLE #temp_account2;


/*
# Table Variable
Syntax: @NAME AS TABLE
Use - Stays in tempdb, which is very fast 
*/

declare @table_variable as Table(
  UserID BIGINT primary key, -- Defining constraint is optional
  UserName Varchar(250),
  Balance decimal(10,6),
  AccountID int
);

--Inserting data into the table variable
insert into @table_variable
select U.UserID,U.UserName,U.Balance,A.AccountID from
AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID
 join AMS.[Account] A on M.AccountId = A.AccountID
where U.UserID > 20;

select * from @table_variable;



/*
## VIEWS

- Logical and Physical View
- Maintain abstraction
- Hiding the actual structure
- Views are precompiled so they remains in Schema
*/

CREATE view ams.[vw_account] 
As
select U.UserID,U.UserName,U.Balance,A.AccountID from
AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID
 join AMS.[Account] A on M.AccountId = A.AccountID
where U.UserID > 20;

select * from ams.[vw_account];


-- dummy view
create view ams.[vw_user] 
as
select * from ams.[User];
go

sp_help 'ams.[user]'
sp_help 'ams.[vw_user]'