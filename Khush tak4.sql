--------------------------------------------------question-----------------------------------------------------------

create proc TestMultiInput
@Input varchar(max)
as
begin
end

exec TestMultiInput '111:2222', '123:677', '890:900'

-----sample output
--AcountID AcountNo
--111      2222
--123      677
--890      900
------------------------------------------------------------------solution-------------------------------------------------
IF OBJECT_ID('tempdb..#tempInput') IS NOT NULL
DROP TABLE #tempInput;

create table #tempInput 
(
  input varchar(200)
)

insert into #tempInput values ('111:2222, 123:677, 890:900')
CREATE PROCEDURE TestMultiInput
    @Input VARCHAR(MAX)
AS
BEGIN
    DECLARE @Str VARCHAR(100), @AccountID VARCHAR(100), @AccountNo VARCHAR(100)

    -- Table to store result
    DECLARE @Result TABLE (
        AccountID VARCHAR(100),
        AccountNo VARCHAR(100)
    );

    -- Loop to split input by comma
    WHILE CHARINDEX(',', @Input) > 0
    BEGIN
        SET @Str = LEFT(@Input, CHARINDEX(',', @Input) - 1);

        SET @AccountID = LEFT(@Str, CHARINDEX(':', @Str) - 1);
        SET @AccountNo = RIGHT(@Str, LEN(@Str) - CHARINDEX(':', @Str));

        INSERT INTO @Result VALUES (@AccountID, @AccountNo);

        SET @Input = STUFF(@Input, 1, CHARINDEX(',', @Input), '')
    END

    -- Handle last item
    IF LEN(@Input) > 0 AND CHARINDEX(':', @Input) > 0
    BEGIN
        SET @AccountID = LEFT(@Input, CHARINDEX(':', @Input) - 1);
        SET @AccountNo = RIGHT(@Input, LEN(@Input) - CHARINDEX(':', @Input));

        INSERT INTO @Result VALUES (@AccountID, @AccountNo);
    END

    -- Final output
    SELECT * FROM @Result;

	

END

exec TestMultiInput '111:2222, 123:677, 890:900';
DROP TABLE #tempInput;



  
