declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType

CREATE PROC proc_TestOutputParam
(
 @Input XML,
 @Output VARCHAR(100) OUTPUT
)
AS
BEGIN
  SET @Output = 'testing'
END

DECLARE @InputParam XML, @OutputParam VARCHAR(100)
SET @InputParam = '<xml>
	<User>
	   <FName>Naresh</FName>
	   <LName>Pradhan</LName>
	</User>
</xml>'

EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
PRINT @OutputParam

