/*
Created By : Suraj Kumar Sah
Date : 16-04-2025
DESC : Transaction
*/
GO
USE Testing;
GO

select * from ams.[User]
select * from ams.[Address]


BEGIN TRY
 BEGIN TRAN

 SET IDENTITY_INSERT AMS.[User] ON
  INSERT INTO AMS.[User] (userid, username, dob, doj, accountno, mobileno, createdby) values (2021, 'Suraj Sah', '2004-02-02 00:00:00.000', '2020-02-02 00:00:00.000', 2001, 4836, 'suraj');
  SET IDENTITY_INSERT AMS.[User] OFF
  
  SET IDENTITY_INSERT AMS.[Address] ON
  INSERT INTO AMS.[Address] (addressid, userid, AddressDetail, CreatedBy) values (2001, 2020, 'Nepal', 'surajsah');
  SET IDENTITY_INSERT AMS.[Address] OFF
  
  COMMIT TRAN

END TRY

BEGIN CATCH
  ROLLBACK TRAN
  PRINT 'Error while inserting data'

  DECLARE @ErrorMessage nvarchar(MAX)
  set @ErrorMessage = 
	    'ERROR_NUMBER : ' + CAST(ERROR_NUMBER() AS NVARCHAR(200)) + ' ' +
        'ERROR_MESSAGE : ' + ERROR_MESSAGE() + ' ' +
        'ERROR_SEVERITY : ' + CAST(ERROR_SEVERITY() AS NVARCHAR(200)) + ' ' +
        'ERROR_STATE : ' + CAST(ERROR_STATE() AS NVARCHAR(200)) + ' ' +
        'ERROR_LINE : ' + CAST(ERROR_LINE() AS NVARCHAR(200))
  
  PRINT 'Error Message : ' + @ErrorMessage

END CATCH