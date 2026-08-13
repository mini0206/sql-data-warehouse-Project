
/*
================================================================================
Database Creation Script
================================================================================
Purpose:
    Creates the DataWarehouse database and its schemas.

Schemas:
    bronze  - Stores raw data loaded from source systems.
    silver  - Stores cleaned and transformed data.
    gold    - Stores business-ready data for reporting and analytics.

Note:
    This script drops and recreates the DataWarehouse database if it already
    exists. Any existing data will be permanently deleted.
================================================================================
*/

-- ============================================================================
-- Switch to the master database
-- ============================================================================
USE master;
GO
-- ============================================================================
-- Drop the DataWarehouse database if it already exists
-- ============================================================================
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN
    -- Set the database to SINGLE_USER mode and terminate existing connections
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    -- Drop the existing database
    DROP DATABASE DataWarehouse;
END;
GO
-- ============================================================================
-- Create the DataWarehouse database
-- ============================================================================
CREATE DATABASE DataWarehouse;
GO
-- Switch to the newly created DataWarehouse database
USE DataWarehouse;
GO
-- ============================================================================
-- Create Data Warehouse schemas
-- ============================================================================

-- Bronze: Raw data loaded from source systems with minimal transformation
CREATE SCHEMA bronze;
GO
  
-- Silver: Cleaned, validated, and transformed data
CREATE SCHEMA silver;
GO

-- Gold: Business-ready data used for reporting and analytics
CREATE SCHEMA gold;
GO
