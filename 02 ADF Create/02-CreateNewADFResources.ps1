<# 
Creates the ADF and all the components of the pipelines 
#>

<# 
Update all the variables in the section below for your environment.  
Update the values below within the < > 
#>

$startTime = Get-Date
$SubscriptionId = '<Azure subscription id>'
$resourceGroupName = "<Resource group name>"
$resourceGroupLocation = "<Resource group location>" 
$azadfname = "<Azure Data Factory Name>"
$ScriptLoc = "<local file drive holding the script files> (i.e. C:\Scripts\)>"

<# 
None of the variables below this point need to be updated
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
$PipelineFile3 = ".\SQLDateBasedExtract.json"


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



Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName1 `
    -DefinitionFile $LinkedServiceFile1

Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName2 `
    -DefinitionFile $LinkedServiceFile2

Set-AzDataFactoryV2LinkedService -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $LinkedServiceName3 `
    -DefinitionFile $LinkedServiceFile3


Set-AzDataFactoryV2 -ResourceGroupName $resourceGroupName -Name $azadfname  -Location $resourceGroupLocation

#Dataset create 



Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName1 `
    -DefinitionFile $DatasetFile1

Select-AzSubscription -SubscriptionId $SubscriptionId
Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName2 `
    -DefinitionFile $DatasetFile2

Select-AzSubscription -SubscriptionId $SubscriptionId
Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName3 `
    -DefinitionFile $DatasetFile3

Select-AzSubscription -SubscriptionId $SubscriptionId
Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName4 `
    -DefinitionFile $DatasetFile4

Select-AzSubscription -SubscriptionId $SubscriptionId
Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName5 `
    -DefinitionFile $DatasetFile5

#>
Select-AzSubscription -SubscriptionId $SubscriptionId
Set-AzDataFactoryV2Dataset -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName -Name $DatasetName6 `
    -DefinitionFile $DatasetFile6



$Pipeline1 = Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName1 `
    -DefinitionFile $PipelineFile1

$Pipeline2 = Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName2 `
    -DefinitionFile $PipelineFile2

$Pipeline3 = Set-AzDataFactoryV2Pipeline `
    -DataFactoryName $azadfname `
    -ResourceGroupName $ResourceGroupName `
    -Name $PipelineName3 `
    -DefinitionFile $PipelineFile3
