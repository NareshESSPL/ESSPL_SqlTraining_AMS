--OuterTransaction: The main transaction.

--InnerTransaction: A nested transaction within the outer transaction.

--Commit Behavior: The inner transaction's COMMIT does not physically commit changes to the database; only the outer transaction's COMMIT does.
BEGIN TRANSACTION OuterTransaction;
PRINT @@TRANCOUNT;
    INSERT INTO AppRole VALUES (1, 'Admin');

    BEGIN TRANSACTION InnerTransaction;
	PRINT @@TRANCOUNT;
        INSERT INTO AppUser (1) VALUES (1, 'naresh');
    COMMIT TRANSACTION InnerTransaction;

COMMIT TRANSACTION OuterTransaction;
