<# 
This script helps to update the json files that will be used to create the linked services in ADF. 
After you run this you'll see 3 new json files that will be edited with variable info below. 
#> 

# Azure SQL Server metadata table DB info below 
$azsqlserver = "<logical servername becomes beginning of sql server - bla.database.windows.net>"
$azsqlDB = "<sql database name>"

# Azure Synapse SQL Pool info below 
$azsynapsename = "<Synapse workspace name>"
$synapsepoolname = "<Synapse sql pool name>" 

# ADLS 2 - this will be the ADLS landing area for parquet files
$azstoragename2 = "<ADLS storage account name>"

# The $adminid is a variable that supplies the SQL authentication ID used in linked service
$adminid = "<SQL Server Auth admin ID>"
# Specify file location below where you'll be running the scripts from
$ScriptLoc = "<local file drive holding the script and json files> (i.e. C:\Scripts\)>"


#*****Variables below do not need to be edited*******

$AzureSQLDBLinkedSrvFileName = "AzureSQLDBLinkedService" 
$extension = ".json" 
$bar = 1 
$ADLSGen2LinkedServiceFileName = "ADLSGen2LinkedService"
$bar2 = 1 
$SynapseLinkedServiceFileName = "SynapseLinkedService"
$bar3 = 1




#Update SQLDB Linked Service file 

$assoc = New-Object PSObject -Property @{
    Loc = $ScriptLoc
    File = $AzureSQLDBLinkedSrvFileName
    adm = $extension
}

#Write-Host "$($assoc.Loc) ^^^ $($assoc.File) ^^^ $bar $($assoc.adm)"
$tempfile = "$($assoc.Loc)$($assoc.File)$bar$($assoc.adm)"
$orgfile = "$($assoc.Loc)$($assoc.File)$($assoc.adm)"


(Get-Content $orgfile).replace('***Change This1***', $azsqlserver ) | Set-Content $tempfile; 
$bar = $bar +1 
$tempfile2 = "$($assoc.Loc)$($assoc.File)$bar$($assoc.adm)"

(Get-Content $tempfile).replace('***Change This2***', $azsqlDB ) | Set-Content $tempfile2; 
$bar = $bar +1 
$tempfile3 = "$($assoc.Loc)$($assoc.File)$bar$($assoc.adm)"

(Get-Content $tempfile2).replace('***Change This3***', $adminid ) | Set-Content $tempfile3; 

$tempfilefinal = "$($assoc.Loc)$($assoc.File)Final$($assoc.adm)"

Rename-Item -Path $tempfile3 -NewName $tempfilefinal; 

#Remove temporary files  
Remove-Item $tempfile2; 
Remove-Item $tempfile; 


#Update ADLS Linked Service file 


$assoc2 = New-Object PSObject -Property @{
    Loc = $ScriptLoc
    File = $ADLSGen2LinkedServiceFileName
    adm = $extension
}


$temp2file = "$($assoc2.Loc)$($assoc2.File)$bar2$($assoc2.adm)"
$org2file = "$($assoc2.Loc)$($assoc2.File)$($assoc2.adm)"


$adlsprefix = "https://"
$adldsuffix = ".dfs.core.windows.net/" 

$adlsendpoint = $adlsprefix + $azstoragename2 + $adldsuffix



(Get-Content $org2file).replace('***Change This***', $adlsendpoint ) | Set-Content $temp2file; 
$temp2filefinal = "$($assoc2.Loc)$($assoc2.File)Final$($assoc2.adm)"

Rename-Item -Path $temp2file -NewName $temp2filefinal; 


#Update Synapse Pool Linked Service file 

$assoc3 = New-Object PSObject -Property @{
    Loc = $ScriptLoc
    File = $SynapseLinkedServiceFileName
    adm = $extension
}

$temp3file = "$($assoc3.Loc)$($assoc3.File)$bar3$($assoc3.adm)"
$org3file = "$($assoc3.Loc)$($assoc3.File)$($assoc3.adm)"

Write-Host "org3" $org3file
Write-Host "temp3" $temp3file

(Get-Content $org3file).replace('***Change This1***', $azsynapsename ) | Set-Content $temp3file; 
$bar3 = $bar3 +1 
$temp3file2 = "$($assoc3.Loc)$($assoc3.File)$bar3$($assoc3.adm)"
Write-Host "temp2" $temp3file2
(Get-Content $temp3file).replace('***Change This2***', $synapsepoolname ) | Set-Content $temp3file2; 
$bar3 = $bar3 +1 
$temp3file3 = "$($assoc3.Loc)$($assoc3.File)$bar3$($assoc3.adm)"
Write-Host "temp3" $temp3file3
(Get-Content $temp3file2).replace('***Change This3***', $adminid ) | Set-Content $temp3file3; 

$temp3filefinal = "$($assoc3.Loc)$($assoc3.File)Final$($assoc3.adm)"
Write-Host "final" $temp3filefinal
Rename-Item -Path $temp3file3 -NewName $temp3filefinal; 

#Remove temporary files  
Remove-Item $temp3file; 
Remove-Item $temp3file2; 

