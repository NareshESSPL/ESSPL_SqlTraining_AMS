/*
Created By : Suraj Kumar Sah
Date : 16-04-2025
DESC : Transaction
*/

/*
Note :
  - We must either commit or rollback the transaction while writing the transaction
  - How to know when to commit and when to rollback - exception handling
   --Don't use exception handling everywhere, use only where you are not sure that dml operation will happen or not
*/

USE Testing;
GO


BEGIN TRY

 BEGIN TRAN
  insert into Itemtype(ItemtypeId, ItemtypeName) values (111, 'testtype')
  insert into Item(ItemId, ItemtypeId, Itemname) values (199, 879, 'testtype')
 
 COMMIT TRAN

END TRY
BEGIN CATCH
  
  ROLLBACK
  print 'rolledback'

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

select * from Item
select * from ItemType
---------------------------------------------