<# This file is driven by parameter file passed.  
There is a sample starting one in the github repo called paramfile.json 
You'll need to update that file and pass when running this script. 
Put all the files in the same folder as the paramfile.  

Tips: Storage requires lowercase only in naming 
Tips: Synapse SQL Pools have to be 15 or less characters 
Tips: prefix should be small 3-5 characters to not cause issues with rules for storage for example

You can run this script by sample syntax locally below: 
& "C:\PSScripts\01 - CreateSynLoadResources.ps1" -filepath "C:\PSScripts\paramfile01.json"

You can run this script by sample syntax below in Azure Cloud Shell: 
./"01 - CreateSynLoadResources.ps1" -filepath ./paramfile01.json
 #>

param(
        [Parameter(Mandatory)]
        [string]$filepath
    )

$startTime = Get-Date
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

$SubscriptionId = $filestuff.SubscriptionId
$resourceGroupName = $filestuff.resourceGroupName
$resourceGroupLocation = $filestuff.resourceGroupLocation 


#SQL variables
$azsqlserver = $filestuff.azsqlserver 
$azsqlDB = $filestuff.azsqlDB 
#$edition = $filestuff.edition 
#$ComputeGen = $filestuff.ComputeGen 
$ServiceObjective = $filestuff.ServiceObjective

#Synapse variables 
$azsynapsename = $filestuff.azsynapsename
$azstoragename = $filestuff.azstoragename
$containersys = $filestuff.containersys
$SKUName = $filestuff.SKUName 
$storagekind = $filestuff.storagekind 
$ManagedVirtualNetwork = $filestuff.ManagedVirtualNetwork 
$adminuser = $filestuff.adminuser 
$tenantid = $filestuff.tenantid

#Firewall to connect to Synapse workspace 
$firewallrulename = $filestuff.firewallrulename  
$shellfirewallname = $filestuff.shellfirewallname
$clientip = $filestuff.clientip

#ADLS 2 - this will be the ADLS landing area for parquet files
$azstoragename2 = $filestuff.azstoragename2 

#Synapse dedicated SQL pool creation
$synapsepoolname = $filestuff.synapsepoolname
$perflevel = $filestuff.poolperflevel

#below probably remove 
$containername1 = $filestuff.containername1
$containername2 = $filestuff.containername2
$containersys = $filestuff.containersys

#####################variables below do not need updated
#Connect-AzAccount
Connect-AzAccount -UseDeviceAuthentication

Select-AzSubscription -SubscriptionId $SubscriptionId
Write-Host "The resource group creation script was started " $startTime
$RGCheck = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(-not $RGCheck)
    {
    Write-Host "Resource group '$resourceGroupName' doesn't exist and will be created"
    New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
    }
else 
    {Write-Host "Resource group '$resourceGroupName' already created"}
$endTime = Get-Date
write-host "Ended resource group creation at " $endTime


$startTime = Get-Date


Write-Host "The Azure SQL Server and DB creation script was started " $startTime

$SQLServerCheck = Get-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $azsqlserver -ErrorAction SilentlyContinue
if(-not $SQLServerCheck)
    {
    Write-Host "SQL Server '$azsqlserver' doesn't exist and will be created"
    New-AzSqlServer -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -ServerName $azsqlserver -ServerVersion "12.0" -SqlAdministratorCredentials (Get-Credential -Message "SQL Server admin user/password.")
    }
else 
    {Write-Host "SQL Server '$azsqlserver' already created"}


$SQLDBCheck = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $azsqlserver -DatabaseName $azsqlDB -ErrorAction SilentlyContinue
if(-not $SQLDBCheck)
    {
    Write-Host "SQL DB '$azsqlDB' doesn't exist and will be created"
    New-AzSqlDatabase -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -DatabaseName $azsqlDB -RequestedServiceObjectiveName $ServiceObjective
    #Use below syntax if prefer vCore
    #New-AzSqlDatabase -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -DatabaseName $azsqlDB -ComputeModel $ComputeModel -Edition $edition -ComputeGeneration $ComputeGen
    }
else 
    {Write-Host "SQL DB '$azsqlDB' already created"}

$endTime = Get-Date
write-host "Ended SQL Server and DB creation at " $endTime

New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -AllowAllAzureIPs 

$startTime = Get-Date

Write-Host "The Azure ADLS Gen 2 Sys Storage creation script was started " $startTime

$ADLSCheck = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $azstoragename -ErrorAction SilentlyContinue
if(-not $ADLSCheck)
    {
    Write-Host "The ADLS storage '$azstoragename' doesn't exist and will be created"
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $azstoragename -Location $resourceGroupLocation -SkuName $SKUName -Kind $storagekind  -EnableHierarchicalNamespace $true
     $ctx = New-AzStorageContext -StorageAccountName $azstoragename -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containersys -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containersys' doesn't exist and will be created"
            New-AzStorageContainer -Name $containersys -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containersys' already there"
            }
    }
