USE BankSystem
GO

-- Sample output expected:
-- AccountID AccountNo
-- 111       2222
-- 123       677
-- 890       900

CREATE OR ALTER PROCEDURE TestMultiInput
    @Input VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Declaring a table variable to hold the raw string values (AccountID:AccountNo)
    DECLARE @RawInput TABLE (Value NVARCHAR(100));

	--Step 1: Splitting the input string by commas
    -- Each part should look like 'AccountID:AccountNo' (e.g., '111:2222')  
    INSERT INTO @RawInput (Value)
    SELECT LTRIM(RTRIM(value))  -- Trim any extra spaces from around each item
    FROM STRING_SPLIT(@Input, ',')
    WHERE value IS NOT NULL AND CHARINDEX(':', value) > 0; -- Only take valid key:value pairs

   -- Step 2: Extracting AccountID (before :) and AccountNo (after :)
    SELECT
        LTRIM(RTRIM(SUBSTRING(Value, 1, CHARINDEX(':', Value) - 1))) AS AccountID,  -- Get part before colon
        LTRIM(RTRIM(SUBSTRING(Value, CHARINDEX(':', Value) + 1, LEN(Value)))) AS AccountNo  -- Get part after colon
    FROM @RawInput;
END;
GO

EXEC TestMultiInput '111:2222, 123:677, 890:900';
