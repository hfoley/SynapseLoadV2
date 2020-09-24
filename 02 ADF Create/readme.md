
# 02 ADF Create
This folder contains 2 Powershell scripts and multiple json files.  

## Asset List - These items will be created 
	1. Azure Data Factory if the supplied name doesn't exist.  
	2. 3 ADF linked services
	3. 6 ADF datasets 
	4. 3 ADF pipelines 
	
	
## Steps 
  1. Download all files in this foler and store them locally.  
  2. Edit the script variables needed in the top sections of each of the PowerShell files.  Anything needing updated will be contained within <> and a description of what the variable drives within them.  Replace the <text> portion to the names/values for your environment.  
  3. Save the scripts.  
  4. Run 01-UpdateADFJsonTemplateFiles.ps1.  This script will generate updated json files for creating the linked services.  
  5. Run 02-CreateNewADFResources.ps1.  This script creates the ADF and all components needed for creating pipelines.  
  6. Open Azure Data Factory Author and Monitor workspace - select Monitor (tool box icon on left). 
  7. Select Linked Services and click on each one.  You'll need to update the ADLS Gen 2 linked service with the appropriate storage key or preferred authentication. You'll need to supply the appropriate password for Azure SQL DB and Synapse SQL Pool linked services.  
  8. Test the connection of each linked service and verify success.  
  9. Move to [03 SQL Scripts](https://github.com/hfoley/SynapseLoadV2/tree/master/03%20SQL%20Scripts)
  
## What happens 
  1. When 01-UpdateADFJsonTemplateFiles.ps1 runs you'll see 3 additional json files created.  These will be used when running 2nd script.  
  2. When 02-CreateNewADFResources.ps1 runs you may get a prompt to overlay an existing component.  Choose yes if so.  
  
  
