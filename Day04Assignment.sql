USE AccountManagementSystem
GO

-----sample output
--AcountID AcountNo
--111      2222
--123      677
--890      900

CREATE TABLE AccountsTemp (
    AccountID VARCHAR(50),
    AccountNo VARCHAR(50)
);

CREATE PROCEDURE TestMultiInput
    @InputString NVARCHAR(MAX)
AS
BEGIN

    DECLARE @Parsed TABLE (Pair NVARCHAR(100));

    -- Step 1: Split on commas to get each key:value pair
    INSERT INTO @Parsed (Pair)
    SELECT LTRIM(RTRIM(value))
    FROM STRING_SPLIT(@InputString, ',');

    -- Step 2: Split each pair on colon and insert into AccountsTemp
    INSERT INTO AccountsTemp (AccountID, AccountNo)
    SELECT 
        LTRIM(RTRIM(SUBSTRING(Pair, 1, CHARINDEX(':', Pair) - 1))),
        LTRIM(RTRIM(SUBSTRING(Pair, CHARINDEX(':', Pair) + 1, LEN(Pair))))
    FROM @Parsed
    WHERE CHARINDEX(':', Pair) > 0;
END

EXEC TestMultiInput '111:2222, 123:677, 890:900';
SELECT * FROM AccountsTemp



