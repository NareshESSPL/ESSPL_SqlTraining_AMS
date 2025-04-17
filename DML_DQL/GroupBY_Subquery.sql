--Introduce a column as MVC(most vauleable customer) with balance more than average balance
--based on agegroup and do a ranking based on that

select * from AMS.[user]
--rank
declare
	@DOB [datetime] = dateadd(month,1,cast('1970-01-01' as date))
print @DOB

declare @date datetime
set @date = '1970-01-08'

print datediff(year, @date, getdate())

 

 select avg(balance) AverageBalance, AgeGroup from
 (
  select u.userid, u.dob, a.balance,
  case 
   when DATEDIFF(year, dob, getdate()) > 10 and DATEDIFF(year, dob, getdate()) < 20 then 'A'
   when DATEDIFF(year, dob, getdate()) > 20 and DATEDIFF(year, dob, getdate()) < 30 then 'B'
   when DATEDIFF(year, dob, getdate()) > 30 and DATEDIFF(year, dob, getdate()) < 45 then 'C'
   when DATEDIFF(year, dob, getdate()) > 45 then 'D'
   else 'Invalid age' 
  end AgeGroup
  from AMS.[user] u 
  join AMS.UserAccountMapping am on u.UserID = am.UserID
  join AMS.Account a on am.AccountID = a.AccountID
 ) as x group by x.AgeGroup
