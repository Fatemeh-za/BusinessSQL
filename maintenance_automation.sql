USE Northwind;
GO

-- Prevent Unauthorized Deletions (Triggers)
CREATE TRIGGER PreventOrderDeletion
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    THROW 50000, 'Order deletions are not allowed!', 1;
END;
GO

-- Create a stored procedure for low stock alerts
CREATE PROCEDURE LowStockAlert
AS
BEGIN
    INSERT INTO InventoryAlerts (ProductID, AlertMessage)
    SELECT 
        ProductID, 
        CONCAT(ProductName, ' is running low!')
    FROM 
        Products
    WHERE 
        UnitsInStock < ReorderLevel;
END;
GO

-- Create a SQL Server Agent job to automate low stock alerts
USE msdb;
GO

-- Create a new job
EXEC sp_add_job 
    @job_name = N'LowStockAlertJob';

-- Add a step to the job to run the stored procedure
EXEC sp_add_jobstep 
    @job_name = N'LowStockAlertJob',
    @step_name = N'Execute LowStockAlert',
    @subsystem = N'TSQL',
    @command = N'EXEC Northwind.dbo.LowStockAlert',
    @database_name = N'Northwind';

-- Schedule the job to run every day
EXEC sp_add_jobschedule 
    @job_name = N'LowStockAlertJob',
    @name = N'DailySchedule',
    @freq_type = 4, -- Daily
    @freq_interval = 1, -- Every 1 day
    @active_start_time = 0000; -- Midnight

-- Enable the job
EXEC sp_add_jobserver 
    @job_name = N'LowStockAlertJob',
    @server_name = N'(local)';
GO
