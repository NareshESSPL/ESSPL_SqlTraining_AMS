use AccountManagementSystem

-- joining user,Acount,userAccountMapping
SELECT 
    u.UserID,
    u.UserName,
    u.MobileNo,
    a.AccountID,
    a.AccountNo,
    a.IsSaving,
    uam.Created AS MappingDate
FROM 
    ams.[User] u
JOIN 
    ams.UserAccountMapping uam ON u.UserID = uam.UserID
JOIN 
    ams.Account a ON uam.AccountID = a.AccountID

go

-- balance is greater than average
SELECT 
    u.UserID,
    u.UserName,
    u.Balance,
    a.AccountID,
    a.AccountNo,
    a.IsSaving
FROM 
    ams.[User] u
JOIN 
    ams.UserAccountMapping uam ON u.UserID = uam.UserID
JOIN 
    ams.Account a ON uam.AccountID = a.AccountID
WHERE 
    u.Balance >= (SELECT AVG(Balance) FROM ams.[User])
go

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
go

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