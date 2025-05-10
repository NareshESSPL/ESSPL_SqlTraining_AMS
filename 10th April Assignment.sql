use AccountManagementSystem

select * from AMS.[User];

select * from AMS.Account;

-- user with more than avg balance

SELECT u.UserID,u.UserName,u.Balance,a.AccountID
	FROM AMS.[User] u
	Join
	AMS.[UserAccountMapping] map ON u.UserID=map.UserID
	join 
	AMS.[Account] a on map.AccountId=a.AccountID
	join 
	(Select AVG(u.Balance) as AVG_BAL  from AMS.[User] u)
	as ab on u.Balance>ab.AVG_BAL;

-- user having multiple account

SELECT 
    u.UserID,
    u.UserName,
    COUNT(uam.AccountID) AS TotalAccounts
FROM 
    ams.[User] u
JOIN 
    ams.UserAccountMapping uam ON u.UserID = uam.UserID
GROUP BY 
    u.UserID, u.UserName
HAVING 
    COUNT(uam.AccountID) > 1;

--user having no address

SELECT 
    u.UserID,
    u.UserName,
    u.MobileNo,
    u.Balance
FROM 
    ams.[User] u
LEFT JOIN 
    ams.Address a ON u.UserID = a.UserID
WHERE 
    a.AddressID IS  NULL
go













