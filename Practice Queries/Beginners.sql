/*
  Created By : Suraj Kumar Sah
  Date : 16-04-2025
  Desc : Beginners level queries
*/

CREATE DATABASE Practice
GO

USE Practice;
GO

CREATE SCHEMA PC;
GO

CREATE TABLE PC.[Employee]
(
  ID INT PRIMARY KEY,
  [Name] VARCHAR(100),
  Department VARCHAR(100),
  Salary DECIMAL(10, 6),
  Joining_Date DATETIME
);

-- Creating User Defined Table Type
CREATE TYPE EmployeeType AS TABLE (
    ID INT,
    [Name] VARCHAR(100),
    Department VARCHAR(100),
    Salary DECIMAL(10, 6),
    Joining_Date DATETIME
);

-- Stored Procedure to insert data into the Employee table
CREATE proc Proc_InsertEmployee
  @Employee EmployeeType READONLY
AS
BEGIN
  DECLARE @ID INT = 1;
  DECLARE @Name VARCHAR(100);
  DECLARE @Department VARCHAR(100);
  DECLARE @Salary DECIMAL(10, 6);
  DECLARE @Joining_Date DATETIME;    

	-- Loop through the table variable and INSERT INTO the Employee table
    while @ID<=(SELECT COUNT(*) FROM @Employee)
	begin
	  SELECT @Name = [Name],
	         @Department = Department,
			 @Salary = Salary,
			 @Joining_Date = Joining_Date
	  FROM @Employee
	  WHERE ID=@ID;

	  --Inserting the Data into the Employee Table
	  INSERT INTO PC.[Employee] (ID, [Name], Department, Salary, Joining_Date) VALUES (@ID, @Name, @Department, @Salary, @Joining_Date);

	-- Increasing the ID
	  SET @ID = @ID + 1
    END
END;

-- DECLARE a table variable to hold the employee data
DECLARE @EmployeeData EmployeeType;

INSERT INTO @EmployeeData (ID, [Name], Department, Salary, Joining_Date)
VALUES
    (1, 'Rajesh', 'IT', 5000.00, '2020-01-10'),
    (2, 'Sneha', 'HR', 4500.00, '2019-04-12'),
    (3, 'Kiran', 'Finance', 5200.00, '2021-08-23'),
    (4, 'Priya', 'Marketing', 4800.00, '2018-06-15'),
    (5, 'Arjun', 'IT', 5300.00, '2022-09-19');

EXEC Proc_InsertEmployee @Employee = @EmployeeData;

SELECT * FROM PC.[Employee]
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
/*
  Questions to Practice
*/

-- 1. Retrieve all columns FROM the Employees table.
SELECT * FROM PC.[Employee]


-- 2. SELECT only the Name and Salary of each employee.
SELECT [Name], Salary FROM PC.[Employee]


-- 3. Find employees who work in the IT department.
SELECT * FROM PC.[Employee] WHERE Department = 'IT';


-- 4. Retrieve employees with a Salary greater than 50000.
SELECT * FROM PC.[Employee] WHERE Salary > 5000;


-- 5. Display employee names in alphabetical order.
SELECT [Name] FROM PC.[Employee] ORDER BY [Name];


-- 6. Count the total number of employees in the Employees table.
SELECT count(*) AS NoOfEmployees FROM PC.[Employee]


-- 7. Find employees who joined before 2021.
SELECT * FROM PC.[Employee] WHERE Joining_Date < '2021-01-01';


-- 8. Show distinct departments in the Employees table.
SELECT distinct Department FROM PC.[Employee];


-- 9. Retrieve the top 3 highest-paid employees.
SELECT distinct top 3 * FROM PC.[Employee] ORDER BY salary desc;


-- 10. Calculate the average salary of employees.
SELECT avg(salary) AS AvgSalary FROM PC.[Employee];


-- 11. List employees in the Finance or Marketing department.
SELECT * FROM PC.[Employee] WHERE Department IN ('Finance', 'Marketing');


-- 12. Show employees whose names start with 'S'.
SELECT * FROM PC.[Employee] WHERE [Name] Like 'S%';


-- 13. Find employees with a Salary BETWEEN 45000 and 52000.
SELECT * FROM PC.[Employee] WHERE salary BETWEEN 4500 and 5200;


-- 14. Display employees who do not belong to the HR department.
SELECT * FROM PC.[Employee] WHERE Department <> 'HR';


-- 15. Count employees in each department.
SELECT Department, count(*) FROM PC.[Employee] GROUP BY department;


-- 16. Retrieve the minimum salary in the table.
SELECT MIN(salary) AS MinSalary FROM PC.[Employee];


-- 17. Show employees who joined in 2020 or later.
SELECT * FROM PC.[Employee]
WHERE Joining_Date >= '2020-01-01';


-- 18. List employees ordered by Joining_Date in descending order.
SELECT * FROM PC.[Employee] ORDER BY Joining_Date desc;


-- 19. Retrieve employees whose salary is not equal to 5000.
SELECT * FROM PC.[Employee] WHERE Salary <> 5000;


-- 20. Calculate the sum of all employees' salaries.
SELECT SUM(Salary) TotalSalary FROM PC.[Employee];


-- 21. Find employees in the IT department earning more than 50000.
SELECT * FROM PC.[Employee] WHERE Department = 'IT' AND salary > 5000;


-- 22. Show the maximum salary in the Marketing department.
SELECT MAX(Salary) as 'MaxSalary' FROM PC.[Employee]
 WHERE Department = 'Marketing';


-- 23. List employees who joined in the month of September.
SELECT * FROM PC.[Employee] WHERE month(Joining_Date) = 9;


-- 24. Display employee details by grouping them by department.
SELECT Department, COUNT(*) NoOfEmployees FROM PC.[Employee] GROUP BY Department;


-- 25. Retrieve the last 2 entries in the Employees table.
SELECT top 2 * FROM PC.[Employee] ORDER BY ID desc;


-- 26. SELECT employees with names ending in 'a'.
SELECT * FROM PC.[Employee] WHERE [Name] like '%a';


-- 27. List employees with a salary that is a multiple of 5000.
SELECT * FROM PC.[Employee] WHERE Salary % 500 = 0;


-- 28. Show the employee with the earliest Joining_Date.
SELECT top 1 * FROM PC.[Employee] ORDER BY Joining_Date ASC;

SELECT * FROM PC.[Employee] WHERE Joining_Date = (SELECT MIN(Joining_Date) FROM PC.[Employee]);


-- 29. Update the salary of 'Rajesh' to 55000.
update PC.[Employee] set Salary = 5500 WHERE [Name] = 'Rajesh';


-- 30. Delete an entry WHERE the Department is 'HR'.
DELETE FROM PC.[Employee] WHERE Department = (SELECT top 1 Department FROM PC.[Employee] WHERE Department = 'HR');

/*
 Webiste Link : https://www.placementpreparation.io/programming-exercises/sql/beginners/
*/