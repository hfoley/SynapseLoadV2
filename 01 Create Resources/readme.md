# 01 Create Resources
This folder contains the files you'll need to create all the components for the solution.  The only file you need to update is the paramfile01.json.  All the scripts use this file to drive the names, locations, ect. to build it out in your environment.  Make sure you have rights to create resources in your Azure subscription.  You can use existing resources for this solution.  The script will check for it's existence first, before creating it.  IMPORTANT: If you create a new dedicated SQL pool, it will begin running.  Make sure to PAUSE the dedicated SQL pool when you're not using it.  HOPE WARNING: DON'T WASTE $$ in Azure on it accidentally.  


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


## Steps 
1. Download the files locally or to storage account fileshare used for CLI (see https://hopefoley.com/2021/09/27/powershell-in-the-clouds/ for help setting up). If you're setting up the sample, you can skip to [03 Sample](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20Sample).  This contains all the files needed in that location.  
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
7. Move to [02 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20SQL%20Scripts) to setup the metadata tables based on your own sources. 

## Asset List - These items will be created in your Azure subscription
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

	
  
