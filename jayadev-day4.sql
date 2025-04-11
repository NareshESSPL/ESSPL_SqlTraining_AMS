-- Step 1: Drop the stored procedure that uses the type
DROP PROCEDURE IF EXISTS AM.User_account_detail;
GO

-- Step 2: Drop the type now that nothing references it
DROP TYPE IF EXISTS AM.Account;
GO

-- Step 3: Recreate the type WITHOUT IDENTITY
CREATE TYPE AM.Account AS TABLE  
(  
    AccountId BIGINT,     
    AccountNo BIGINT  
);
GO

-- Step 4: Recreate the stored procedure
CREATE PROCEDURE AM.User_account_detail  
    @accountList AM.Account READONLY  
AS  
BEGIN  
    SELECT * FROM @accountList;  
END;
GO

-- Step 5: Declare and use the table variable
DECLARE @InputAccount AM.Account;

INSERT INTO @InputAccount (AccountId, AccountNo)  
VALUES (111, 2222), (123, 677) ,(890,900);

EXEC AM.User_account_detail @accountList = @InputAccount;
