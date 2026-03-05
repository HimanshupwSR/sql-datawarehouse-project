-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--                                             HERE INSERTION OF CLEAN DATA FROM BRONZE LAYER TO SILVER LAYER
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

-- clean data (`bronze_crm_cust_info`) for silver layer 

TRUNCATE TABLE silver_crm_cust_info;
INSERT INTO silver_crm_cust_info
SELECT 
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        ELSE 'N/A'
    END AS cst_gndr,
    CASE 
        WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
        WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
        ELSE 'N/A'
    END AS cst_marital_status,
    cst_create_date,
	CURRENT_DATE() AS  dwh_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id 
               ORDER BY cst_create_date DESC
           ) AS flag_last
    FROM `bronze_crm_cust_info`
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;

-- clean data (`bronze_crm_prd_info`) for silver layer 

TRUNCATE TABLE silver_crm_prd_info;
INSERT INTO silver_crm_prd_info
SELECT 
   prd_id,
   REPLACE(substring(prd_key,1,5),'-','_') AS cat_id,
   substring(prd_key,7,LENGTH(prd_key)) AS prd_key,
   prd_nm,
   ifnull(prd_cost,0) AS prd_cost,
   CASE UPPER(`prd_line`)
         WHEN 's' THEN 'Other sales'
		 WHEN  'R' THEN 'Road'
         WHEN 'T' THEN 'Touring'
         WHEN 'M' THEN 'Mountain'
         ELSE 'N/A'
   END AS prd_line
   ,
   CAST(prd_start_dt AS DATE) AS prd_start_dt,
  CAST( DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY) AS DATE) AS prd_end_dt ,
  CURRENT_DATE() AS  dwh_create_date
FROM `bronze_crm_prd_info`;
SELECT * FROM silver_crm_prd_info;


-- clean data (`bronze_crm_sales_details`) for silver layer 
TRUNCATE TABLE silver_crm_sales_details;
INSERT INTO `silver_crm_sales_details`
SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN `sls_order_dt` = 0 OR LENGTH(`sls_order_dt`) != 8  THEN  null
			 ELSE CAST(sls_order_dt AS DATE)
		END AS sls_order_dt,
		CASE WHEN `sls_ship_dt` = 0 OR LENGTH(`sls_ship_dt`) != 8  THEN  null
			 ELSE CAST(sls_ship_dt AS DATE)
		END AS sls_ship_dt,
		 CASE WHEN `sls_due_dt` = 0 OR LENGTH(`sls_due_dt`) != 8  THEN  null
			 ELSE CAST(sls_due_dt AS DATE)
		END AS sls_due_dt,
		 CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity *  ABS(sls_price) 
		   THEN sls_quantity *  ABS(sls_price) 
		   ELSE sls_sales
		   END AS sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0
	 THEN sls_sales / NULLIF(sls_quantity,0)
	 ELSE sls_price
	 END AS sls_price,
	 CURRENT_DATE() AS  dwh_create_date
FROM bronze_crm_sales_details;

SELECT * FROM silver_crm_sales_details;


-- clean data (``bronze_erp_cust_az12``) for silver layer 
TRUNCATE TABLE silver_erp_cust_az12;
INSERT INTO silver_erp_cust_az12
SELECT 
	 CASE WHEN cid LIKE'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
	  ELSE cid
	 END AS cid,
 CASE WHEN bdate >= CURRENT_DATE THEN NULL
     ELSE bdate
     END AS bdate
 ,
CASE WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
     WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
     ELSE 'n/a'
END AS gen,
 CURRENT_DATE() AS  dwh_create_date
 FROM `bronze_erp_cust_az12`;


-- clean data (```bronze_erp_loc_a101```) for silver layer 
TRUNCATE TABLE silver_erp_loc_a101; 
INSERT INTO silver_erp_loc_a101
SELECT 
  REPLACE(cid,'-','') AS cid ,
   CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
      WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
      WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
      ELSE trim(cntry)
   END AS cntry,
CURRENT_DATE() AS  dwh_create_date
FROM bronze_erp_loc_a101;
 
 -- clean data (````bronze_erp_px_cat_g1v2````) for silver layer  
 TRUNCATE TABLE silver_erp_px_cat_g1v2; 
 INSERT INTO silver_erp_px_cat_g1v2
 SELECT 
 id,
 cat,
 subcat,
 maintenance,
 CURRENT_DATE() AS  dwh_create_date
FROM `bronze_erp_px_cat_g1v2`
-- SELECT * FROM silver_erp_px_cat_g1v2


 
 
