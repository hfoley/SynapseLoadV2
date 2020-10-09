<# 
Creates the ADF and all the components of the pipelines.  

Update all the variables in the section below for your environment.  
Update the values below within the < > 

** After you run this you'll need to update the linked services created. 
** You'll need to update the storage key for ADLSGen2LnkSvr 
** You'll need to update the user/password for Azure SQL and Synapse SQL pool
** Make sure to create the logging table prior to running pipelines
** Make sure to run the 01-UpdateADFJsonTemplate script first as files created used in this process
#>


$SubscriptionId = '<Azure subscription id>'
$resourceGroupName = "<Resource group name>"
$resourceGroupLocation = "<Resource group location>" 

# Below will be the name of your Azure Data Factory. If you specify one that 
# already exists, it will put components into existing ADF.  
$azadfname = "<Azure Data Factory Name>"

# Specify file location below where you'll be running the scripts from
$ScriptLoc = "<local file drive holding the script and json files> (i.e. C:\Scripts\)>"


<# 
***None of the variables below this point need to be updated***
#> 

$LinkedServiceName1 = "AzureSQLDBLnkSvr"
$LinkedServiceFile1 = ".\AzureSQLDBLinkedServiceFinal.json"
$LinkedServiceName2 = "ADLSGen2LnkSvr"
$LinkedServiceFile2 = ".\ADLSGen2LinkedServiceFinal.json"
$LinkedServiceName3 = "SynapseLnkSvr"
$LinkedServiceFile3 = ".\SynapseLinkedServiceFinal.json"
                   

#Azure SQL metadata table driving the load process ADF.MetadataLoad
$DatasetName1 = "LookupMetadataLoad"
$DatasetFile1 = ".\DatasetLookupMetadataLoad.json"

#The parquet files to load into Synapse for the load processes 
$DatasetName2 = "SrcADLSFileLoad"
$DatasetFile2 = ".\DatasetSrcADLSFileLoad.json"

#Destination Synapse tables from the load process 
$DatasetName3 = "SinkSynapseTable"
$DatasetFile3 = ".\DatasetSinkSynapse.json"

#Source SQL Server tables that will get an extract from extract process 
$DatasetName4 = "SrcSQLTableExtract"
$DatasetFile4 = ".\DatasetSrcSQLTableExtract.json"

#Azure SQL metadata table driving the extract process ADF.ExtractTables 
$DatasetName5 = "LookupMetadataExtract"
$DatasetFile5 = ".\DatasetLookupMetadataExtract.json"

#The desination parquet files built during extract process 
$DatasetName6 = "SinkADLSParquetExtract"
$DatasetFile6 = ".\DatasetSinkADLSParquetExtract.json"

#The custom logging table for capturing data from pipeline runs
$DatasetName7 = "SinkSQLLogTable"
$DatasetFile7 = ".\DatasetSinkSQLLogTable.json"

$PipelineName1 = "Synapse Incremental Load"
$PipelineFile1 = ".\IncrementalPipelineCreate.json"
$PipelineName2 = "Synapse Truncate Load"
$PipelineFile2 = ".\Truncate Load Synapse.json"
$PipelineName3 = "SQL Date Based Extract"
$PipelineFile3 = ".\SQL Date Based Extract.json"
$PipelineName4 = "SQL Not Date Based Extract"
$PipelineFile4 = ".\SQL Not Date Based Extract.json"


Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId

Write-Host "The Azure Data Factory creation script was started " $startTime

$ADFCheck = Get-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $azadfname -ErrorAction SilentlyContinue
if(-not $ADFCheck)
    {
    Write-Host "The Azure Data Factory '$azadfname' doesn't exist and will be created"
    New-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $azadfname –Location $resourceGroupLocation
    }
else 
    {
   Write-Host "The Azure Data Factory '$azadfname' already there"
    }

write-host "Ended Azure Data Factory creation at " $endTime
write-host "Total ADF resources creation script finish at " $endTime



Set-Location $ScriptLoc

#Create Linked Service 1
$LinkSvc1Check = Get-AzDataFactoryV2LinkedService -ResourceGroupName $ResourceGroupName -DataFactoryName $azadfname -Name $LinkedServiceName1 -ErrorAction SilentlyContinue

