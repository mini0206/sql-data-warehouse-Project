/*
===============================================================================
Procedure:      bronze.load_bronze
Description:    Loads raw CRM and ERP data from CSV files into the Bronze layer.

Purpose:
    - Perform a full refresh of Bronze layer tables.
    - Truncate existing data before loading.
    - Load source data using BULK INSERT.
    - Track loaded row counts and load duration.
    - Provide execution status and error messages.

Source Systems:
    - CRM
    - ERP

Target Schema:
    - bronze

Load Type:
    - Full Refresh

Error Handling:
    - TRY...CATCH

===============================================================================
*/
USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        DECLARE 
            @batch_start_time DATETIME,
            @batch_end_time   DATETIME,
            @start_time       DATETIME,
            @end_time         DATETIME,
            @rows_loaded      INT;

        SET @batch_start_time = GETDATE();

        PRINT '============================================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '============================================================================';

        -- ============================================================================
        -- CRM Tables
        -- ============================================================================

        PRINT '---------------------------------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------------------------------------';

        -- CRM Customer Information
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT 'Loading data into table: crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- CRM Product Information
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT 'Loading data into table: crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- CRM Sales Details
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT 'Loading data into table: crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- ============================================================================
        -- ERP Tables
        -- ============================================================================

        PRINT '---------------------------------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '---------------------------------------------------------------------------';

        -- ERP Customer Information
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT 'Loading data into table: erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- ERP Location Information
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT 'Loading data into table: erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- ERP Product Category Information
        SET @start_time = GETDATE();

        PRINT 'Truncating the table: erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT 'Loading data into table: erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'D:\mini docs\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @rows_loaded = @@ROWCOUNT;
        SET @end_time = GETDATE();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds | Loaded rows: '
            + CAST(@rows_loaded AS NVARCHAR(20));

        PRINT '>> ------------------------------------------------------------------------------------------------------';


        -- ============================================================================
        -- Completion Message
        -- ============================================================================

        SET @batch_end_time = GETDATE();

        PRINT '============================================================================';
        PRINT 'Bronze Layer Loading Completed Successfully in '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(20))
            + ' seconds.';
        PRINT '============================================================================';

    END TRY

    BEGIN CATCH

        PRINT '============================================================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT '============================================================================';

    END CATCH;
END;
GO
