
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
  3. Run the script.  
  4. 
  
## What happens 
  1. When 01-UpdateADFJsonTemplateFiles.ps1 runs you'll see 3 additional json files created.  These will be used when running 2nd script.  
  2. When 02-CreateNewADFResources.ps1 runs you may get a prompt to overlay an existing component.  Choose yes if so.  
  
  
