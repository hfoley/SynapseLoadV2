# 03 Sample
This folder contains the files you'll need to create all the components for the solution including a sample source and destination.  The only file you need to update is the paramfile01.json.  All the scripts use this file to drive the names, locations, ect. to build it out in your environment.  Make sure you have rights to create resources in your Azure subscription.  You can use existing resources for this solution.  The script will check for it's existence first, before creating it.  IMPORTANT: If you create a new dedicated SQL pool, it will begin running.  Make sure to PAUSE the dedicated SQL pool when you're not using it.  HOPE WARNING: DON'T WASTE $$ in Azure on it accidentally.  

## File List - These items will be created in your Azure subscription

Filename  | Description
------------- | -------------
paramfile01.json | Parameter file that needs to be updated prior to running scripts
01 - CreateSynLoadResources.ps1  | Creates all the items in Azure subscription
02 - SynLoadGrantRights.ps1 | Will grant rights to MSI and the admin AAD account to storage
03 - CreateSynLoadPipelineParts.ps1 | Will create the pipelines and related items in Synapse workspace
LinkedServiceADLS.json | Json file for creation of the linked server pointing to ADLS Gen 2 (azstorage2 in paramfile01.json)
LinkedServiceAzureSQLDB.json | Json file tied to the creation of the linked server pointing to Azure SQL DB 
DatasetLookupMetadataExtract.json | Json file tied to creation of dataset to pull metadata for tables to extract
DatasetLookupMetadataLoad.json | Json file tied to creation of dataset to pull metadata for tables to load
DatasetSinkADLSParquetExtract.json | Json file tied to creation of dataset to land parquet files
DatasetSinkSQLLogTable.json | Json file tied to creation of dataset to the custom logging table in Azure SQL DB
DatasetSinkSynapse.json | Json file tied to creation of dataset to dedicated sql pool tables
DatasetSrcADLSFileLoad.json | Json file tied to creation of dataset to point to ADLS parquet files to load
DatasetSrcSQLTableExtract.json | Json file tied to creation of dataset for the source SQL tables
IncrePipelineCreate.json | Json file tied to the creation of the incremental pipeline  
Pipeline Truncate Load Synapse.json | Json file tied to the creation of the truncate/reload pipeline
PL SQL Date Based Extract.json | Json file tied to the creation of the date range extract pipeline
PL SQL Not Date Based Extract.json | Json file tied to the creation of the column value pull pipeline
CowBiometricsSampleSource.sql | SQL script to create a sample COW.Biometrics table to use as a source table to extract
SampleMetadataCreate.sql | SQL script to create the metadata and logging tables including insert statements
COWBiometricsSynapseTargetCreate.sql | SQL script to create the destination tables in dedicated SQL pool to load parquet files


## Azure Asset List - These items will be created in your Azure subscription
1. Azure Resource Group
2. Azure SQL Server & Database - metadata tables location 
3. 2 - Azure Data Lake Gen 2 accounts - one account for system use with Synapse, one for data lake and location to land extracted parquet files 
4. Azure Synapse Workspace - workspace where pipelines and SQL dedicated pool will live
5. Azure Synapse dedicated SQL Pool - destination to load parquet extracted files 
6. Azure SQL DB metadata tables to drive Synapse pipelines
7. Azure Synapse - SQL Date Based Extract pipeline - extracts data from SQL Server tables specified (example uses Azure SQL DB created or specified) by a date rante
8. Azure Synapse - SQL Date Not Date Based Extract pipeline - extracts data from SQL Server tables specified (example uses Azure SQL DB created or specified) by a specified value 
9. Azure Synapse - Synapse Incremental Load pipeline - parameter/metadata driven pipeline that does incremental load into Synapse SQL pool staging/target tables
10. Azure Synapse - Synapse Truncate Load pipeline - parameter/metadata driven pipeline that does truncate/reload pattern into Synapse SQL pool only target tables



## Azure SQL DB Asset List - These items will be created 
	1. ADF schema - can change based on your naming conventions
	2. [ADF].[ExtractTables] - table that drives the SQL Date Based Extract pipeline and dictates which SQL Server tables are extracted and what timeframe to extract
	3. [ADF].[MetadataLoad] - table that drives the other 2 ADF pipelines to load which parquet files and what tables to load them into within the Synapse sql pool 
  	4. [ADF].[PipelineLog] - table to capture metadata and parameter values from pipeline runs. 
	5. [COW].[Biometrics] - sample source table 
		
## Azure Synapse Dedicated SQL Pool Asset List - These items will be created 
	1. COW schema - can change based on your naming conventions
	2. [COW].[Biometrics] - final destination table to load parquet files into in SQL dedicated pool
	3. [COW].[Biometrics_Stg] - staging destination table to load parquet files for use with incremental load pattern 


