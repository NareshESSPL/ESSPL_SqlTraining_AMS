;with cte_account
as
(
  select U.UserID,U.UserName,U.Balance,A.AccountID from
	 
  AMS.[User] U Join AMS.[UserAccountMapping] M on U.UserID=M.UserID 

  join AMS.[Account] A on M.AccountId = A.AccountID
)


select a.UserID, a.UserName, a.Balance, a.AccountID from cte_account a
join 
	(
	   select AVG(Balance) AverageBalance,UserID from cte_account group by UserID
	) as avg_bal


on a.UserID = avg_bal.UserID and a.Balance >= avg_bal.AverageBalance;

select * from cte_account;