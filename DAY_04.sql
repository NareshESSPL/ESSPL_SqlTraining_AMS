CREATE PROC TestMultiInput
    @Input VARCHAR(MAX)
AS
BEGIN
    DECLARE @AccountDetails TABLE (
        AccountID VARCHAR(100),
        AccountNO VARCHAR(100)
    )

    DECLARE @finalTemp VARCHAR(100)
    DECLARE @pairs VARCHAR(100)
    DECLARE @commaPos INT
    DECLARE @colonPos INT

    SET @finalTemp = LTRIM(RTRIM(@Input))

    WHILE LEN(@finalTemp) > 0
    BEGIN
        SET @commaPos = CHARINDEX(',', @finalTemp)

        IF @commaPos = 0
        BEGIN
            SET @pairs = LTRIM(RTRIM(@finalTemp))
            SET @finalTemp = ''
        END
        ELSE
        BEGIN
            SET @pairs = LTRIM(RTRIM(SUBSTRING(@finalTemp, 1, @commaPos - 1)))
            SET @finalTemp = LTRIM(RTRIM(SUBSTRING(@finalTemp, @commaPos + 1, LEN(@finalTemp))))
        END

        SET @colonPos = CHARINDEX(':', @pairs)

        IF @colonPos > 0
        BEGIN
            INSERT INTO @AccountDetails
            VALUES (
                SUBSTRING(@pairs, 1, @colonPos),                          -- AccountID
                SUBSTRING(@pairs, @colonPos + 1, LEN(@pairs)+1)                -- AccountNO
            )
        END
    END

    SELECT * FROM @AccountDetails
END

EXEC TestMultiInput '111:2222, 123:677, 890:900'
 