/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE master;

-- Drop and recreate the 'Datawarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
 ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
 DROP DATABASE DataWarehouse;
END

-- Create the 'Datawarehouse' database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num	NVARCHAR(50),
	sls_prd_key	NVARCHAR(50),
	sls_cust_id	 INT,
	sls_order_dt INT,
	sls_ship_dt	INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)

DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid	NVARCHAR(50),
	bdate	DATE,
	gen NVARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	cid	NVARCHAR(50),
	cntry NVARCHAR(50)
);

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	id	NVARCHAR(50),
	cat	NVARCHAR(50),
	subcat	NVARCHAR(50),
	maintenance NVARCHAR(50)
);

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME,@batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=========================================================='
		PRINT'Loading Bronze Layer'
		PRINT '=========================================================='

		PRINT '-----------------------------------------------------------'
		PRINT'Loading CRM Tables'
		PRINT '-----------------------------------------------------------'

		PRINT'>>Trucating table:bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info;

		SET @start_time =GETDATE()
		PRINT'>>Inserting data Data into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		PRINT'>>Trucating table:bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;

		SET @start_time = GETDATE()
		PRINT'>>Inserting data Data into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		PRINT'>>Trucating table:bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT'>>Inserting data Data into:bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		PRINT '-----------------------------------------------------------'
		PRINT'Loading ERP Tables'
		PRINT '-----------------------------------------------------------'

		PRINT'>>Trucating table:bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12;

		SET @start_time = GETDATE()
		PRINT'>>Inserting data Data into:bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		PRINT'>>Trucating table:bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101;

		SET @start_time = GETDATE()
		PRINT'>>Inserting data Data into:bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		PRINT'>>Trucating table:bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		SET @start_time = GETDATE()
		PRINT'>>Inserting data Data into:bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\HP\Desktop\TDI\capstone\Queries\Data Warehouse\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE()
		Print'>>Load Duration:' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) +' seconds'
		PRINT'---------------------------------------------'

		SET @batch_end_time = GETDATE();

		PRINT'============================================'
		PRINT'Loading Bronze Layer is Completed'
		PRINT'Total Load Duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR)
		PRINT'============================================'
	END TRY

	BEGIN CATCH
		PRINT'=================================================='
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT'Error Message:'+ ERROR_MESSAGE();
		PRINT'Error Line' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT'Error Procedure' + ERROR_PROCEDURE();
		PRINT'Error Number' + CAST(ERROR_NUMBER()AS NVARCHAR)
		PRINT'=================================================='
		END CATCH
END

EXEC bronze.load_bronze

