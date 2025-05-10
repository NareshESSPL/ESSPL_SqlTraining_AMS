-- Creating an procedure to join 'User', 'Account' and 'UserAccountMapping' Table
CREATE PROCEDURE AMS.SP_UserAccountJoin
AS BEGIN
SELECT * FROM AMS.UserAccountMapping UAM
JOIN AMS.[User] U ON U.UserID = UAM.UserID
JOIN AMS.[Account] A ON A.AccountID = UAM.UserID
END

EXEC AMS.SP_UserAccountJoin;

EXEC SP_HELP 'AMS.[ACCOUNT]';

--To check if the user has an account that has null value
SELECT U.* FROM AMS.[User] U 
JOIN AMS.[UserAccountMapping] UAM ON UAM.UserID = U.UserID 
WHERE UAM.AccountID IS NULL

--Retrieve the user, account and whose avg_salary is greater than salary
SELECT U.*,A.AccountID,A.AccountNo,A.IsSaving, JoinedTable.Avg_Balance
FROM AMS.UserAccountMapping UAM
JOIN AMS.[User] U ON U.UserID = UAM.UserID
JOIN AMS.[Account] A ON A.AccountID = UAM.AccountID
JOIN (
      SELECT U2.UserID,AVG(U2.Balance) Avg_Balance FROM AMS.[User] U2
	  JOIN AMS.UserAccountMapping UAM2 ON UAM2.UserID = U2.UserID
      JOIN AMS.[Account] A2 ON A2.AccountID = UAM2.AccountID 
	  GROUP BY U2.UserID
	  HAVING AVG(U2.Balance) > 1000
) AS JoinedTable ON JoinedTable.UserID = U.UserID 
