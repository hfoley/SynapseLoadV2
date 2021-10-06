# 01 Create Resources
This folder contains the files you'll need to create all the components for the solution.  The only file you need to update is the paramfile01.json.  All the scripts use this file to drive the names, locations, ect. to build it out in your environment.  Make sure you have rights to create resources in your Azure subscription.  You can use existing resources for this solution.  The script will check for it's existence first, before creating it.  

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
1. Update the paramfile.json with the values you want to use for the rest of the scripts.  Storage is finicky in the rules it has for naming.  Keep storage params lowercase and under 15 characters.    
3. Run the 01 - CreateResources.ps1 file and supply the param file location.  You'll be prompted for your login credentials to Azure.  You'll also be prompted for a username and password.  This will be your Synapse admin login.  Below is some sample syntax to run the file and pass the paramfile.  Keep all your script and json files in the same folder location.  

    & "C:\PSScripts\01 - CreateResources.ps1" -filepath "C:\PSScripts\paramfile.json"
4. Run the 02 - GrantStorageRights.ps1.  You'll again be prompted for login to Azure.  This script will assign the rights needed to the ADLS storage account.  It will grant your account (or the admin user provided in the paramfile) to the role Storage Blob Data Contributor role on the ADLS account.  Below is a sample syntax.  

## Asset List - These items will be created in your Azure subscription
	1. Azure Resource Group
	2. Azure SQL Database - metadata tables location 
	3. Azure Data Lake Gen 2 - location to land extracted parquet files 
	4. Azure Data Factory - pipelines to extract data 
	5. Azure Synapse Workspace - new environment for anayltics 
	6. Azure Synapse SQL Pool - destination to load parquet extracted files 
	
## Steps 
  1. Download CreateNewWorkspaceResources.ps1 and store it locally.  
  2. Edit the script variables needed in the top section.  Anything needing updated will be contained within <> and a description of what the variable drives within them.  Replace the <text> portion to the names/values for your environment.  
  3. Save and run the script.
  4. Validate all services create successfully. 
  5. Move to [02 ADF Create](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20ADF%20Create)
  
## What happens 
  1. You'll be prompted to login to Azure as user with rights to create services. 
  2. You'll be prompted 2 times for a userid and password.  This user id and password will become your SQL Server Admin of the Azure SQL DB and the Azure Synapse SQL pool.  
  
  
