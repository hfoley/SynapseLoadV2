<# 
This file is driven by parameter file passed.  
There is a sample starting one in the github repo called paramfile.json 
You'll need to update that file and pass when running this script. 
Put all the files in the same folder as the paramfile.  


You can run this script by sample syntax below: 
& "C:\PSScripts\04 - Create Pipeline Parts.ps1" -filepath "C:\PSScripts\paramfile.json"

 #>


 param(
    [Parameter(Mandatory)]
    [string]$filepath
)

$startTime = Get-Date
$folderpath = Split-Path -Path $filepath
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

$SubscriptionId = $filestuff.SubscriptionId

#variables for Synapse workspace. Based on prefix from param file
$azsynapsename = $filestuff.azsynapsename
$azstoragename2 = $filestuff.azstoragename2
$azsqlserver = $filestuff.$azsqlserver
$azsqlDB = $filestuff.$azsqlDB
$synapsepoolname = $filestuff.synapsepoolname

#Linked service pointing to ADLS Gen2
$LinkedSvcName1 = $filestuff.LinkedSvcName1 
$LinkedSvcFile1 = $filestuff.LinkedSvcFile1
$linkedSvcfullpath = $folderpath + $LinkedSvcFile1 
$linkedsvcurl = "https://"+$azstoragename2+".dfs.core.windows.net"
Write-Host "File used for LinkedSvcName1 "$linkedSvcfullpath 

#Editing the json file to create linked service with variables in paramfile 
$linkedsvcedit = (get-content $linkedSvcfullpath -raw | ConvertFrom-Json)
$linkedsvcedit.name = $LinkedSvcName1
$linkedsvcedit.properties.typeProperties.url = $linkedsvcurl
$linkedsvcedit | ConvertTo-Json -depth 42| set-content $linkedSvcfullpath

#Linked Service to Azure SQL DB
$LinkedSvcName2 = $filestuff.LinkedSvcName2 
$LinkedSvcFile2 = $filestuff.LinkedSvcFile2
$linkedSvc2fullpath = $folderpath + $LinkedSvcFile2 

$linkedsvc2edit = (get-content $linkedSvc2fullpath -raw | ConvertFrom-Json)
$linkedsvc2edit.name = $LinkedSvcName2
$linkedsvc2con = "integrated security=False;encrypt=True;connection timeout=30;data source="+$azsqlserver+".database.windows.net;initial catalog="+$azsqlDB+";user id=***changethis***"
write-host $linkedsvc2con
write-host $azsqlserver
write-host $azsqlDB
$linkedsvc2edit.properties.typeProperties.connectionString = $linkedsvc2con
$linkedsvc2edit | ConvertTo-Json -depth 42| set-content $linkedSvc2fullpath

Write-Host "File used for LinkedSvcName2 " $linkedSvc2fullpath 

#The metadata in Azure SQL to adf.metatdataload table 
$DatasetName1 = $filestuff.DatasetName1
$DatasetFile1 = $filestuff.DatasetFile1
$DataSet1fullpath = $folderpath + $DatasetFile1
Write-Host "File used for DatasetName2 " $DataSet1fullpath

$editds1 = (get-content $DataSet1fullpath -raw | ConvertFrom-Json)
$editds1.name = $filestuff.DatasetName1
$editds1.properties.linkedServiceName.referenceName = $LinkedSvcName2
$editds1 | ConvertTo-Json -depth 42| set-content $DataSet1fullpath

#The SQL Server metadata table 
$DatasetName2 = $filestuff.DatasetName2
$DatasetFile2 = $filestuff.DatasetFile2
$DataSet2fullpath = $folderpath + $DatasetFile2
Write-Host "File used for DatasetName2 " $DataSet2fullpath

$editds2 = (get-content $DataSet2fullpath -raw | ConvertFrom-Json)
$editds2.name = $filestuff.DatasetName2
$editds2.properties.linkedServiceName.referenceName = $LinkedSvcName1
$editds2 | ConvertTo-Json -depth 32| set-content $DataSet2fullpath

#The ADLS location to load parquet files 
$DatasetName3 = $filestuff.DatasetName3
$DatasetFile3 = $filestuff.DatasetFile3
$DataSet3fullpath = $folderpath + $DatasetFile3
Write-Host "File used for DatasetName3: " $DataSet3fullpath

