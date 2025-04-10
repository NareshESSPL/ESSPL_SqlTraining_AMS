

CREATE PROCEDURE [AMS].[Proc User Account UserAccountMapping join]
AS 
BEGIN
	SELECT 
        U.UserName, 
        A.AccountNo
	 FROM 
       AMS.[User]  AS U
    INNER JOIN 
     [AMS].[UserAccountMapping] AS UAM ON U.UserID = UAM.UserID
         INNER JOIN 
        [AMS].[Account] A ON UAM.AccountID = A.AccountID
    WHERE 
        U.Balance > (SELECT AVG(Balance) FROM [AMS].[User]);
END

EXEC [AMS].[Proc User Account UserAccountMapping join]


  --------Find the User with no address---------

  select U.* from  [AMS].[User] U where U.UserID in ( select UserID from [AMS].[Address] where Address is null)


  