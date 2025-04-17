                                                         /* XML DATATYPES */
                                                        ---------------------

Declare @testXMLType XML
SET @testXMLType =
'
<XML>
<User>
	       <FName> </FName>
		   <LName> </LName>
</User>
</XML>
'

select @TestxmlType

DROP PROCEDURE proc_TestOutputParam;

-- Create the Procedure
CREATE PROCEDURE proc_TestOutputParam
(
	@Input XML,
	@Output VARCHAR(100) OUTPUT
)
AS
BEGIN
	 
	SET @Output = @Input.value('(/xml/User/LName)[1]', 'VARCHAR(100)');
END;
GO

 
DECLARE @InputParam XML;
DECLARE @OutputParam VARCHAR(100);


SET @InputParam = 
'<xml>
	<User>
		<FName>Naresh</FName>
		<LName>Pradhan</LName>
	</User>
</xml>';

 
EXEC proc_TestOutputParam 
	@Input = @InputParam, 
	@Output = @OutputParam OUTPUT;

-- Print the output (last name)
PRINT  + @OutputParam;

-- Extracting the Character Length

alter PROC proc_TestOutputParam
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
-- EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
-- PRINT @OutputParam


-- Simple way to find the value
SELECT @InputParam.value('(xml/User/FName)[1]', 'NVARCHAR(100)') AS FastName;

EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT
PRINT @OutputParam


-- EXCEPTION HANDLING

CREATE TABLE textExcep(id INT)



INSERT INTO textExcep VALUES('sadas')
GO

BEGIN
TRY
INSERT INTO textExcep VALUES ('sadas')
END 
TRY

BEGIN
CATCH
PRINT 'Exception Happened'
END
CATCH


--