
CREATE TABLE AMS.AccountAnalysis
(
	 AccountAnalysisId BIGINT IDENTITY(1,1),
	 UserID BIGINT,
	 UserName NVARCHAR(250),
	 DOB	DATETIME,
	 DOJ	DATETIME,
	 AccountID BIGINT,
	 AccountNo	INT,
	 MobileNo	INT,
	 AddressId BIGINT,
	 AddressDetail NVARCHAR(MAX),
	 IsSaving BIT,
	 AccountTransactionID BIGINT,
	 Amount DECIMAL(10,6),
	 IsDebit BIT,
	 CreatedBy	VARCHAR(250),
	 created DATETIME
 )

 ;with cte_AccountAnalysis
 as 
 (
  select u.UserID,u.UserName,u.DOB,u.DOJ,ac.AccountID,ac.AccountNo, u.MobileNo,a.AddressID,a.AddressDetail,
	 ac.IsSaving,act.AccountTransactionID,act.Amount,act.IsDebit,u.CreatedBy,u.Created 
  from AMS.[User] u
	 inner join AMS.[Address] a on a.UserID = u.UserID
	 inner join AMS.UserAccountMapping uam on uam.UserID = u.UserID
	 inner join AMS.Account ac on ac.AccountID = uam.AccountID
	 inner join AMS.AccountTransaction act on act.AccountID = ac.AccountID
  )

MERGE AMS.AccountAnalysis t 
    USING cte_AccountAnalysis s
ON (s.UserID = s.UserID)

WHEN MATCHED
    THEN UPDATE SET 
        t.UserName = s.UserName

WHEN NOT MATCHED BY TARGET 
    THEN INSERT ([UserID]
           ,[UserName]
           ,[DOB]
           ,[DOJ]
           ,[AccountID]
           ,[AccountNo]
           ,[MobileNo]
           ,[AddressId]
           ,[AddressDetail]
           ,[IsSaving]
           ,[AccountTransactionID]
           ,[Amount]
           ,[IsDebit]
           ,[CreatedBy]
           ,[created])
         VALUES (
		    s.UserID
           ,s.[UserName]
           ,s.[DOB]
           ,s.[DOJ]
           ,s.[AccountID]
           ,s.[AccountNo]
           ,s.[MobileNo]
           ,s.[AddressId]
           ,s.[AddressDetail]
           ,s.[IsSaving]
           ,s.[AccountTransactionID]
           ,s.[Amount]
           ,s.[IsDebit]
           ,s.[CreatedBy]
           ,s.[created]		 
		 )

WHEN NOT MATCHED BY SOURCE 
    THEN DELETE;



