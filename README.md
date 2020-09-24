# SynapseLoadV2

# Synapse Load Solution - V2 
Been doing more work and revamping the original solution a bit.  I will keep the version at https://aka.ms/SynapseLoad as the GA version.  I'll only use GA versions of the projects in that version.  This V2 will contain as many items as I can automate with PowerShell utilizing the new Azure Synapse Analytics (workspace preview) https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is.  
	
The architecture of the solution diagrammed below.  

![alt text](https://github.com/hfoley/EDU/blob/master/images/SynapseLoadArchitecture.png?raw=true)

## Asset List 
	1. Azure Resource Group
	2. Azure SQL Database - metadata table location 
	3. Azure Data Lake Gen 2 - location to land extracted parquet files 
	4. Azure Data Factory - pipelines to extract data 
	5. Azure Synapse - destination to load parquet extracted files 

* [CreateResources](https://github.com/hfoley/SynapseLoad/tree/master/CreateResources)   - contains PowerShell scripts to build all the Azure components in the solution. 
* [AzureSQLScripts](https://github.com/hfoley/SynapseLoad/tree/master/AzureSQLScripts)   - contains SQL Scripts to create and load the Azure SQL metadata table.  Also contains a subdirectory with sample data and related scripts if you'd like to test/view the solution with sample data instead.  
* [ADFPosh](https://github.com/hfoley/SynapseLoad/tree/master/ADFPosh)  - contains PowerShell scripts to build the ADF coponents and pipelines 

Each sub-directory has additional readme files with further details but the high level steps are below.  

## Pre-reqs
1. Need to have at least PowerShell 5.1 installed.  You can check this by running the following script. 
	$PSVersionTable.PSVersion
2. Install Powershell AZ module.  This solution has been tested with 4.1.0.  You can find info on installing this at https://www.powershellgallery.com/packages/Az/4.1.0

## Steps
1. Create all assets.  If you'd like to create the Azure components you can use scripts in CreateResources.   Open each file and edit the variables section at the top.  You can do a search/replace for the text string `"***Change This***"`.  Run them individually starting at 01ResourceGroupCreate.ps1 and run them in order by naming. 
2. Connect to Azure SQL DB and run scripts 01  - 03 .  These scripts will create ADF.MetadataLoad schema, table, and an insert script to load the table that will drive the pipelines.  More details in AzureSQLScripts readme and in the comments of the scripts to run. 
3. Connect to Azure Synapse (make sure running) and run scripts to create your target tables (staging and final destination).  If you're using the sample use scripts in sample location.   
4. Run the scripts for creating the Data Factory components contained in ADFPosh directory.  
5. Load parquet files into storage location. 
6. Run each pipeline passing it the parameter of the filename to load.  This value should correspond to the value in the ADF.MetadataLoad table's Filename column.  



		

	
	

