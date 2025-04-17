--XACT_STATE() is a scalar function in SQL Server that reports the state of the current transaction. 
--It is particularly useful in TRY...CATCH blocks to determine whether a transaction can be committed or needs to be rolled back.

--Return Values:
-- 1: The transaction is active and can be committed.

-- 0: There is no active transaction.

-- -1: The transaction is active but in an uncommittable state (e.g., due to an error).

BEGIN TRANSACTION;

BEGIN TRY
    -- Savepoint 1
    SAVE TRANSACTION Savepoint1;
    INSERT INTO AppRole VALUES (1, 'Admin');

    -- Savepoint 2
    SAVE TRANSACTION Savepoint2;
    INSERT INTO AppUser (1) VALUES (1, 'naresh');

    -- Savepoint 3
    SAVE TRANSACTION Savepoint3;
    INSERT INTO AppUserRoleMapping VALUES (1, 1);

    -- Commit the transaction if all operations succeed
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Check the transaction state
    IF XACT_STATE() = -1
    BEGIN
        PRINT 'Error occurred. Rolling back entire transaction.';
        ROLLBACK TRANSACTION;
    END
    ELSE IF XACT_STATE() = 1
    BEGIN
        PRINT 'Error occurred. Rolling back to the last savepoint.';
        ROLLBACK TRANSACTION Savepoint3; -- Adjust based on where the error occurred
    END

  SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_LINE() AS ErrorLine,
        ERROR_PROCEDURE() AS ErrorProcedure;
END CATCH;