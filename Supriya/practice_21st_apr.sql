select * from Orders
select * from ProductSummary

select * from Employees

--1.identify tp 3 customers based on total spendings
select top 3 * from Orders order by Total_Amount desc 

--2.identify custmers whose total spending exceeds 10000
select Customer_Name from Orders where Total_Amount > 10000

--3.identify products that have been ordered more than 3 times
select Product , count(Order_ID) no_of_orders from Orders group by Product having count(Order_ID) > 3

--4.calculate the total revenue generated for each month
select sum(Total_Amount) revenue , dateName(month,Order_Date) [month] from Orders 
group by dateName(month,Order_Date) 


--5.find customes who have placed products more than once from same category but in different date  
select Customer_Name, CATEGORY, count(distinct Order_Date) no_of_orders from  Orders group by Customer_Name, CATEGORY having count(*) > 1 

