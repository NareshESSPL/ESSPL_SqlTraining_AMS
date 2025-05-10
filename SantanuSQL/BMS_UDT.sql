/* Find the account for each user having more than avg balance */
/*
    OPTION 1
*/
--Drop table #temp_Account as it remain active in the session
IF OBJECT_ID('tempdb..#temp_Account') IS NOT NULL
DROP TABLE #temp_Account;

select U.UserID,U.UserName,U.Balance,A.AccountID INTO #temp_Account from
	 
BMS.[User] U Join BMS.[UserAccountMapping] M on U.UserID=M.UserID

join BMS.[Account] A on M.AccountId = A.AccountID


/*
    OPTION 2
*/

-- Creating an Temp Table
IF OBJECT_ID('tempdb..#temp_account2') IS NOT NULL
DROP TABLE #temp_account2;

Create table #temp_account2
(
  UserID BIGINT primary key, -- Defining constraint is optional
  UserName Varchar(250),
  Balance decimal(10,6),
  AccountID int
)

--Inserting into temp table variable
Insert Into #temp_account2

Select U.UserID,U.UserName,U.Balance,A.AccountID From
	 
BMS.[User] U Left Join BMS.[UserAccountMapping] M ON U.UserID=M.UserID
Left Join BMS.[Account] A ON M.AccountId = A.AccountID

Where U.UserID > 70

Select * From #temp_Account2

Insert Into BMS.[User](username,DOB,DOJ,Balance,MobileNo,CreatedBy)
	Values('Suresh','2009-09-24','2009-10-24',8999,986114149,'Vikash'),
	('Mukesj','2009-09-24','2009-10-24',8999,986114149,'Vikash')

Select U.UserID,U.UserName,U.Balance,A.AccountID FROM
	 
BMS.[User] U Left Join BMS.[UserAccountMapping] M ON U.UserID=M.UserID

Left Join BMS.[Account] A ON M.AccountId = A.AccountID

Where U.UserID > 4

DROP Table #temp_Account2


-- CREATING AN TABLE VARIABLE
Declare @tbl_account as table
(
  UserID BIGINT Primary Key, -- Defining constraint is optional
  UserName Varchar(250),
  Balance Decimal(10,6),
  AccountID Int
)

Insert Into BMS.[User](username,DOB,DOJ,Balance,MobileNo,CreatedBy)
	Values('Naman','2009-09-24','2009-10-24',8999,986114149,'Ojha'),
	('Pragyan','2009-09-24','2009-10-24',8999,986114149,'Ojha');


Select U.UserID,U.UserName,U.Balance,A.AccountID FROM
	 
BMS.[User] U left Join BMS.[UserAccountMapping] M ON U.UserID=M.UserID

Left Join BMS.[Account] A ON M.AccountId = A.AccountID

Where U.UserID > 4 

--Creating an view
Create View BMS.VW_Account AS
Select U.UserID,U.UserName,U.Balance,A.AccountID FROM
	 
BMS.[User] U Left Join BMS.[UserAccountMapping] M ON U.UserID=M.UserID

Left join BMS.[Account] A ON M.AccountId = A.AccountID

Where U.UserID > 4

Select * From BMS.VW_Account VA Join BMS.[Address] A ON A.UserId = VA.UserID


--User Defined Types 

Create Type BMS.PhoneNo From Varchar(10)

Create Table STG_User
(
UserId Int identity(1,1) Primary Key,
Username NVarchar(100),
PhoneNo BMS.PhoneNo
)

Insert Into STG_User Values ('Anne', 123458)

Create Type BMS.[BasicUser] as table
(
UserID Int Identity(1,1) Primary Key),
Username NVarchar(100),
PhoneNo BMS.PhoneNo
);
GO

--Drop type BMS.[BasicUser]

--ASSIGNMENT 04
Create type UserAccountType as table
(
UserID INT,
AccountNo BIGINT
);

Create Procedure Add_User_Account
@UserAccounts UserAccountType READONLY   
As Begin Select * from @UserAccountType End                                                                                                           

Declare @UserAccounts UserAccountType;
Insert into @UserAccounts(UserID, Accountno)
Values               
(1,12345),
(2,67890),
(3,54321);

Exec @AddUserAccounts @UserAccounts;








