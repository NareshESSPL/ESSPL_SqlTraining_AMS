/*
Created By : Suraj Kumar Sah
Date : 16-04-2025
DESC : XML DataType
*/

USE Testing;
GO

-- Create the stored procedure
CREATE PROC proc_TestOutputParam
(
    @Input XML,
    @Output VARCHAR(100) OUTPUT
)
AS
BEGIN
    -- Extract the last name from the XML input
    SET @Output = @Input.value('(/xml/User/LName)[1]', 'VARCHAR(100)')
END

-- Declare input and output variables
DECLARE @InputParam XML, @OutputParam VARCHAR(100)

-- Initialize the input XML
SET @InputParam = '<xml>
 <User>
  <FName>Naresh</FName>
  <LName>Pradhan</LName>
 </User>
</xml>'

-- Execute the stored procedure
EXEC proc_TestOutputParam @Input = @InputParam, @Output = @OutputParam OUTPUT

-- Print the output parameter to see the last name
PRINT @OutputParam
GO
-----------------------------------------------------------


--Sample Example
declare @TestxmlType xml
set @TestXmlType = 
'<xml>
	<User>
	   <FName></FName>
	   <LName></LName>
	</User>
</xml>'

select @TestxmlType
GO

CREATE PROC proc_TestOutputParam1
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

EXEC proc_TestOutputParam1 '1', 2

EXEC proc_TestOutputParam1 @Input2 = @Input2Param, @Input1 = @Input1Param
------------------------------------------