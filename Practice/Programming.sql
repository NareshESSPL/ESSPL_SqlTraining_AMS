
--1.Create Function to mask the middle six digit with * of a 10 digit account number

ALTER FUNCTION func_Mask(@Input VARCHAR(10))
RETURNS VARCHAR(10)
AS
BEGIN
  DECLARE @Output VARCHAR(10)
  SET @Output = LEFT(@Input, 2) + '******' +
               RIGHT(@Input, 2)

  RETURN @Output
END


print dbo.func_Mask('1234567891')

print RIGHT('1234567891', 2)