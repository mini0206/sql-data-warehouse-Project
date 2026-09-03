/*
================================================================================
Project:       Data Warehouse
Layer:         Gold
Script:        Create Gold Views
Description:   Creates dimension and fact views for the Gold layer.

Gold Layer Views:
    1. gold.dim_customers
    2. gold.dim_products
    3. gold.fact_sales

Purpose:
    - Provide business-friendly column names.
    - Organize columns in a logical sequence.
    - Create surrogate keys for dimension tables.
    - Connect fact tables to dimension tables using surrogate keys.

Surrogate Key:
    A system-generated unique identifier assigned to each record in a
    dimension table.

Surrogate Key Generation Methods:
    1. DDL-based generation (e.g., IDENTITY).
    2. Window function-based generation (e.g., ROW_NUMBER()).

Notes:
    - Surrogate keys are used to establish relationships between fact
      and dimension tables.
    - Historical product records are filtered out from the product
      dimension by keeping only the current records.
    - Fact tables use surrogate keys from dimension tables instead of
      relying directly on source system IDs.

================================================================================
*/


USE DataWarehouse;
GO


/*==============================================================================
  1. DIMENSION: CUSTOMERS
==============================================================================

Purpose:
    Creates the customer dimension by combining customer master data with
    additional customer attributes such as gender, birthdate, and country.

Surrogate Key:
    customer_key is generated using ROW_NUMBER() and acts as the surrogate
    key for the customer dimension.

==============================================================================*/

CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_material_status AS marital_status,

    -- Use CRM gender when available; otherwise use ERP gender.
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO


/*==============================================================================
  2. DIMENSION: PRODUCTS
==============================================================================

Purpose:
    Creates the product dimension by combining product master data with
    product category information.

Business Rule:
    Only the current version of each product is included in the Gold layer.
    Historical product records are excluded by filtering prd_end_dt IS NULL.

Surrogate Key:
    product_key is generated using ROW_NUMBER() and acts as the surrogate
    key for the product dimension.

==============================================================================*/

CREATE OR ALTER VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY pn.prd_start_dt, pn.prd_id
    ) AS product_key,

    pn.prd_id AS product_id,
    pn.cat_id AS category_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pn

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id

-- Exclude historical product records.
WHERE pn.prd_end_dt IS NULL;
GO


/*==============================================================================
  3. FACT: SALES
==============================================================================

Purpose:
    Creates the sales fact view by combining sales transactions with
    surrogate keys from the customer and product dimensions.

Data Warehouse Design:
    Fact tables should reference dimension tables using surrogate keys
    rather than source-system identifiers.

Lookup Logic:
    - Product surrogate key is retrieved by matching sls_prd_key with
      product_number in gold.dim_products.
    - Customer surrogate key is retrieved by matching sls_cust_id with
      customer_id in gold.dim_customers.

This allows the fact table to establish relationships with the dimensions
using the surrogate keys.

==============================================================================*/

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,

    -- Surrogate key from the product dimension.
    pr.product_key,

    -- Surrogate key from the customer dimension.
    cu.customer_key,

    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS sales_quantity,
    sd.sls_price AS price

FROM silver.crm_sales_details AS sd

-- Lookup product surrogate key.
LEFT JOIN gold.dim_products AS pr
    ON sd.sls_prd_key = pr.product_number

-- Lookup customer surrogate key.
LEFT JOIN gold.dim_customers AS cu
    ON sd.sls_cust_id = cu.customer_id;
GO
