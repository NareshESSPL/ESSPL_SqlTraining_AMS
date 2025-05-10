CREATE TABLE [Emp] (
    [EmpId] INT NOT NULL IDENTITY(1, 1),
    [Name] VARCHAR(255) NULL,
    [DeptId] INT NULL,
    [Salary] INT NULL,
    PRIMARY KEY ([EmpID])
);
GO
TRUNCATE TABLE [Emp]
INSERT INTO [Emp] ([Name], DeptId, Salary)
VALUES
  ('Britanni',3,1000),
  ('Julian',2,2000),
  ('Dolan',3,3000),
  ('Jonah',4,4000),
  ('Fulton',2,5000),
  ('Scarlett',4,1000),
  ('Bernard',2,2000),
  ('Chancellor',1,3000),
  ('Dalton',4,4500),
  ('Len',1,5000),
  ('Bree',4,1000),
  ('Cooper',1,2000),
  ('Nora',4,3000),
  ('Gareth',3,4000),
  ('Beau',2,5000);  


  select *, 
   row_number() over( order by salary) as rownumber,
  rank() over( order by salary) as[rank],
   dense_rank() over( order by salary) as [denserank]
  from [dbo].[Emp]

  
  select *, 
   row_number() over(partition by DeptId order by salary) as rownumber,
         rank() over(partition by DeptId order by salary) as[rank],
   dense_rank() over( partition by DeptId order by salary) as [denserank]
  from [dbo].[Emp]
--------------------------------------------------------------------

  -----------select year ('2025-0-01')
 select * ,

   row_number() over(partition by YEAR(DOB) order by amount) as rownumber,
         rank() over(partition by YEAR(DOB) order by amount) as[rank],
   dense_rank() over( partition by YEAR(DOB) order by amount) as [denserank]
  from AMS.AccountAnalysis