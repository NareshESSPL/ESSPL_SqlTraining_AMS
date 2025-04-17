/**
1. Update the Total_Amount in the Orders table based on a discount stored in another table (Discounts)

**/

 update O
 set O.Total_Amount=(O.Total_Amount-O.Total_Amount*isnull(D.Discount_Percentage,0)/100)
 from [dbo].[Orders] O left join [dbo].[Discounts] D on O.Product=D.Product ; 


 /**
 2. Delete orders placed by customers who have placed more than 5 orders
 **/
 select * from [dbo].[Orders]
 select * from [dbo].[Orders] O   group by Customer_Name having Count(Quantity) > 5;

 delete  from  [dbo].[Orders]
 where Customer_Name in ( 
 select Customer_Name from [dbo].[Orders] group by Customer_Name having count(Quantity)>=5);

 select * from  [dbo].[Orders]
 where Customer_Name in ( 
 select Customer_Name from [dbo].[Orders]  where  Quantity>5);



 /**
   3. Insert records into a TopOrders table for orders exceeding a total amount of ₹50,000:
 **/
create table TopOrders
 (
  Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)

 )


insert into TopOrders(Order_ID,
Customer_Name ,
    Product ,
    Quantity ,
    Order_Date ,
    Total_Amount ,
    CATEGORY)
 select * from [dbo].[Orders] where Total_Amount > 50000;

 select * from  TopOrders



/**
4.Conditional Insert with a CASE Statement  insert into ProductSummary table where Category columns will have two type values one is 'Premium' where Total_Amount > 50000 and Economy  where EconomyTotal_Amount between 2000 and 50000

**/
 select *, case when O.Total_Amount >50000 then 'Premium'
                when O.Total_Amount > 2000 and O.Total_Amount<50000 then 'Economy'
				else 'Others'
                end
				 as Suite_Category
				 into ProductSummary from [dbo].[Orders] O ;

select * from ProductSummary
drop table ProductSummary

--------------------------------------------------------------------------

create table OrderSummary
(
 Order_ID INT PRIMARY KEY,
    Customer_Name NVARCHAR(50),
    Product NVARCHAR(50),
    Quantity INT,
    Order_Date DATE,
    Total_Amount DECIMAL(10, 2),
    CATEGORY NVARCHAR(50)

)


merge OrderSummary OS
 using [dbo].[Orders] O on O.Order_ID=OS.Order_ID
 
 WHEN MATCHED
    THEN UPDATE SET 
        OS.Customer_Name = O.Customer_Name + ' Kumar'

when not matched  by target
then insert (Order_ID,
    Customer_Name ,
    Product ,
    Quantity,
    Order_Date,
    Total_Amount ,
    CATEGORY )
	values (O.Order_ID,O.Customer_Name,O.Product,O.Quantity,O.Order_Date,O.Total_Amount,O.CATEGORY)

when not matched by source 
then delete;

select * from OrderSummary


/**
 
 5.Update the CATEGORY in the Orders table based on the average Total_Amount
   TIP: We cannot use aggregate functions inside Update Query .
 **/

 update Orders
 set CATEGORY=
  case 
     when [Total_Amount] > (select avg(Total_Amount) from [dbo].[Orders] ) then 'High value'
	 else 'Low Value'
  end

  --- In column operations subqueries should be avoided for better optimization.




  declare @avg_bal decimal(10,6)
  set @avg_bal=(select avg(Total_Amount) from Orders)

   update Orders
   set CATEGORY=
    case 
	  when Total_Amount > @avg_bal  then 'High'
	  else 'Low'
  end
  

  select * from [dbo].[Orders]

/**
--------------Write a function to take 102298761111 and return 11********111


**/

create function Mask
(
   @Input varchar(10)
)
returns varchar(10)
as
begin
    
 return left(@Input,2)+replicate('1',len(@Input)-5)+right(@Input,3)

 end

 print dbo.Mask('123456789') 

 ----we cannot update the list accepted as input in a function 

 /**

 8.8.Remove duplicate orders where all attributes are identical:
    ordering by product.
	Use : dense_rank to assign group nos
 **/

 ;with cte_RemveDuplicate
 as(
 select *, ROW_NUMBER() over (partition by Product ,Quantity order by Order_ID) as rt

 from [dbo].[Orders]
 )
 delete from [dbo].[Orders]
 where Order_ID in (select Order_ID from cte_RemveDuplicate where rt > 1);


 select * from [dbo].[Orders]
 where Order_ID in (select Order_ID from cte_RemveDuplicate where rt > 1);


 
  select * from cte_RemveDuplicate
  select * from [dbo].[Orders]

  


    