	CREATE MATERIALIZED VIEW mv_Role  
	WITH (distribution = hash(UserID), FOR_APPEND)  
	AS
	SELECT MAX(UserID) 
	from AppUser u join AppRole r on u.UserID = r.RoleID
	GROUP BY r.RoleiD

/*
  all object must start with schema name
  schema.table.column or schema.table etc.
*/
CREATE VIEW vw_Role
WITH SCHEMABINDING
AS
	SELECT dbo.AppUser.UserID, dbo.AppUser.UserName, 
	      dbo.AppRole.RoleID, dbo.AppRole.RoleName 
	from dbo.AppUser join dbo.AppRole on dbo.AppUser.UserID = dbo.AppRole.RoleID

CREATE UNIQUE CLUSTERED INDEX IX_vw_Role
ON vw_Role	(UserName, RoleName);

	select * from AppUser

	select * from AppRole