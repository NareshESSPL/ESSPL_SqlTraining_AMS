
--PROCEDURE TO MAKE JOIN BETWEEN THE User, Account, UserAccountMapping TABLES
CREATE PROCEDURE AMS.SP_UserAndAccountJoin
AS BEGIN 
  SELECT * FROM AMS.UserAccountMapping UAM
  JOIN AMS.[User] U ON U.UserID = UAM.UserID
  JOIN AMS.[Account] A ON A.AccountID = UAM.AccountID
END

EXEC AMS.SP_UserAndAccountJoin


--find the users who does not have accounts
SELECT U.* FROM AMS.[User] U 
JOIN AMS.[UserAccountMapping] UAM ON UAM.UserID = U.UserID 
WHERE UAM.AccountID IS NULL


--Find User, Account detail for User who has avrerage balance of more than 10000
SELECT U.*,A.AccountID,A.AccountNo,A.IsSaving, JoinedTable.Avg_Balance
FROM AMS.UserAccountMapping UAM
JOIN AMS.[User] U ON U.UserID = UAM.UserID
JOIN AMS.[Account] A ON A.AccountID = UAM.AccountID
JOIN (
      SELECT U2.UserID,AVG(U2.Balance) Avg_Balance FROM AMS.[User] U2
	  JOIN AMS.UserAccountMapping UAM2 ON UAM2.UserID = U2.UserID
      JOIN AMS.[Account] A2 ON A2.AccountID = UAM2.AccountID 
	  GROUP BY U2.UserID
	  HAVING AVG(U2.Balance) > 10000
) AS JoinedTable ON JoinedTable.UserID = U.UserID 