#Sink/desintation table in Synapse dedicated sql pool table 
$editds3 = (get-content $DataSet3fullpath -raw | ConvertFrom-Json)
$editds3.name = $filestuff.DatasetName3
$SyslinkedSvcName = $azsynapsename+"-WorkspaceDefaultSqlServer"
$editds3.properties.linkedServiceName.referenceName = $SyslinkedSvcName
$editds3.properties.linkedServiceName.parameters.DBName = $synapsepoolname
$editds3 | ConvertTo-Json -depth 32| set-content $DataSet3fullpath

#Source SQL Server tables that will get an extract from extract process
$DatasetName4 = $filestuff.DatasetName4
$DatasetFile4 = $filestuff.DatasetFile4
$DataSet4fullpath = $folderpath + $DatasetFile4
Write-Host "File used for DatasetName3: " $DataSet4fullpath

$editds4 = (get-content $DataSet4fullpath -raw | ConvertFrom-Json)
$editds4.name = $filestuff.DatasetName4
$editds4.properties.linkedServiceName.referenceName = $LinkedSvcName2
$editds4 | ConvertTo-Json -depth 32| set-content $DataSet4fullpath
 
#Source SQL Server tables that will get an extract from extract process
$DatasetName5 = $filestuff.DatasetName5
$DatasetFile5 = $filestuff.DatasetFile5
$DataSet5fullpath = $folderpath + $DatasetFile5
Write-Host "File used for DatasetName3: "$DataSet5fullpath

$editds5 = (get-content $DataSet5fullpath -raw | ConvertFrom-Json)
$editds5.name = $filestuff.DatasetName5
$editds5.properties.linkedServiceName.referenceName = $LinkedSvcName2
$editds5 | ConvertTo-Json -depth 32| set-content $DataSet5fullpath

#The ADLS sink dataset for extracting parquet files
$DatasetName6 = $filestuff.DatasetName6
$DatasetFile6 = $filestuff.DatasetFile6
$DataSet6fullpath = $folderpath + $DatasetFile6
Write-Host "File used for DatasetName6: "$DataSet6fullpath

$editds6 = (get-content $DataSet6fullpath -raw | ConvertFrom-Json)
$editds6.name = $filestuff.DatasetName6
$editds6.properties.linkedServiceName.referenceName = $LinkedSvcName1
$editds6 | ConvertTo-Json -depth 32| set-content $DataSet6fullpath

#Azure SQL DB for custom logging table 
$DatasetName7 = $filestuff.DatasetName7
$DatasetFile7 = $filestuff.DatasetFile7
$DataSet7fullpath = $folderpath + $DatasetFile7
Write-Host "File used for DatasetName7: "$DataSet7fullpath

$editds7 = (get-content $DataSet7fullpath -raw | ConvertFrom-Json)
$editds7.name = $filestuff.DatasetName7
$editds7.properties.linkedServiceName.referenceName = $LinkedSvcName2
$editds7 | ConvertTo-Json -depth 32| set-content $DataSet7fullpath

$PipelineName1 = $filestuff.PipelineName1
$PipelineFile1 = $filestuff.PipelineFile1
$PLfullpath1 = $folderpath + $PipelineFile1
Write-Host "File used for Pipeline 1: "+$PipelineName1+": "$PLfullpath1

$editpl = (get-content $PLfullpath1 -raw | ConvertFrom-Json)
$editpl.name = $filestuff.PipelineName1
$arraylevel = $editpl.properties.activities[0].typeProperties.dataset
$arraylevel[0].referenceName = $filestuff.DatasetName1
$arraylevel2 = $editpl.properties.activities[1].inputs[0]
$arraylevel2[0].referenceName = $filestuff.DatasetName2
$arraylevel3 = $editpl.properties.activities[1].outputs[0]
$arraylevel3[0].referenceName = $filestuff.DatasetName3
$arraylevel4 = $editpl.properties.activities[2].inputs[0]
$arraylevel4[0].referenceName = $filestuff.DatasetName3
$arraylevel5 = $editpl.properties.activities[2].outputs[0]
$arraylevel5[0].referenceName = $filestuff.DatasetName3

$editpl | ConvertTo-Json -depth 100| set-content $PLfullpath1


# pipeline 2 Pipeline Truncate Load Synapse

$PipelineName2 = $filestuff.PipelineName2
$PipelineFile2 = $filestuff.PipelineFile2
$PLfullpath2 = $folderpath + $PipelineFile2
Write-Host "File used for Pipeline"+$PipelineName2+": "$PLfullpath2

