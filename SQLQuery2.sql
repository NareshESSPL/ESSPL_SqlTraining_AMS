
create table AMS.AccountAnalytics1(
 AccountAnalyticsId  bigint identity(1,1),
 UserId bigint,
 UserName	nvarchar(250),
 DOB	datetime,
 DOJ	datetime,
 AccountId bigint,
 AccountNo	int,
 MobileNo	bigint,
 AddressId bigint,
 AddressDetail nvarchar(max),
 IsSaving bit,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()
 );

 create proc AMS.[proc_AccountAnalytics1]
 as begin 
   
   insert into AMS.AccountAnalytics1
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID

   select * from [AMS].[AccountAnalytics1]

end

exec AMS.[proc_AccountAnalytics1]





-----------cte-AccountAnalytics----------------
  ;with cte_AccountAnalytics
  as
  ( select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created 
  from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
	 )
	 

--select * from cte_AccountAnalytics--

create table testMergeSource
(
AccountAnalyticsId  bigint identity(1,1),
 UserId bigint,
 UserName	nvarchar(250),
 DOB	datetime,
 DOJ	datetime,
 AccountId bigint,
 AccountNo	int,
 MobileNo	bigint,
 AddressId bigint,
 AddressDetail nvarchar(max),
 IsSaving bit,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()
)
--------------------------------------------------------------------
create table testMergeTarget
(
AccountAnalyticsId  bigint identity(1,1),
 UserId bigint,
 UserName	nvarchar(250),
 DOB	datetime,
 DOJ	datetime,
 AccountId bigint,
 AccountNo	int,
 MobileNo	bigint,
 AddressId bigint,
 AddressDetail nvarchar(max),
 IsSaving bit,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()

)

insert into testMergeSource
values(1,'anubhab','2001-02-04','2025-03-05',1,1002,2345566,3,'Patia',1,2,3000.65,2,'2',getdate())
insert into testMergeSource
values(3,null,'2001-02-04','2025-03-05',1,1003,2345566,3,'Patia',1,2,3000.65,2,'2',getdate())



merge testMergeTarget t 
using testMergeSource s on s.AccountAnalyticsId=t.AccountAnalyticsId

when matched
  then update set
      t.UserName=s.UserName

when not matched by target then insert (UserName) values (s.UserName)

when not matched by source
  then delete;
