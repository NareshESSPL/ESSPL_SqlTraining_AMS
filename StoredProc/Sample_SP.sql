CREATE PROC proc_TestOutputParam
(
 @Input1 int,
 @Input2 varchar(10)
)
AS
BEGIN
   print @Input1
END

declare @Input1Param int, @Input2Param varchar(10)

set @Input1Param = 1
set @Input2Param = 'testing'

select @Input1Param = 1, @Input2Param = 2

EXEC proc_TestOutputParam '1', 2

EXEC proc_TestOutputParam @Input2 = @Input2Param, @Input1 = @Input1Param