## Steps 
1. Download all the files locally or to storage account fileshare used for CLI (see https://hopefoley.com/2021/09/27/powershell-in-the-clouds/ for help setting up).  Keep all the files in one folder location.   
1. Update the paramfile01.json with the values you want to use for the rest of the scripts.  Storage is finicky in the rules it has for naming.  Keep storage params lowercase and under 15 characters.  You will need to replace any values containing <text>.  Anything without <> surrounding it is optional to change.  
2. Run the 01 - CreateSynLoadResources.ps1 script and supply the param file location.  You'll be prompted for your login credentials to Azure.  You'll also be prompted 2 times for a username and password.  This will become your Azure SQL DB SQL admin and Synapse workspace SQL admin login and password.  Below is some sample syntax to run the file and pass the paramfile within Azure CLI and locally.  Keep all your scripts, paramfile01.json and all json files in the same folder location.  
  Azure CLI:  ./"01 - CreateSynLoadResources.ps1" -filepath ./paramfile01.json
  Locally:  & "C:\folder\01 - CreateSynLoadResources.ps1" -filepath "C:\folder\paramfile01.json"
3. Run the 02 - SynLoadGrantRights.ps1 script.  You'll again be prompted for login to Azure.  This script will assign the rights needed to the ADLS storage account.  It will grant your account (or the admin user provided in the paramfile) to the role Storage Blob Data Contributor role on the ADLS account.  Below is a sample syntax.  
  Azure CLI:  ./"02 - SynLoadGrantRights.ps1" -filepath ./paramfile01.json
  Locally:  & "C:\folder\02 - SynLoadGrantRights.ps1" -filepath "C:\folder\paramfile01.json"
4. Run the 03 - CreateSynLoadPipelineParts.ps1 script.  You'll again be prompted for login to Azure.  This script will create the items within the Synapse workspace to build the pipelines.  It will create linked services, datasets, and pipelines.  Below is a sample syntax.  
  Azure CLI:  ./"03 - CreateSynLoadPipelineParts.ps1" -filepath ./paramfile01.json
  Locally:  & "C:\folder\03 - CreateSynLoadPipelineParts.ps1" -filepath "C:\folder\paramfile01.json"
6. Navigate to the Synapse workspace and open up Synapse Studio.  Navigate to the manage pane (far left toolbox icon).  Select Linked Services and find the linked service for your Azure SQL DB.  Update the values required and supply your credentials and verify connectivity by hitting the Test Connection button (you'll need to enable the IR for this)
7. Connect to the Azure SQL DB to create the metadata tables.  Open the SampleMetadataCreate.sql file and update the insert statements for the extracts with your Azure SQL DB.  
8. Use the same Azure SQL DB connection and open the script CowBiometricsSampleSource.sql.  Run this script to create the COW.Biometrics table and insert sample data.  
8. Run the script to create and insert statements for [ADF].[ExtractTables].  You will come back later to the insert for [ADF].[MetadataLoad] once you have a file to load.  
9. Navigate to your dedicated SQL pool.  You can do this within Synapse Studio or use the dedicated SQL endpoint and your preferred query tool.  Make sure that your dedicated pool is running.  Open COWBiometricsSynapseTargetCreate.sql script and run it to create the destination tables we'll load with the parquet files.  
10.  Navigate to pipelines (left pane pipe icon).  Run the SQL Date Based Extract pipeline - this pipeline will extract data based on the date range in the [ADF].[ExtractTables].  The sample is set to extract all the rows in the COW.Biometrics table that have BirthDate column values between 2019-02-18' to '2019-02-22'.  
10.  Verify the parquet file extracts successfully into your ADLS storage location (paramfile01.json value supplied for azstoragename2).  You can skip to #bla if you'd like to upload it. 
11.  Run the PL SQL Not Date Based Extract pipeline - this pipeline will extract data based on the [NotDateColumn] value in the [ADF].[ExtractTables].  You need to supply a valid column value for the NotDateColumnValue parameter.  The NotDateColumn needs to be the value the column contained in the metadata [NotDateColumn].  For example, the sample is set to extract all the rows in the COW.Biometrics table that have Animal column value = value you specify at run time.  You can use 9111 for first value and Animal for the second. That will extract all the rows where the Animal = 9111.  
12.  Now that we have parquet files to use, we can now update the [ADF].[MetadataLoad] table with filenames we want to load.  Navigate back to query tool and update the insert statement with filename from one of the extract pipeline runs above.  Run the insert statement.  
13.  You can now run the Truncate Load Synapse pipeline.  You will be prompted again for the filename that will match to our [ADF].[MetadataLoad] for where it will load the data in the dedicated SQL pool.  This pattern will truncate and reload the destination table.  Verify it loads successfully (can use script DemoWatchSynapseLoadTables.sql). 
14.  You can also now run the Incremental Load pipeline.  This will use a staging table to load what's contained in the parquet file.  It will then trunate the staging table, check for values in the final target table that match, delete them, and reload from the staging table.  
15.  Validate you have values within your [COW].[Biometrics_Stg] and [COW].[Biometrics] tables.  You can add another entry into the [ADF].[MetadataLoad] for the other extracted parquet file and re-run the pipeline passing that filename into the parameter.  
16. If running the SQL Not Date Based Extract, validate the logging is captured in ADF.PipelineLog table. Note: not all fields populate (update later to come to resolve)
  

  
