/*
================================================================================
Silver Layer - Table Creation Script
================================================================================
Purpose:
    Creates the Silver layer tables used to store raw data from CRM and ERP
    source systems.

The Silver layer acts as the initial landing/staging layer of the DataWarehouse.
Data is stored in its raw form with minimal transformation.

Source Systems:
    CRM - Customer Relationship Management data
    ERP - Enterprise Resource Planning data

Tables:
    CRM:
        - crm_cust_info
        - crm_prd_info
        - crm_sales_details

    ERP:
        - erp_loc_a101
        - erp_cust_az12
        - erp_px_cat_g1v2

Note:
    Existing tables are dropped and recreated when this script is executed.
    Any existing data in these tables will be permanently deleted.
================================================================================
*/


-- ============================================================================
-- Switch to the DataWarehouse database
-- ============================================================================
USE DataWarehouse;
GO


-- ============================================================================
-- CRM: Customer Information
-- ============================================================================
-- Stores raw customer information extracted from the CRM source system.

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================================
-- CRM: Product Information
-- ============================================================================
-- Stores raw product information extracted from the CRM source system.

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_date DATETIME,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================================
-- CRM: Sales Details
-- ============================================================================
-- Stores raw sales transaction information extracted from the CRM source
-- system, including orders, customers, products, dates, sales, quantity,
-- and price information.

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================================
-- ERP: Location Information
-- ============================================================================
-- Stores raw customer location and country information extracted from
-- the ERP source system.

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================================
-- ERP: Customer Information
-- ============================================================================
-- Stores raw customer demographic information extracted from the ERP
-- source system, including birth date and gender.

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- ============================================================================
-- ERP: Product Category Information
-- ============================================================================
-- Stores raw product category, subcategory, and maintenance information
-- extracted from the ERP source system.

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
