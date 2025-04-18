/*
  Created By : Suraj Kumar Sah
  Date : 18-04-2025
  Desc : Practice - 1 (Questions)
*/

﻿USE [Practice]
GO

CREATE OR ALTER PROC CreateDummyrecordsForOrder
 @MaxCount BIGINT = 1000
AS
BEGIN
  TRUNCATE TABLE Orders
  

  DECLARE 
    @Order_ID INT,
	@Customer_Name NVARCHAR(50) ,
	@Product NVARCHAR(50) ,
	@Quantity INT ,
	@Order_Date DATE ,
	@Total_Amount DECIMAL(10, 2) ,
	@CATEGORY NVARCHAR(50) 

  DECLARE @Count INT = 0;

  SET @Order_Date = '1990-01-01'
  
  WHILE @Count < = @MaxCount
  BEGIN
  --Do not delete
    SELECT @Count = @Count + 1

    SET @Order_ID = @Count
    SET @Customer_Name = 'TestName' + CAST(@count AS VARCHAR)
    SET @Product = 'Product' + CAST(@count AS VARCHAR)
    SET @Quantity = 2
    SET @Order_Date = DATEADD(DAY, -1, @Order_Date)
    SET @Total_Amount = 1000
    SET @CATEGORY = 'A'

    INSERT INTO [dbo].[Orders]
           ([Order_ID]
           ,[Customer_Name]
           ,[Product]
           ,[Quantity]
           ,[Order_Date]
           ,[Total_Amount]
           ,[CATEGORY])
      VALUES
           (@Order_ID
           ,@Customer_Name
           ,@Product
           ,@Quantity
           ,@Order_Date
           ,@Total_Amount
           ,@CATEGORY)
  END
END

EXEC CreateDummyrecordsForOrder
SELECT * FROM Orders