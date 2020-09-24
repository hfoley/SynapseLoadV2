
# 03 SQL Scripts
This folder contains MetadataTablesCreate.sql and a Sample subfolder.  The MetadataTablesCreate.sql script will create 2 metadata tables and statements to insert data into them.  

## Asset List - These items will be created 
	1. ADF schema - can change based on your naming conventions
	2. [ADF].[ExtractTables] - table that drives the SQL Date Based Extract pipeline and dictates which SQL Server tables are extracted and what timeframe to extract
	3. [ADF].[MetadataLoad] - table that drives the other 2 ADF pipelines to load which parquet files and what tables to load them into within the Synapse sql pool 
  	4. Optional sample scripts - there are sample source and target tables 

	
## Steps 
  1. Connect to your Azure SQL database that will house the metadata tables and open MetadataTablesCreate.sql.  
  2. Edit the script's insert statements to load the metadata tables based on your environment. 
  3. Run the script and validate tables are loaded with expected values. 
  4. Go into Azure Data Factory and run SQL Date Based Extract pipeline and verify successful. 
  5. Validate the parquet file is extracted and landed in ADLS location as expected. 
  6. Go into Azure Data Factory and run either Synapse Load * pipelines based on metadata table values provided.  The parameter you pass the pipeline is the FileName value contained in [ADF].[MetadataLoad] table.  
  7. Connect to the Synapse SQL pool and validate the parquet files are loaded into the target tables appropriately.  
  

  
