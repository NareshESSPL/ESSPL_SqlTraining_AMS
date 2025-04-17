DECLARE @Name Varchar(100), @FName Varchar(100), @LName Varchar(100),@Length Int
SET @Name ='Naresh Pradhan'

PRINT CHARINDEX('',@Name, 1)

SET @FName = SUBSTRING(@Name,1,CHARINDEX('',@Name)-1)

SET @Length = LEN(@Name)

SELECT @FName, @Length

PRINT @FName

SET @Length = LEN(@Name)

PRINT @FName

PRINT @Length


DECLARE @Name VARCHAR(100), @LName VARCHAR(100), @SpaceIndex INT

SET @Name = 'Naresh Pradhan'

SET @SpaceIndex = CHARINDEX(' ', @Name) -- Find position of space
SET @LName = RIGHT(@Name, LEN(@Name) - @SpaceIndex) -- Extract last name

SELECT @LName AS LastName
PRINT @LName;

