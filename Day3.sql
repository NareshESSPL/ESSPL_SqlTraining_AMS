
-- just to show the values in this following tables--

select * from AMS.[User]
select * from AMS.[Account]
select * from AMS.[UserAccountMapping]


--Using Aggregate function and Group By Clause with JOIN--

SELECT  us.UserID, us.AccountNo, COUNT(am.AccountID) as TotalAccountID, AVG(us.Balance) AS AvgBalance FROM  AMS.[User] AS us
JOIN  AMS.[UserAccountMapping] AS am  ON us.UserID = am.UserID
GROUP BY  us.UserID,us.AccountNo
HAVING AVG(us.Balance) > (SELECT AVG(Balance) FROM AMS.[User]);

--Using Stored Procedure with JOIN and Aggregate function--
go

create Procedure AMS.Get_UsersAverage_Balance
AS BEGIN
   select * from AMS.[UserAccountMapping] uam
   join
  ( 
  select UserID, AVG(Balance) AVG_SALARY  
  from AMS.[User] group by UserID 
  ) as avg_user

on uam.UserID = avg_user.UserID and AVG_SALARY > (select AVG(Balance) from AMS.[User]) 
END;

EXEC AMS.Get_UsersAverage_Balance;

go
-- Using Stored Procedure with subquery based on join and group by --

create Procedure AMS.Get_UserAverage_Balance_subquery

AS BEGIN
     SELECT * FROM 
    (
        (SELECT  u.UserID, u.AccountNo, COUNT(a.AccountID) AS TotalAccountID, AVG(u.Balance) AS TotalBalance 
        FROM  AMS.[User] AS u
        JOIN 
        AMS.[UserAccountMapping] AS a ON u.UserID = a.UserID
		group by u.UserID,u.AccountNo
		)

    ) AS X 
     where
        X.TotalBalance > ( SELECT AVG(Balance) FROM AMS.[User] )
        
END;

 exec AMS.Get_UserAverage_Balance_subquery

 go

 -- Details of the users having no address using Stored Procedure--
 

 create Procedure AMS.get_UserAddressDetail
  as begin
     
	 select * from
	 ( 
	   select u.UserID,u.UserName,ad.AddressDetail,ad.AddressID from AMS.[User] as u
	   join
	   AMS.[Address] as ad on u.UserID = ad.UserID
	 ) as X
	 where X.AddressDetail IS NULL;
  end

exec AMS.get_UserAddressDetail


-- To show the value of the following tables--

select * from AMS.[Address]
select * from AMS.[User]

 