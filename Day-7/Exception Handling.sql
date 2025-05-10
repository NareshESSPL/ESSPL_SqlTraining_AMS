/*
Created By : Suraj Kumar Sah
Date : 16-04-2025
DESC : Exception Handling
*/

USE Testing;
GO

CREATE TABLE TextExcep
(
  id INT
);

--Creating Log Table'
CREATE TABLE ErrorLog
(
  ID BIGINT IDENTITY(1, 1) PRIMARY KEY,
  Source VARCHAR(200),
  Message NVARCHAR(MAX),
  CreatedAt DATETIME2
);

INSERT INTO TextExcep VALUES ('Nepal');

-- Exception Handling
BEGIN TRY

  INSERT INTO TextExcep VALUES ('Nepal');

END TRY

BEGIN CATCH
  
  DECLARE @Message NVARCHAR(MAX)
  SELECT @Message = 
        'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + 
        'ERROR_MESSAGE : ' + ERROR_MESSAGE() +
        'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) +
        'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) +
        'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200)) 
		
  INSERT INTO ErrorLog VALUES('Query', @Message, GETUTCDATE())

  PRINT 'Exception happened.Please refer the error log table'

END CATCH
GO
select * from ErrorLog;