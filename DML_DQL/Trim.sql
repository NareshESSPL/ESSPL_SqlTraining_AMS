declare @Name Varchar(100)

set @Name = ' Naresh Pradhan '

SELECT LEN(@Name) WITHOUTRIM, LEN(LTRIM(@Name)),  LEN(RTRIM(@Name)), LEN(@Name) 

declare @FName Varchar(100), @LName Varchar(100)

set @FName = 'naresh'
set @LName = 'pradhan'

select @FName + ' ' + @LName