$editpl2 = (get-content $PLfullpath2 -raw | ConvertFrom-Json)
$editpl2.name = $filestuff.PipelineName2 
$arraylevel = $editpl2.properties.activities[0].typeProperties.dataset
$arraylevel[0].referenceName = $filestuff.DatasetName1
$arraylevel2 = $editpl2.properties.activities[1].inputs[0]
$arraylevel2[0].referenceName = $filestuff.DatasetName2
$arraylevel3 = $editpl2.properties.activities[1].outputs[0]
$arraylevel3[0].referenceName = $filestuff.DatasetName3
$editpl2 | ConvertTo-Json -depth 100| set-content $PLfullpath2

# Pipeline 3 SQL Date Based Extract
$PipelineName3 = $filestuff.PipelineName3
$PipelineFile3 = $filestuff.PipelineFile3
$PLfullpath3 = $folderpath + $PipelineFile3 
Write-Host "File used for Pipeline 3: "+$PipelineName3+": "$PLfullpath3

$editpl3 = (get-content $PLfullpath3 -raw | ConvertFrom-Json)
$editpl3.name = $filestuff.PipelineName3 
$arraylevel = $editpl3.properties.activities[0].typeProperties.dataset
$arraylevel[0].referenceName = $filestuff.DatasetName5
$arraylevel2 = $editpl3.properties.activities[1].typeProperties.activities[0].inputs[0]
$arraylevel2[0].referenceName = $filestuff.DatasetName4
$arraylevel3 = $editpl3.properties.activities[1].typeProperties.activities[0].outputs[0]
$arraylevel3[0].referenceName = $filestuff.DatasetName6
$editpl3 | ConvertTo-Json -depth 100| set-content $PLfullpath3


# Pipeline 4 SQL Not Date Based Extract
$PipelineName4 = $filestuff.PipelineName4
$PipelineFile4 = $filestuff.PipelineFile4
$PLfullpath4 = $folderpath + $PipelineFile4
Write-Host "File used for Pipeline 4: "+$PipelineName4+": "$PLfullpath4

$editpl4 = (get-content $PLfullpath4 -raw | ConvertFrom-Json)
$editpl4.name = $filestuff.PipelineName4 
$arraylevel = $editpl4.properties.activities[0].typeProperties.dataset
$arraylevel[0].referenceName = $filestuff.DatasetName5
$arraylevel2 = $editpl4.properties.activities[1].inputs[0]
$arraylevel2[0].referenceName = $filestuff.DatasetName4
$arraylevel3 = $editpl4.properties.activities[1].outputs[0]
$arraylevel3[0].referenceName = $filestuff.DatasetName6
$arraylevel4 = $editpl4.properties.activities[2].inputs[0]
$arraylevel4[0].referenceName = $filestuff.DatasetName5
$arraylevel5 = $editpl4.properties.activities[2].outputs[0]
$arraylevel5[0].referenceName = $filestuff.DatasetName7
$editpl4 | ConvertTo-Json -depth 100| set-content $PLfullpath4

#Connect to Azure and build pipelines from the files above 
Connect-AzAccount -UseDeviceAuthentication
#Connect-AzAccount
Select-AzSubscription -SubscriptionId $SubscriptionId
Write-Host "The Synapse pipeline parts creation script was started " $startTime
Set-Location $folderpath

$LinkedServiceCheck = Get-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedSvcName1 -ErrorAction SilentlyContinue
if(-not $LinkedServiceCheck)
    {
    Write-Host "Linked Service '$LinkedSvcName1' doesn't exist and will be created"
    Set-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedSvcName1 -DefinitionFile $linkedSvcfullpath
    }
else 
    {Write-Host "Linked Service '$LinkedSvcName1' already created"}
$endTime = Get-Date
write-host "Ended Linked Service 1 creation at " $endTime


$LinkedServiceCheck2 = Get-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedSvcName2 -ErrorAction SilentlyContinue
if(-not $LinkedServiceCheck2)
    {
    Write-Host "Linked Service '$LinkedSvcName2' doesn't exist and will be created"
    Set-AzSynapseLinkedService -WorkspaceName $azsynapsename -Name $LinkedSvcName2  -DefinitionFile $linkedSvc2fullpath
    }
else 
    {Write-Host "Linked Service '$LinkedSvcName2' already created"}