if(-not $LinkSvc1Check)
    {
    Write-Host "Linked Service '$LinkedServiceName1' doesn't exist and will be created"
    Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName1 `
    -DefinitionFile $LinkedServiceFile1 -ErrorAction SilentlyContinue
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName1' already created"}
$endTime = Get-Date
write-host "Ended '$LinkedServiceName1' creation at " $endTime

###Linked Service 2 Create 
$LinkSvc2Check = Get-AzDataFactoryV2LinkedService -ResourceGroupName $ResourceGroupName -DataFactoryName $azadfname -Name $LinkedServiceName2 -ErrorAction SilentlyContinue

if(-not $LinkSvc2Check)
    {
    Write-Host "Linked Service '$LinkedServiceName2' doesn't exist and will be created"
    Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName2 `
    -DefinitionFile $LinkedServiceFile2 -ErrorAction SilentlyContinue
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName2' already created"}
$endTime = Get-Date
write-host "Ended '$LinkedServiceName2' creation at " $endTime


###Linked Service 3 Create 
$LinkSvc3Check = Get-AzDataFactoryV2LinkedService -ResourceGroupName $ResourceGroupName -DataFactoryName $azadfname -Name $LinkedServiceName3 -ErrorAction SilentlyContinue

if(-not $LinkSvc3Check)
    {
    Write-Host "Linked Service '$LinkedServiceName3' doesn't exist and will be created"
    Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName3 `
    -DefinitionFile $LinkedServiceFile3 -ErrorAction SilentlyContinue
    }
else 
    {Write-Host "Linked Service '$LinkedServiceName3' already created"}
$endTime = Get-Date
write-host "Ended '$LinkedServiceName3' creation at " $endTime

#Dataset create 

$Dataset1Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName1 -ErrorAction SilentlyContinue
if(-not $Dataset1Check)
    {
    Write-Host "Dataset '$DatasetName1' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName1 `
    -DefinitionFile $DatasetFile1

    }
else 
    {Write-Host "Dataset '$DatasetName1' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName1' creation at " $endTime


$Dataset2Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName2 -ErrorAction SilentlyContinue
if(-not $Dataset2Check)
    {
    Write-Host "Dataset '$DatasetName2' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName2 `
    -DefinitionFile $DatasetFile2

    }
else 
    {Write-Host "Dataset '$DatasetName2' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName2' creation at " $endTime

$Dataset3Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName3 -ErrorAction SilentlyContinue
if(-not $Dataset3Check)
    {
    Write-Host "Dataset '$DatasetName3' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName3 `
    -DefinitionFile $DatasetFile3

    }
else 
    {Write-Host "Dataset '$DatasetName3' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName3' creation at " $endTime

$Dataset4Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName4 -ErrorAction SilentlyContinue
if(-not $Dataset4Check)
    {
    Write-Host "Dataset '$DatasetName4' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName4 `
    -DefinitionFile $DatasetFile4

    }
else 
    {Write-Host "Dataset '$DatasetName4' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName4' creation at " $endTime

$Dataset5Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName5 -ErrorAction SilentlyContinue
if(-not $Dataset5Check)
    {
    Write-Host "Dataset '$DatasetName5' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName5 `
    -DefinitionFile $DatasetFile5

    }
else 
    {Write-Host "Dataset '$DatasetName5' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName5' creation at " $endTime

$Dataset6Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName6 -ErrorAction SilentlyContinue
if(-not $Dataset6Check)
    {
    Write-Host "Dataset '$DatasetName6' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName6 `
    -DefinitionFile $DatasetFile6

    }
else 
    {Write-Host "Dataset '$DatasetName6' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName6' creation at " $endTime

$Dataset7Check = Get-AzDataFactoryV2Dataset -ResourceGroupName $ResourceGroupName  -DataFactoryName $azadfname  -Name $DatasetName7 -ErrorAction SilentlyContinue
if(-not $Dataset7Check)
    {
    Write-Host "Dataset '$DatasetName7' doesn't exist and will be created"
    Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName7 `
    -DefinitionFile $DatasetFile7

    }
else 
    {Write-Host "Dataset '$DatasetName7' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName7' creation at " $endTime

#Create Pipelines
$Pipeline1Check = Get-AzDataFactoryV2Pipeline -ResourceGroupName $ResourceGroupName  -Name $PipelineName1 -DataFactoryName $azadfname -ErrorAction SilentlyContinue
if(-not $Pipeline1Check)
    {
    Write-Host "Pipeline '$PipelineName1' doesn't exist and will be created"
    Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName1 `
    -DefinitionFile $PipelineFile1
    }
else 
    {Write-Host "Pipeline '$PipelineName1' already created"}
$endTime = Get-Date
write-host "Ended '$PipelineName1' creation at " $endTime

$Pipeline2Check = Get-AzDataFactoryV2Pipeline -ResourceGroupName $ResourceGroupName  -Name $PipelineName2 -DataFactoryName $azadfname -ErrorAction SilentlyContinue
if(-not $Pipeline2Check)
    {
    Write-Host "Pipeline '$PipelineName2' doesn't exist and will be created"
    Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName2 `
    -DefinitionFile $PipelineFile2
    }
else 
    {Write-Host "Pipeline '$PipelineName2' already created"}
$endTime = Get-Date
write-host "Ended '$PipelineName2' creation at " $endTime

$Pipeline3Check = Get-AzDataFactoryV2Pipeline -ResourceGroupName $ResourceGroupName  -Name $PipelineName3 -DataFactoryName $azadfname -ErrorAction SilentlyContinue
if(-not $Pipeline3Check)
    {
    Write-Host "Pipeline '$PipelineName3' doesn't exist and will be created"
    Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName3 `
    -DefinitionFile $PipelineFile3
    }
else 
    {Write-Host "Pipeline '$PipelineName3' already created"}
$endTime = Get-Date
write-host "Ended '$PipelineName3' creation at " $endTime

$Pipeline4Check = Get-AzDataFactoryV2Pipeline -ResourceGroupName $ResourceGroupName  -Name $PipelineName4 -DataFactoryName $azadfname -ErrorAction SilentlyContinue
if(-not $Pipeline4Check)
    {
    Write-Host "Pipeline '$PipelineName4' doesn't exist and will be created"
    Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName4 `
    -DefinitionFile $PipelineFile4
    }
else 
    {Write-Host "Pipeline '$PipelineName4' already created"}
$endTime = Get-Date
write-host "Ended '$PipelineName4' creation at " $endTime
