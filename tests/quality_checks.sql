-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--                                             HERE DATA EXPLORATION AND CLEANING AND QUALITY CHECKS
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM datawarehouse.crm_cust_info;
SELECT * FROM datawarehouse.crm_sales_details;
SELECT * FROM datawarehouse.crm_prd_info;

-- --------------------------FOR silver_crm_cust_info TABLE-----------------------------------
-- duplicate cust_id which is wrong
SELECT 
 cst_id,
 COUNT(*) AS numm
FROM `silver_crm_cust_info`
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- removing duplicate cst_id and keeping latest data
SELECT
* FROM (
SELECT 
*,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY `cst_create_date`) AS flag_last
FROM `silver_crm_cust_info`)t HAVING flag_last = 1;

-- checking if there is any space in name
SELECT 
 cst_firstname
FROM silver_crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
 cst_lastname
FROM silver_crm_cust_info
WHERE cst_firstname != TRIM( cst_lastname);

-- checking distinct 
SELECT DISTINCT cst_gndr
FROM silver_crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM silver_crm_cust_info;


-- --------------------------FOR bronze_crm_prd_info TABLE-----------------------------------
SELECT 
 `prd_id`,
 COUNT(*) AS numm
FROM `bronze_crm_prd_info`
GROUP BY cst_id
HAVING COUNT(*) > 1;

SELECT 
 `prd_nm`
FROM bronze_crm_prd_info
WHERE `prd_nm` != TRIM(`prd_nm`);

SELECT prd_id FROM bronze_crm_prd_info WHERE `prd_end_dt` < `prd_start_dt`;


-- --------------------------FOR `bronze_crm_sales_details` TABLE-----------------------------------  

-- checking invalid dates
SELECT 
`sls_due_dt`
FROM bronze_crm_sales_details
WHERE `sls_due_dt` <=0 OR LENGTH(`sls_due_dt`) != 8;

-- checking invalid dates
SELECT 
 *
FROM bronze_crm_sales_details
WHERE `sls_order_dt` > `sls_ship_dt`OR `sls_order_dt` > `sls_due_dt`;

-- checking consistency in sales quantity and price

SELECT DISTINCT
  sls_price AS old_price,
  sls_quantity ,
  sls_sales AS old_sales,
  CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity *  ABS(sls_price) 
       THEN sls_quantity *  ABS(sls_price) 
       END AS sls_sales,
 CASE WHEN sls_price IS NULL OR sls_price <= 0
 THEN ROUND(sls_sales / NULLIF(sls_quantity,0),0)
 END AS sls_quantity
FROM bronze_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR 
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0;
 
 
-- --------------------------FOR ``bronze_erp_loc_a101`` TABLE-----------------------------------  

SELECT 
 REPLACE(cid,'-','') AS cid 
 FROM `bronze_erp_loc_a101`;
 
-- checking invalid country 
 SELECT DISTINCT 
 cntry 
 FROM `bronze_erp_loc_a101`;
 
 
SELECT DISTINCT
 CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
      WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
      WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
      ELSE trim(cntry)
	END AS cntry
    FROM bronze_erp_loc_a101;


-- --------------------------FOR ``bronze_erp_px_cat_g1v2`` TABLE-----------------------------------      
    SELECT DISTINCT 
     maintenance
     FROM bronze_erp_px_cat_g1v2
     WHERE maintenance IS NULL;
     
     
     -- gold layer 

SELECT DISTINCT
 ci.cst_gndr,
 ca.gen,
 CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
      ELSE COALESCE(ca.gen,'n/a')
END AS new_gen
FROM `silver_crm_cust_info` ci 
LEFT JOIN `silver_erp_cust_az12` ca ON ci.cst_key = ca.cid
LEFT JOIN `silver_erp_loc_a101` la ON ci.cst_key = la.cid

