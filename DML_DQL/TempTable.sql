/* find the account for each user having more than avg balance */
/*
    OPTION 1
*/
--drop table #temp_Account as it remain active in the session
IF OBJECT_ID('tempdb..#temp_Account') IS NOT NULL
DROP TABLE #temp_Account;

select U.UserID,U.UserName,U.Balance,A.AccountID INTO #temp_Account from
	 
AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

join AMS.[Account] A on M.AccountId = A.AccountID


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
)

insert into #temp_account2

select U.UserID,U.UserName,U.Balance,A.AccountID from
	 
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

left join AMS.[Account] A on M.AccountId = A.AccountID

where U.UserID > 70

select * from #temp_Account2

insert into AMS.[User](username,DOB,DOJ,Balance,AccountNo,MobileNo,CreatedBy)
	values('Suresh','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash'),
	('Mukesj','2009-09-24','2009-10-24',8999,688768988,986114149,'Vikash')

select U.UserID,U.UserName,U.Balance,A.AccountID from
	 
AMS.[User] U left Join AMS.[UserAccountMapping] M on U.UserID=M.UserID

left join AMS.[Account] A on M.AccountId = A.AccountID

where U.UserID > 70

