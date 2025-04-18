USE AccountManagementSystem
GO

INSERT INTO [AMS].[MergedUserInfo]
           ([UserId]
           ,[UserName]
           ,[DateOfBirth]
           ,[DateOfJoining]
           ,[Balance]
           ,[MobileNumber]
           ,[FullAddress]
           ,[AccountID]
           ,[AccountNumber]
           ,[IsSaving]
           ,[Amount]
           ,[IsDebit]
           ,[CreatedBy]
           ,[CreatedDate])
     VALUES
           (1,'testuser1','1970-03-01 00:00:00.000','2025-04-13 10:25:16.457',1088.000000,20002,'123 Test Street, Test City #1',1010, 2002,	1,	501.000000,	0,'testdata', GETDATE()),
		   (1,'testuser1','1970-03-01 00:00:00.000','2025-04-13 10:25:16.457',1088.000000,20002,'123 Test Street, Test City #1',1020, 2012,	1,	501.000000,	0,'testdata', GETDATE()),
		   (1,'testuser1','1970-03-01 00:00:00.000','2025-04-13 10:25:16.457',1188.000000,20002,'123 Test Street, Test City #1',1030, 2022,	1,	501.000000,	0,'testdata', GETDATE()),
		   (1,'testuser1','1970-03-01 00:00:00.000','2025-04-13 10:25:16.457',1288.000000,20002,'123 Test Street, Test City #1',1040, 2032,	1,	501.000000,	0,'testdata', GETDATE());
GO
           
SELECT 
    YEAR(DateOfBirth) AS year_of_birth,
    MIN(Balance) AS minimum_balance
FROM AMS.MergedUserInfo
WHERE UserId IN (
    SELECT UserId
    FROM AMS.MergedUserInfo
    GROUP BY UserId
    HAVING COUNT(*) > 3
)
GROUP BY YEAR(DateOfBirth)
ORDER BY year_of_birth;
