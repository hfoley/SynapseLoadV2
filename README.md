# Synapse Load Solution - V2 
This solution contains code to help build the components of an Azure Synapse Analytics environment including metadata tables and some metadata driven extract and load pipelines. This solution contains PowerShell, SQL scripts, and json files to build out all the components listed below.   
	
The architecture of the solution diagrammed below.  

![alt text](https://github.com/hfoley/EDU/blob/master/images/SynapseLoadDiagram.jpg?raw=true)

## Asset List - These items will be created in your Azure subscription 
	1. Azure Resource Group
	2. Azure SQL Server & Database - metadata tables location 
	3. Azure Data Lake Gen 2 - location to land extracted parquet files 
	4. Azure Synapse Workspace - workspace where pipelines and SQL dedicated pool will live
	5. Azure Synapse dedicated SQL Pool - destination to load parquet extracted files 
	6. Azure SQL DB metadata tables to drive Synapse pipelines
	7. Azure Synapse - SQL Date Based Extract pipeline - extracts data from SQL Server tables specified (example uses Azure SQL DB created or specified) by a date rante
	8. Azure Synapse - SQL Date Not Date Based Extract pipeline - extracts data from SQL Server tables specified (example uses Azure SQL DB created or specified) by a specified value 
	9. Azure Synapse - Synapse Incremental Load pipeline - parameter/metadata driven pipeline that does incremental load into Synapse SQL pool staging/target tables
	10. Azure Synapse - Synapse Truncate Load pipeline - parameter/metadata driven pipeline that does truncate/reload pattern into Synapse SQL pool only target tables
	
* [01 Create Resources](https://github.com/hfoley/SynapseLoadV2/tree/master/01%20Create%20Resources)   - contains PowerShell scripts to build all the Azure components in the solution. 
* [02 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20SQL%20Scripts)   - contains the SQL Server script to create the metadata tables and insert data in your Azure SQL DB.  
* [03 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20Sample)  - contains all the files if you'd like to setup a sample source/destination.  
	

## Pre-reqs
1. You can run them locally or via Azure CLI(https://docs.microsoft.com/en-us/cli/azure/what-is-azure-cli)/Azure Cloud Shell(https://docs.microsoft.com/en-us/azure/cloud-shell/overview).  I've done a blog post to help get setup to run the scripts at (https://hopefoley.com/2021/09/27/powershell-in-the-clouds/).  
2. You can run locally as well.  Need to have at least PowerShell 5.1 installed.  You can check this by running the following script. 
	$PSVersionTable.PSVersion
2. You can use the 00 - PreReqCheck.ps1 (https://github.com/hfoley/SynapseLoadV2/blob/master/00%20-%20PreReqCheck.ps1) script to check for the necessary modules.  



## Steps 
Each folder contains PowerShell and/or SQL scripts you'll need to update for your environment.  Further details on the files are in the readme of each section.  

1. Start here if you want to build the solution using a sample source/destination >> [03 Sample](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20Sample)
2. Start here to just create Azure resources above >> [01 Create Resources](https://github.com/hfoley/SynapseLoadV2/tree/master/01%20Create%20Resources) 
3. Here's the location containing the script to create the SQL metadata tables >> [02 ADF Create](https://github.com/hfoley/SynapseLoadV2/tree/master/02%20ADF%20Create).  







		

	
	