else 
    {
    Write-Host "The ADLS storage '$azstoragename' already created"
        $ctx = New-AzStorageContext -StorageAccountName $azstoragename -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containersys -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containersys' doesn't exist and will be created"
            New-AzStorageContainer -Name $containersys -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containersys' already there"
            }
    }


<# Main secondary ADLS to use for data and containers used. #>
$ADLSCheck2 = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $azstoragename2 -ErrorAction SilentlyContinue
if(-not $ADLSCheck2)
    {
    Write-Host "The ADLS storage '$azstoragename2' doesn't exist and will be created"
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $azstoragename2 -Location $resourceGroupLocation -SkuName $SKUName -Kind $storagekind  -EnableHierarchicalNamespace $true 
     $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containername1 -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containername1' doesn't exist and will be created"
            New-AzStorageContainer -Name $containername1 -Context $ctx
            New-AzStorageContainer -Name $containername2 -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containername1' already there"
            }
    }
else 
    {
    Write-Host "The ADLS storage '$azstoragename2' already created"
        $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
       
    }

Write-Host "The Azure Synapse Workspace script was started " $startTime

$SynapseCheck =  Get-AzSynapseWorkspace -ResourceGroupName $ResourceGroupName -Name $azsynapsename -ErrorAction SilentlyContinue
if(-not $SynapseCheck)
    {
    Write-Host "Synapse workspace '$azsynapsename' doesn't exist and will be created"
    $config = New-AzSynapseManagedVirtualNetworkConfig -AllowedAadTenantIdsForLinking $tenantid
    New-AzSynapseWorkspace -ResourceGroupName $resourceGroupName -Name $azsynapsename -Location $resourceGroupLocation -DefaultDataLakeStorageAccountName $azstoragename -DefaultDataLakeStorageFilesystem $containersys -SqlAdministratorLoginCredential (Get-Credential -Message "Supply value for Synapse sql admin user and password.") -ManagedVirtualNetwork $config
    }
else 
    {Write-Host "Synapse workspace '$azsynapsename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse workspace creation script at " $endTime
$startTime = Get-Date
Write-Host "The firewall rules creation was started " $startTime

<# Adding of firewall rule to allow client IP address avoid errors in Synapse Studio #>
$firewallrule = Get-AzSynapseFirewallRule -ResourceGroupName $resourceGroupName -WorkspaceName $azsynapsename -Name $firewallrulename -ErrorAction SilentlyContinue
if(-not $firewallrule)
    {
    Write-Host "Synapse workspace firewall '$firewallrulename' doesn't exist and will be created"
    New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -Name $firewallrulename -StartIpAddress $clientip -EndIpAddress $clientip 
    }
else 
    {Write-Host "Synapse workspace firewall '$firewallrulename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse firewall rule creation script at " $endTime


<# Adding of firewall rule to allow cloudshell IP address avoid errors in Synapse Studio #>
$shellclientip = Invoke-RestMethod http://ipinfo.io/json | Select-Object -exp ip
$shellfirewallrule = Get-AzSynapseFirewallRule -ResourceGroupName $resourceGroupName -WorkspaceName $azsynapsename -Name $shellfirewallname -ErrorAction SilentlyContinue
if(-not $shellfirewallrule)
    {
    Write-Host "Synapse workspace firewall '$shellfirewallname' doesn't exist and will be created"
    New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -Name $shellfirewallname -StartIpAddress $shellclientip -EndIpAddress $shellclientip 
    }
else 
    {
    Update-AzSynapseFirewallRule -WorkspaceName $azsynapsename -Name $shellfirewallname -StartIpAddress $shellclientip -EndIpAddress $shellclientip
    Write-Host "Synapse workspace firewall '$shellfirewallname'  already created"
    }

#New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -AllowAllAzureIP

$startTime = Get-Date

Write-Host "The Azure Synapse SQL Pool script was started " $startTime

$SynapsePoolCheck = Get-AzSynapseSqlPool -WorkspaceName $azsynapsename -Name $synapsepoolname -ErrorAction SilentlyContinue
if(-not $SynapsePoolCheck)
    {
    Write-Host "Synapse pool '$synapsepoolname' doesn't exist and will be created"
    New-AzSynapseSqlPool -WorkspaceName $azsynapsename -Name $synapsepoolname -PerformanceLevel $perflevel
    }
else 
    {Write-Host "Synapse sql pool '$synapsepoolname'  already created"}

$endTime = Get-Date
write-host "Ended Synapse sql pool creation script at " $endTime

#> 
write-host "Total resources creation script finish at " $endTime

