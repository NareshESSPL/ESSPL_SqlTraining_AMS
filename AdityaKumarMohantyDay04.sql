use AccountManagementSystem


Alter PROC TestMultiInput
    @Input varchar(max)
AS
BEGIN
    DECLARE @ParsedData TABLE (
        AccountID varchar(50),
        AccountNo varchar(50)
    );

    INSERT INTO @ParsedData (AccountID, AccountNo)
    SELECT
        LEFT(value, CHARINDEX(':', value) - 1), 
        SUBSTRING(value, CHARINDEX(':', value) + 1, LEN(value)) 
    FROM STRING_SPLIT(@Input, ','); 

    SELECT AccountID, AccountNo
    FROM @ParsedData;
END
GO

EXEC TestMultiInput '111:2222,123:677,890:900';
go

-----sample output
--AcountID AcountNo
--111      2222
--123      677
--890      900
