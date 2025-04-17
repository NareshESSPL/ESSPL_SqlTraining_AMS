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

DECLARE @InputParam xml, @OutputParam VARCHAR(100)
SET @InputParam = '<xml>
	<User>
	   <FName>Naresh</FName>
	   <LName>Pradhan</LName>
	</User>
</xml>'

--SELECT @InputParam.value('(xml/User/LName)[1]', 'NVARCHAR(100)') AS LastName;

EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
PRINT @OutputParam





--DECLARE @InputParam VARCHAR(MAX), @OutputParam VARCHAR(100)
--SET @InputParam = '<xml>
--	<User>
--	   <FName>Naresh</FName>
--	   <LName>Pradhan</LName>
--	</User>
--</xml>'
--print CHARINDEX('</LName>', @InputParam) - (CHARINDEX('<LName>', @InputParam))
--print SUBSTRING(@InputParam, 
--                CHARINDEX('<LName>', @InputParam) + LEN('<LName>'), 
--   CHARINDEX('</LName>', @InputParam) - CHARINDEX('<LName>', @InputParam) - LEN('</LName>') + 1)