# 01 Create Resources
This folder contains the CreateNewWorkspaceResources.ps1 file.  This PowerShell script will create all the components to use in your Azure Subscription.  

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
  
  
