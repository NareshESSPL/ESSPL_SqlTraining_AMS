create table AMS.AccountAnalysis(
 AccountAnalysisId  bigint identity(1,1),
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
 Balance bigint,
 AccountTransactionID bigint,
 Amount decimal(20,2),
 IsDebit bit,
 CreatedBy	varchar(250),
 created Datetime default getDate()
 )

create proc AMS.proc_AccountAnalysis
 as begin 
   
   insert into AMS.AccountAnalysis
     select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,ac.Balance,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID

   select * from AMS.AccountAnalysis

end

use AccountManagementSystem
go


select age_grp,count(UserId) tot_user, avg(Balance) avg_balance from (
select datediff(year,Ac_Analysis.DOB,'2025-04-14') age, UserId, Balance,
case 
    when datediff(year,Ac_Analysis.DOB,'2025-04-14') between 47 and 49 then 'A'
	when datediff(year,Ac_Analysis.DOB,'2025-04-14') between 49 and 51 then 'B'
	when datediff(year,Ac_Analysis.DOB,'2025-04-14') between 51 and 53 then 'C'
	when datediff(year,Ac_Analysis.DOB,'2025-04-14') between 53 and 55 then 'D'
	else 'Invalid'
end as age_grp
from AMS.AccountAnalysis Ac_Analysis
) tempTable
group by age_grp