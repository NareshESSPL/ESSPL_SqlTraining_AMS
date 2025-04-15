USE Testing;

SELECT * FROM AMS.[User];
SELECT * FROM AMS.[Account];
SELECT * FROM AMS.[Address];
SELECT * FROM AMS.[UserAccountMapping];
SELECT * FROM AMS.[AccountTransaction];

-- Creating AccountAnalytics Table
create table AMS.AccountAnalytics(
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
 );
GO
/*
create proc AMS.[proc_AccountAnalytics]
 as begin 
   
   insert into AMS.AccountAnalytics
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID

   select * from AMS.AccountAnalytics

end
EXEC AMS.[proc_AccountAnalytics]
*/

-- delete from AMS.[AccountAnalytics];

-- Creating CTE to extract data from all 5 tables

;with cte_AccountAnalytics
AS
(
 select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
)


MERGE AMS.[AccountAnalytics] t
using cte_AccountAnalytics s
 ON (t.AccountTransactionID = s.AccountTransactionID) 

 when matched
   then 
   UPDATE set t.UserID = s.UserID, t.UserName = s.UserName, t.DOB = s.DOB , t.DOJ= s.DOJ, t.AccountID = s.AccountID, t.AccountNo = s.AccountNo, t.MobileNo = s.MobileNo, t.AddressID = s.AddressID, t.AddressDetail = s.AddressDetail, t.IsSaving = s.IsSaving, t.Amount = s.Amount, t.IsDebit = s.IsDebit, t.CreatedBy = s.CreatedBy, t.Created = s.Created

 when not matched by target
  then insert (UserID, UserName, DOB, DOJ, AccountID, AccountNo, MobileNo, AddressID, AddressDetail, IsSaving, Amount, IsDebit, CreatedBy, Created) Values (s.UserID, s.UserName, s.DOB, s.DOJ, s.AccountID, s.AccountNo, s.MobileNo, s.AddressID, s.AddressDetail, s.IsSaving, s.Amount, s.IsDebit, s.CreatedBy, s.Created)


 when not matched by source
  then delete;


GO;

/*
Simple Example
*/
create table testMergeSource
(
  id int identity(1,1) primary key,
  name varchar(200)
);

create table testMergeTarget
(
  id int primary key,
  name varchar(200),
  CreatedDate DateTime,
);

insert into testMergeSource values ('naresh')
insert into testMergeSource values ('suresh')
insert into testMergeSource values ('mahesh')
--
set identity_insert testMergeTarget ON;
insert into testMergeTarget(id, [name])  values (9, 'Kappa');
set identity_insert testMergeTarget OFF;


select * from testMergeSource;
select * from testMergeTarget;

merge testMergeTarget t
using testMergeSource s ON s.id = t.id

when matched
 then update set t.name = s.name

when not matched by target
 then insert (name) values (s.name)

 when not matched by source
  then delete;

--Updating Data
update testMergeSource set name = 'Suraj' where id=3;

GO

