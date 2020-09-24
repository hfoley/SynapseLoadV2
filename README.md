# SynapseLoadV2

# Synapse Load Solution - V2 
Been doing more work and revamping the original solution a bit.  I will keep the version at https://aka.ms/SynapseLoad as the GA version.  I'll only use GA versions of the projects in that version.  This V2 will contain as many items as I can automate with PowerShell utilizing the new Azure Synapse Analytics (workspace preview) https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is.  I have also enhanced this version to contain a pipeline to extract SQL tables to parquet in a time based fashion.  
	
The architecture of the solution diagrammed below.  

![alt text](https://github.com/hfoley/EDU/blob/master/images/SynapseLoadArchitecture.png?raw=true)

## Asset List 
	1. Azure Resource Group
	2. Azure SQL Database - metadata tables location 
	3. Azure Data Lake Gen 2 - location to land extracted parquet files 
	4. Azure Data Factory - pipelines to extract data 
	5. Azure Synapse Workspace - new environment for anayltics 
	6. Azure Synapse SQL Pool - destination to load parquet extracted files 
	

## Pre-reqs
1. Need to have at least PowerShell 5.1 installed.  You can check this by running the following script. 
	$PSVersionTable.PSVersion
2. Install Powershell AZ package.  This solution has been tested with 4.3.0.  You can find info on installing this at https://www.powershellgallery.com/packages/Az/
3. You may also need addtional modules as well like Az.DataFactory (https://www.powershellgallery.com/packages/Az.DataFactory) and Az.Synapse (https://www.powershellgallery.com/packages/Az.Synapse).  These commands below can help you determine if you have these components. I have tested this with Az.DataFactory 1.8.2 and Az.Synapse 0.1.2.  

	$PSVersionTable.PSVersion

	Get-InstalledModule -Name Az -AllVersions | Select-Object -Property Name, Version

	Get-Module -Name Az.Sy* -ListAvailable
	Get-Module -Name Az.DataF* -ListAvailable

You'll need to download all the files locally.  Below is listing of the files you'll be working with for deploying this solution. 


## Steps
1. Create all assets.  If you'd like to create the Azure components you can use scripts in CreateResources.   Open each file and edit the variables section at the top.  You can do a search/replace for the text string `"***Change This***"`.  Run them individually starting at 01ResourceGroupCreate.ps1 and run them in order by naming. 
2. Connect to Azure SQL DB and run scripts 01  - 03 .  These scripts will create ADF.MetadataLoad schema, table, and an insert script to load the table that will drive the pipelines.  More details in AzureSQLScripts readme and in the comments of the scripts to run. 
3. Connect to Azure Synapse (make sure running) and run scripts to create your target tables (staging and final destination).  If you're using the sample use scripts in sample location.   
4. Run the scripts for creating the Data Factory components contained in ADFPosh directory.  
5. Load parquet files into storage location. 
6. Run each pipeline passing it the parameter of the filename to load.  This value should correspond to the value in the ADF.MetadataLoad table's Filename column.  



		

	
	

