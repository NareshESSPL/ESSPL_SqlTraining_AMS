
-- just to show the values in this following tables--

select * from AM.[User]
select * from AM.[Account]
select * from AM.[UserAccountMapping]


--Using Aggregate function and Group By Clause with JOIN--

SELECT  us.UserID, us.AccountNo, COUNT(am.AccountID) as TotalAccountID, AVG(us.Balance) AS AvgBalance FROM  AM.[User] AS us
JOIN  AM.[UserAccountMapping] AS am  ON us.UserID = am.UserID
GROUP BY  us.UserID,us.AccountNo
HAVING AVG(us.Balance) > (SELECT AVG(Balance) FROM AM.[User]);

--Using Stored Procedure with JOIN and Aggregate function--
go

alter Procedure AM.Get_UsersAverage_Balance
AS BEGIN
   select * from AM.[UserAccountMapping] uam
   join
  ( 
  select UserID, AVG(Balance) AVG_SALARY  
  from AM.[User] group by UserID 
  ) as avg_user

on uam.UserID = avg_user.UserID and AVG_SALARY > (select AVG(Balance) from AM.[User]) 
END;

EXEC AM.Get_UsersAverage_Balance;

go
-- Using Stored Procedure with subquery based on join and group by --

alter Procedure AM.Get_UserAverage_Balance_subquery

AS BEGIN
     SELECT * FROM 
    (
        (SELECT  u.UserID, u.AccountNo, COUNT(a.AccountID) AS TotalAccountID, AVG(u.Balance) AS TotalBalance 
        FROM  AM.[User] AS u
        JOIN 
        AM.[UserAccountMapping] AS a ON u.UserID = a.UserID
		group by u.UserID,u.AccountNo
		)

    ) AS X 
     where
        X.TotalBalance > ( SELECT AVG(Balance) FROM AM.[User] )
        
END;

 exec AM.Get_UserAverage_Balance_subquery

 go

 -- Details of the users having no address using Stored Procedure--
 

 alter Procedure AM.get_UserAddressDetail
  as begin
     
	 select * from
	 ( 
	   select u.UserID,u.UserName,ad.AddressDetail,ad.AddressID from AM.[User] as u
	   join
	   AM.[Address] as ad on u.UserID = ad.UserID
	 ) as X
	 where X.AddressDetail IS NULL;
  end

exec AM.get_UserAddressDetail


-- To show the value of the following tables--

select * from AM.[Address]
select * from AM.[User]

 