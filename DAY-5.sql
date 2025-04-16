USE Testing
go

create table AMS.AccountAnalytics
(
 AccountAnalyticsId  bigint identity(1,1),
 UserId bigint,
 UserName	nvarchar(250),
 DOB	datetime,
 DOJ	datetime,
 AccountId bigint,
 AccountNo	int,
 MobileNo	int,
 AddressId bigint,
 AddressDetail nvarchar(max),
 IsSaving bit,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()
 )
 /*
 CREATE proc proc_AccountAnalysis
 as begin 
   
   insert into AMS.AccountAnalysis
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID

   select * from AMS.AccountAnalysis

end

EXEC  AMS.proc_AccountAnalysis;
*/

;WITH cte_AccountAnalaysis
as
(
select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created 
  from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)