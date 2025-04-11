use AccountManagementSystem
go

declare @Name Varchar(100), @FName Varchar(100), @LName Varchar(100), @Length INT

set @Name = 'Naresh Pradhan'

print CHARINDEX(' ', @Name, 1)

set @FName = SUBSTRING(@Name, 1, CHARINDEX(' ', @Name) - 1)

set @LName = SUBSTRING(@Name, CHARINDEX(' ', @Name) + 1, LEN(@Name) - CHARINDEX(' ', @Name))

SELECT @LName


set @Length = LEN(@Name)

print @FName

print @Length