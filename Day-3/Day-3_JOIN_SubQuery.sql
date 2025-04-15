/*
Created Date : 10-04-2025
Created By : Suraj Kumar Sah
Desc : JOINS and Sub Query
*/
 
/*
Q-1. Do a JOIN with User, Account and UserAccountMapping table
*/
CREATE PROCEDURE AMS.Proc_GetUserAccountDetails
AS
BEGIN
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving,
        UAM.CreatedBy AS MappingCreatedBy
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID;
END

EXEC AMS.Proc_GetUserAccountDetails;


/*
Q-2. Find the account for each user with more than average balance
*/
CREATE PROCEDURE AMS.Proc_GetUsersWithAboveAverageBalance
AS
BEGIN
    -- Declare a variable to hold the average balance
    DECLARE @AverageBalance DECIMAL(10, 6);

    -- Calculate the average balance
    SELECT @AverageBalance = AVG(Balance) FROM AMS.[User];

    -- Select users with balance greater than the average balance along with their account details
    SELECT 
        U.UserID,
        U.UserName,
        U.Balance,
        A.AccountID,
        A.AccountNo,
        A.IsSaving
    FROM 
        AMS.[User] U
    JOIN 
        AMS.UserAccountMapping UAM ON U.UserID = UAM.UserID
    JOIN 
        AMS.Account A ON UAM.AccountID = A.AccountID
    WHERE 
        U.Balance > @AverageBalance;
END

EXEC AMS.Proc_GetUsersWithAboveAverageBalance;


/*
Q-3. Find users who doesn't have address
*/
CREATE PROCEDURE AMS.Proc_GetUsersWithoutAddress AS
BEGIN
    -- Select users who do not have an associated address
    SELECT 
        U.UserID,
        U.UserName,
        U.DOB,
        U.DOJ,
        U.Balance,
        U.MobileNo
    FROM 
        AMS.[User] U
    LEFT JOIN 
        AMS.[Address] A ON U.UserID = A.UserID
    WHERE 
        A.AddressID IS NULL;
END

EXEC AMS.Proc_GetUsersWithoutAddress;
