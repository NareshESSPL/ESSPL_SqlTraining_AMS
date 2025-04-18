-- Stored Procedure for Pagination of from Order table and craete a table varriable 
-- and put into the order_summery  

use Practice;

create or alter procedure spPagination
(
	@Pagen int,
	@RowN int
)
as
begin
	DECLARE @PageNumber AS INT
	DECLARE @RowsOfPage AS INT
	SET @PageNumber= @Pagen
	SET @RowsOfPage= @RowN
	SELECT * FROM Orders
	ORDER BY  Order_ID
	OFFSET (@PageNumber-1)*@RowsOfPage ROWS
	FETCH NEXT @RowsOfPage ROWS ONLY
end
go

--Exec spPagination 1,100
--go

--sp_help 'Orders'
----since data types are different
--truncate table OrderSummary
--go
----drop PROCEDURE spMergeOrderSummary
create or alter PROCEDURE spMergeOrderSummary_TableVariable
AS
BEGIN
    DECLARE @PageNumber INT = 1;
    DECLARE @RowsOfPage INT = 100;

    DECLARE @TempOrders TABLE
    (
        Order_ID INT PRIMARY KEY,
        Customer_Name NVARCHAR(50),
        Product NVARCHAR(50),
        Quantity INT,
        Order_Date DATE,
        Total_Amount DECIMAL(10, 2),
        CATEGORY NVARCHAR(50)
    );

    INSERT INTO @TempOrders
    EXEC spPagination @PageNumber, @RowsOfPage

    WHILE Exists(SELECT 1 FROM @TempOrders)
    BEGIN
        INSERT INTO OrderSummary (Order_ID, Customer_Name, Product, Quantity, Total_Amount, Order_Date, CATEGORY)
        SELECT
            Order_ID,
            Customer_Name,
            Product,
            Quantity,
            Total_Amount,
            Order_Date,
            CATEGORY
        FROM @TempOrders;

        DELETE FROM @TempOrders;

        SET @PageNumber = @PageNumber + 1;

        INSERT INTO @TempOrders
        EXEC spPagination @PageNumber, @RowsOfPage
    END;
END
go

Exec spMergeOrderSummary_TableVariable

select * from OrderSummary
go
select * from Orders;