CREATE PROCEDURE ProcessTempInputData
AS
BEGIN
 
    IF OBJECT_ID('TEMPDB..#TEMPINPUT') IS NOT NULL
        DROP TABLE #tempinput;

    CREATE TABLE #tempinput (input VARCHAR(200));
    INSERT INTO #tempinput VALUES ('511:662'), ('823:167');


    DECLARE @temp VARCHAR(100);

    SET @temp = (SELECT TOP 1 input FROM #tempinput);
    WHILE @temp IS NOT NULL
    BEGIN

        DECLARE @FName NVARCHAR(100);
        SET @FName = SUBSTRING(@temp, 1, CHARINDEX(':', @temp) - 1);

        DECLARE @LName NVARCHAR(100);
        SET @LName = SUBSTRING(@temp, CHARINDEX(':', @temp) + 1, LEN(@temp));

        SELECT @FName AS AccountID, @LName AS AccountNo;

        DELETE FROM #tempinput WHERE input = @temp;
        SET @temp = (SELECT TOP 1 input FROM #tempinput);
    END
END;

exec  ProcessTempInputData