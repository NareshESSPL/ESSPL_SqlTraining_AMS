--Create an substring for the input variable
 IF 
 OBJECT_ID('TEMPDB..#TEMPINPUT') IS NOT NULL
 DROP TABLE #tempinput
 
 Create table #tempinput
 (input varchar(200))
 
 Insert Into #tempinput Values ('111:222'),('123:677')
 
 Declare @temp Varchar(100)
 SET @temp = (Select Top 1 input From #tempinput)
 WHILE @temp is not null
 Begin 
 Declare @FName NVarchar(100)
 Set @Fname = SUBSTRING(@temp, 1,CHARINDEX(':',@TEMP)-1);
 
 Declare @Lname NVarchar(100)
 Set @Lname = SUBSTRING(@temp,CHARINDEX(':',@temp)+1,LEN(@temp))
 Select @Fname AS AccountID, @Lname AS AccountNo
 
 Delete from #tempinput Where input = @temp
 Set @temp = (Select Top 1 input From #tempinput)
 End
 
 CREATE PROCEDURE ProcessTempInputData
 AS
 BEGIN
     -- Check and drop the temp table if it exists
     IF OBJECT_ID('TEMPDB..#TEMPINPUT') IS NOT NULL
         DROP TABLE #tempinput;
 
     -- Create and populate the temp table
     CREATE TABLE #tempinput (input VARCHAR(200));
     INSERT INTO #tempinput VALUES ('111:222'), ('123:677');
 
     -- Declare a variable to store the current input value
     DECLARE @temp VARCHAR(100);
 
     SET @temp = (SELECT TOP 1 input FROM #tempinput);
     WHILE @temp IS NOT NULL
     BEGIN
         -- Extract AccountID and AccountNo
         DECLARE @FName NVARCHAR(100);
         SET @FName = SUBSTRING(@temp, 1, CHARINDEX(':', @temp) - 1);
 
         DECLARE @LName NVARCHAR(100);
         SET @LName = SUBSTRING(@temp, CHARINDEX(':', @temp) + 1, LEN(@temp));
 
         -- Output the extracted values
         SELECT @FName AS AccountID, @LName AS AccountNo;
 
         -- Delete the processed row and update @temp
         DELETE FROM #tempinput WHERE input = @temp;
         SET @temp = (SELECT TOP 1 input FROM #tempinput);
     END
 END;
 
 
 
 
 
 --Drop Table #tempinput;
