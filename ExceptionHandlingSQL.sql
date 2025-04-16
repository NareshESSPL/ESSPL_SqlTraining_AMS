create table ErrorLog
(
ID bigint identity(1,1) primary key,
Source varchar(200),
Message nvarchar(max),
CreatedAt DateTime2

)

BEGIN TRY

 BEGIN TRAN
  insert into [AMS].[Account]([AccountNo],[IsSaving],[CreatedBy],[Created],[Balance]) values (123,0,'admin',getutcdate(),7896 )
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
		
  INSERT INTO ErrorLog VALUES('Query', @Message, GETUTCDATE());

  PRINT 'Exception happened.Please refer the error log table'

END CATCH

select * from Item
select * from [AMS].[Account]