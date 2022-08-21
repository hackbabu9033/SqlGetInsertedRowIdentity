Create Table T1 (id int identity(1,1))
Create Table T2 (id int identity(150,10))

-- A scope is a module: a stored procedure, trigger, function, or batch
-- so t1 and t2 are inserted row in diff scope (first one is in a batch and another is in trigger)
CREATE TRIGGER t1_insert_trigger ON T1 FOR INSERT
AS
BEGIN
  INSERT T2 DEFAULT VALUES
END;

INSERT T1 DEFAULT VALUES;
SELECT id AS T1 FROM T1;
SELECT id AS T2 FROM T2;

SELECT 
  @@IDENTITY AS [@@IDENTITY], 
  -- returns the last-inserted identity value in any table in the current session, regardless of scope.
  --(this value will be 150, since the lastest insert tale row is T2)
  SCOPE_IDENTITY() AS [SCOPE_IDENTITY()],
  --returns the last identity value inserted into an identity column in any table in the current session and current scope
  --(this value will be 1, since the current session user is dbo)
  IDENT_CURRENT('t1') AS [IDENT_CURRENT('t1')],
  -- returns the last-inserted identity value for a given table.
  IDENT_CURRENT('t2') AS [IDENT_CURRENT('t2')];

-- if create a new query then we will get
--@@IDENTITY	SCOPE_IDENTITY()	IDENT_CURRENT('t1')	IDENT_CURRENT('t2')
--  null	               null	                 1	             150

-- @@IDENTITY and SCOPE_IDENTITY() will be null since this is in another session



  
