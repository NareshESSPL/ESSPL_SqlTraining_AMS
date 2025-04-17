create table TextExcep
(
  id int
)

create table ErrorLog
(
  id bigint identity(1,1) primary key,
  Source Varchar(200),
  Message NVarchar(max),
  CreatedAt DateTime2,
)
--print getdate()

--print getutcdate()


insert into TextExcep values ('sadas')
go

BEGIN TRY

  insert into TextExcep values ('sadas')

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

select * from ErrorLog