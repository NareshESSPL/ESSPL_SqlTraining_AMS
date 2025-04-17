
-- Creating an procedure to join 'User', 'Account' and 'UserAccountMapping' Table
CREATE PROCEDURE SP_UserAccountJoin
AS BEGIN
SELECT * FROM BMS.UserAccountMapping UAM
JOIN BMS.[User] U ON U.UserID = UAM.UserID
JOIN BMS.[Account] A ON A.AccountID = UAM.UserID
END

EXEC BMS.SP_UserAccountJoin;

EXEC SP_HELP 'BMS.[ACCOUNT]';

--To check if the user has an account that has null value
SELECT U.* FROM BMS.[User] U 
JOIN BMS.[UserAccountMapping] UAM ON UAM.UserID = U.UserID 
WHERE UAM.AccountID IS NULL


--Retrieve the user, account and whose avg_salary is greater than salary
SELECT U.*,A.AccountID,A.AccountNo,A.IsSaving, JoinedTable.Avg_Balance
FROM BMS.UserAccountMapping UAM
JOIN BMS.[User] U ON U.UserID = UAM.UserID
JOIN BMS.[Account] A ON A.AccountID = UAM.AccountID
JOIN (
      SELECT U2.UserID,AVG(U2.Balance) Avg_Balance FROM BMS.[User] U2
	  JOIN BMS.UserAccountMapping UAM2 ON UAM2.UserID = U2.UserID
      JOIN BMS.[Account] A2 ON A2.AccountID = UAM2.AccountID 
	  GROUP BY U2.UserID
	  HAVING AVG(U2.Balance) > 1000
) AS JoinedTable ON JoinedTable.UserID = U.UserID 