$endTime = Get-Date
write-host "Ended Linked Service 2 creation at " $endTime

$Dataset1Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName1 -ErrorAction SilentlyContinue
if(-not $Dataset1Check)
    {
    Write-Host "Dataset '$DatasetName1' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName1 -DefinitionFile $DataSet1fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName1' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName1' creation at " $endTime


$Dataset2Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName2 -ErrorAction SilentlyContinue
if(-not $Dataset2Check)
    {
    Write-Host "Dataset '$DatasetName2' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName2 -DefinitionFile $DataSet2fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName2' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName2' creation at " $endTime

$Dataset3Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName3 -ErrorAction SilentlyContinue
if(-not $Dataset3Check)
    {
    Write-Host "Dataset '$DatasetName3' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName3 -DefinitionFile $DataSet3fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName3' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName3' creation at " $endTime

$Dataset4Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName4 -ErrorAction SilentlyContinue
if(-not $Dataset4Check)
    {
    Write-Host "Dataset '$DatasetName4' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName4 -DefinitionFile $DataSet4fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName4' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName4' creation at " $endTime

$Dataset4Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName5 -ErrorAction SilentlyContinue
if(-not $Dataset5Check)
    {
    Write-Host "Dataset '$DatasetName5' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName5 -DefinitionFile $DataSet5fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName5' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName5' creation at " $endTime

$Dataset6Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName6 -ErrorAction SilentlyContinue
if(-not $Dataset6Check)
    {
    Write-Host "Dataset '$DatasetName6' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName6 -DefinitionFile $DataSet6fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName6' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName6' creation at " $endTime

$Dataset7Check = Get-AzSynapseDataset -WorkspaceName $azsynapsename  -Name $DatasetName7 -ErrorAction SilentlyContinue
if(-not $Dataset7Check)
    {
    Write-Host "Dataset '$DatasetName7' doesn't exist and will be created"
    Set-AzSynapseDataset -WorkspaceName $azsynapsename -Name $DatasetName7 -DefinitionFile $DataSet7fullpath

    }
else 
    {Write-Host "Dataset '$DatasetName7' already created"}
$endTime = Get-Date
write-host "Ended '$DatasetName7' creation at " $endTime

##########
#Create Pipelines


$Pipeline1Check = Get-AzSynapsePipeline -Name $PipelineName1 -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
if(-not $Pipeline1Check)
    {
    Write-Host "Pipeline '$PipelineName1' doesn't exist and will be created"
    #write-host "basing from '$PLfullpath1' egh"
    Set-AzSynapsePipeline -WorkspaceName $azsynapsename -Name $PipelineName1 -DefinitionFile $PLfullpath1 
    }
else 
    {Write-Host "Pipeline '$PipelineName1' already created"}

$Pipeline2Check = Get-AzSynapsePipeline -Name $PipelineName2 -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
if(-not $Pipeline2Check)
    {
    Write-Host "Pipeline '$PipelineName2' doesn't exist and will be created"
    #write-host "basing from '$PLfullpath2' egh"
    Set-AzSynapsePipeline -WorkspaceName $azsynapsename -Name $PipelineName2 -DefinitionFile $PLfullpath2 
    }
else 
    {Write-Host "Pipeline '$PipelineName2' already created"}

$Pipeline3Check = Get-AzSynapsePipeline -Name $PipelineName3 -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
if(-not $Pipeline3Check)
    {
    Write-Host "Pipeline '$PipelineName3' doesn't exist and will be created"
    #write-host "basing from '$PLfullpath3' egh"
    Set-AzSynapsePipeline -WorkspaceName $azsynapsename -Name $PipelineName3 -DefinitionFile $PLfullpath3 
    }
else 
    {Write-Host "Pipeline '$PipelineName3' already created"}

$Pipeline4Check = Get-AzSynapsePipeline -Name $PipelineName4 -WorkspaceName $azsynapsename -ErrorAction SilentlyContinue
   if(-not $Pipeline4Check)
      {
      Write-Host "Pipeline '$PipelineName4' doesn't exist and will be created"
      #write-host "basing from '$PLfullpath4' egh"
      Set-AzSynapsePipeline -WorkspaceName $azsynapsename -Name $PipelineName4 -DefinitionFile $PLfullpath4 
      }
    else 
   {Write-Host "Pipeline '$PipelineName4' already created"}



 
write-host "Pipeline components build completed at " $endTime