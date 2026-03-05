-- ------------------------------------------------------------------------------------------------------------------------------------------------------
--                                             HERE LOADING OF DATA INTO TABLES 
-- ------------------------------------------------------------------------------------------------------------------------------------------------------

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- repeat for other tables


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname,
 @cst_marital_status, @cst_gndr, @cst_create_date)
SET 
cst_id = NULLIF(TRIM(@cst_id), ''),
cst_key = NULLIF(TRIM(@cst_key), ''),
cst_firstname = NULLIF(TRIM(@cst_firstname), ''),
cst_lastname = NULLIF(TRIM(@cst_lastname), ''),
cst_marital_status = NULLIF(TRIM(@cst_marital_status), ''),
cst_gndr = NULLIF(TRIM(@cst_gndr), ''),
cst_create_date = STR_TO_DATE(NULLIF(TRIM(@cst_create_date), ''), '%Y-%m-%d');

-- ==============================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET
prd_id       = NULLIF(TRIM(@prd_id), ''),
prd_key      = NULLIF(TRIM(@prd_key), ''),
prd_nm       = NULLIF(TRIM(@prd_nm), ''),
prd_cost     = NULLIF(TRIM(@prd_cost), ''),
prd_line     = NULLIF(TRIM(@prd_line), ''),
prd_start_dt = STR_TO_DATE(NULLIF(TRIM(@prd_start_dt), ''), '%Y-%m-%d %H:%i:%s'),
prd_end_dt   = STR_TO_DATE(NULLIF(TRIM(@prd_end_dt), ''), '%Y-%m-%d %H:%i:%s');


-- ==============================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id,
 @sls_order_dt, @sls_ship_dt, @sls_due_dt,
 @sls_sales, @sls_quantity, @sls_price)
SET
sls_ord_num  = NULLIF(TRIM(@sls_ord_num), ''),
sls_prd_key  = NULLIF(TRIM(@sls_prd_key), ''),
sls_cust_id  = NULLIF(TRIM(@sls_cust_id), ''),
sls_order_dt = NULLIF(TRIM(@sls_order_dt), ''),
sls_ship_dt  = NULLIF(TRIM(@sls_ship_dt), ''),
sls_due_dt   = NULLIF(TRIM(@sls_due_dt), ''),
sls_sales    = NULLIF(TRIM(@sls_sales), ''),
sls_quantity = NULLIF(TRIM(@sls_quantity), ''),
sls_price    = NULLIF(TRIM(@sls_price), '');

-- ERM TABELS
-- ===========================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET
cid   = NULLIF(TRIM(@cid), ''),
bdate = STR_TO_DATE(NULLIF(TRIM(@bdate), ''), '%Y-%m-%d'),
gen   = NULLIF(TRIM(@gen), '');


-- ===========================================================


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET
cid   = NULLIF(TRIM(@cid), ''),
cntry = NULLIF(TRIM(@cntry), '');

-- ===========================================================

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@id, @cat, @subcat, @maintenance)
SET
id          = NULLIF(TRIM(@id), ''),
cat         = NULLIF(TRIM(@cat), ''),
subcat      = NULLIF(TRIM(@subcat), ''),
maintenance = NULLIF(TRIM(@maintenance), '');
