# SynapseLoadV2

# Synapse Load Solution - V2 
Been doing more work and revamping the original solution (https://aka.ms/SynapseLoad ) a bit.  I will keep the version at that link as the GA version.  I'll only use GA versions of the services in that version.  This V2 version here will contain as many items as I can automate with PowerShell utilizing the new Azure Synapse Analytics (workspace preview) https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is.  I have also enhanced this version to contain a pipeline to extract SQL tables to parquet in a time based fashion.  
	
The architecture of the solution diagrammed below.  

![alt text](https://github.com/hfoley/EDU/blob/master/images/SynapseLoadArchitecture.png?raw=true)

## Asset List - These items will be created in your Azure subscription
	1. Azure Resource Group
	2. Azure SQL Database - metadata tables location 
	3. Azure Data Lake Gen 2 - location to land extracted parquet files 
	4. Azure Data Factory - pipelines to extract data 
	5. Azure Synapse Workspace - new environment for anayltics 
	6. Azure Synapse SQL Pool - destination to load parquet extracted files 
	
* [01 Create Resources](https://github.com/hfoley/SynapseLoadV2/tree/master/01%20Create%20Resources)   - contains PowerShell scripts to build all the Azure components in the solution. 
* [AzureSQLScripts](https://github.com/hfoley/SynapseLoad/tree/master/AzureSQLScripts)   - contains SQL Scripts to create and load the Azure SQL metadata table.  Also contains a subdirectory with sample data and related scripts if you'd like to test/view the solution with sample data instead.  
* [ADFPosh](https://github.com/hfoley/SynapseLoad/tree/master/ADFPosh)  - contains PowerShell scripts to build the ADF coponents and pipelines 
	

## Pre-reqs
1. Need to have at least PowerShell 5.1 installed.  You can check this by running the following script. 
	$PSVersionTable.PSVersion
2. Install Powershell AZ package.  This solution has been tested with 4.3.0.  You can find info on installing this at https://www.powershellgallery.com/packages/Az/
3. You may also need addtional modules as well like Az.DataFactory (https://www.powershellgallery.com/packages/Az.DataFactory) and Az.Synapse (https://www.powershellgallery.com/packages/Az.Synapse).  These commands below can help you determine if you have these components. I have tested this with Az.DataFactory 1.8.2 and Az.Synapse 0.1.2.  

	$PSVersionTable.PSVersion

	Get-InstalledModule -Name Az -AllVersions | Select-Object -Property Name, Version

	Get-Module -Name Az.Sy* -ListAvailable
	Get-Module -Name Az.DataF* -ListAvailable


## Steps
This solution contains several files to help build the solution.  There are PowerShell scripts to run to create the resources.  There are also several json files that will be used to build the Azure Data Factory pipelines.  There is also a SQL Server script to run to create and populate 2 metadata tables to drive the 3 pipelines.  

1. Download all the files locally.  Open the Powershell scripts and update the variables sections of each file at the top with your information.  Each variable that needs updated will be within < description >.  
2. If you'd like to create all the components used in the solution - run CreateNewWorkspaceResources.ps1 file.  You'll need to login to Azure and have sufficient privledges to build services in Azure.  
3. Next run UpdateADFJsonTemplateFiles.ps1.  This file will generate new linked services json files to use to build the ADF linked services.  This script will update the json files with data you supply in the variables section.  
4. Run the script CreateNewADFResources.ps1.  This file will create the Azure Data Factory and all the needed components within ADF.  
5. Validate all the components created. 
6. Update each of the 3 linked services created with appropriate storage account key for ADLS and passwords for Azure SQL and Azure Synapse.  Test that each linked service connects successfully. 
7. Connect to the Azure SQL DB that will house the metadata tables.  Open, edit each section based on your environment and run the script MetadataTablesCreate.sql.  
8. You'll need to make sure you have appropriate source and target tables to load created in the SQL Server and destination Synapse sql pool.  If you'd like to use the sample data, it's contained < here>.  




		

	
	

