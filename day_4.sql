-- Create the procedure
CREATE PROCEDURE TestMultiInput
    @Input VARCHAR(MAX)
AS
BEGIN
    DECLARE @Str VARCHAR(100), @AccountID VARCHAR(100), @AccountNo VARCHAR(100)

    -- Table to store results
    DECLARE @Result TABLE (
        AccountID VARCHAR(100),
        AccountNo VARCHAR(100)
    );

    -- Loop to split input by comma
    WHILE CHARINDEX(',', @Input) > 0
    BEGIN
        SET @Str = LTRIM(RTRIM(LEFT(@Input, CHARINDEX(',', @Input) - 1)));

        SET @AccountID = LEFT(@Str, CHARINDEX(':', @Str) - 1);
        SET @AccountNo = RIGHT(@Str, LEN(@Str) - CHARINDEX(':', @Str));

        INSERT INTO @Result VALUES (@AccountID, @AccountNo);

        SET @Input = LTRIM(RTRIM(STUFF(@Input, 1, CHARINDEX(',', @Input), '')))
    END

    -- Handle the last value (if any)
    IF LEN(@Input) > 0 AND CHARINDEX(':', @Input) > 0
    BEGIN
        SET @AccountID = LEFT(@Input, CHARINDEX(':', @Input) - 1);
        SET @AccountNo = RIGHT(@Input, LEN(@Input) - CHARINDEX(':', @Input));

        INSERT INTO @Result VALUES (@AccountID, @AccountNo);
    END

    -- Final output
    SELECT AccountID, AccountNo FROM @Result;
END
EXEC TestMultiInput '111:2222,123:677,890:900';