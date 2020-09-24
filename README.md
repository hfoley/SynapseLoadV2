# Synapse Load Solution - V2 
This solution is to help build the components of a modern data warehouse in Azure including some Azure Data Factory metadata driven extract and load pipelines.  This version builds on the previous solution that focused on the pipelines to load parquet files into what was at the time called Azure SQL DW at https://aka.ms/SynapseLoad.  I will keep the version at that link as a GA service version.  I'll only use GA versions of the services in that version.  This V2 version here will contain as many items as I can automate with PowerShell utilizing the new Azure Synapse Analytics (workspace preview) https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is.  I have also enhanced this version to contain a pipeline to extract SQL tables to parquet in a time based fashion.  
	
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
* [02 ADF Create](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20ADF%20Create)   - contains powershell script and json files needed to build Azure Data Factory pipelines and other components.    
* [03 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20SQL%20Scripts)  - contains the SQL Server script to create the metadata tables and insert data on your Azure SQL DB.  There's also a subdirectory [Sample](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20SQL%20Scripts/Sample) if you'd like to use sample files instead of using your own tables.  
	

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
Each folder contains PowerShell and/or SQL scripts you'll need to update for your environment.  Further details on the files are in the readme of each section.  

1. Start here to create Azure resources above >> [01 Create Resources](https://github.com/hfoley/SynapseLoadV2/tree/master/01%20Create%20Resources) 

2. Start here to only want to create the Azure Data Factory components >> [02 ADF Create](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20ADF%20Create).  

3. Start here if you only need to create the metadata tables >> [03 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20SQL%20Scripts)






		

	
	

