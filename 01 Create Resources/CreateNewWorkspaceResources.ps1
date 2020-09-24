<# Update the variables section appropriately for your environment.  
Update any reference to ***Change This*** in the variables #>
$startTime = Get-Date
$SubscriptionId = '<Azure subscription id>'
$resourceGroupName = "<Resource group name>"
$resourceGroupLocation = "<Resource group location>" 

#SQL variables
$azsqlserver = "<logical servername - bla.database.windows.net>"
$azsqlDB = "<sql database name>"
$edition = "Standard"
$ComputeGen = "Gen5"
$SerivceObjective = "S0"

#ADLS 2
$azstoragename2 = "<ADLS storage account name>"
$containername2 = "<container name>" 
$SKUName = "Standard_GRS"
$storagekind = "StorageV2"

#Synapse variables 
$azsynapsename = "<Synapse workspace name>"
$azstoragename = "<ADLS storage for use with the Synapse workspace"
$containername = "<container for the above storage>" 
$SKUName = "Standard_GRS"
$storagekind = "StorageV2"
#Firewall to connect to Synapse workspace 
$firewallrulename = "UserClientIP"
#SQLPool 
$synapsepoolname = "<Synapse sql pool name>" 
$perflevel = "DW100c" 


Connect-AzAccount
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
    New-AzSqlServer -ResourceGroupName $resourceGroupName -Location $resourceGroupLocation -ServerName $azsqlserver -ServerVersion "12.0" -SqlAdministratorCredentials (Get-Credential)
    }
else 
    {Write-Host "SQL Server '$azsqlserver' already created"}


$SQLDBCheck = Get-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $azsqlserver -DatabaseName $azsqlDB -ErrorAction SilentlyContinue
if(-not $SQLDBCheck)
    {
    Write-Host "SQL DB '$azsqlDB' doesn't exist and will be created"
    New-AzSqlDatabase -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -DatabaseName $azsqlDB -RequestedServiceObjectiveName $SerivceObjective
    #Use below syntax if prefer vCore
    #New-AzSqlDatabase -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -DatabaseName $azsqlDB -ComputeModel $ComputeModel -Edition $edition -ComputeGeneration $ComputeGen
    }
else 
    {Write-Host "SQL DB '$azsqlDB' already created"}

$endTime = Get-Date
write-host "Ended SQL Server and DB creation at " $endTime

New-AzSqlServerFirewallRule -ResourceGroupName $resourceGroupName  -ServerName $azsqlserver -AllowAllAzureIPs

$startTime = Get-Date
#$azstoragename = "hopemadedisadls2"
#$containername = "hopemadediscont2" 
#$SKUName = "Standard_GRS"
#$storagekind = "StorageV2"
Write-Host "The Azure ADLS Gen 2 Storage creation script was started " $startTime

$ADLSCheck = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $azstoragename2 -ErrorAction SilentlyContinue
if(-not $ADLSCheck)
    {
    Write-Host "The ADLS storage '$azstoragename2' doesn't exist and will be created"
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $azstoragename2 -Location $resourceGroupLocation -SkuName $SKUName -Kind $storagekind  -EnableHierarchicalNamespace $true
     $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containername2 -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containername2' doesn't exist and will be created"
            New-AzStorageContainer -Name $containername2 -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containername2' already there"
            }
    }
else 
    {
    Write-Host "The ADLS storage '$azstoragename2' already created"
        $ctx = New-AzStorageContext -StorageAccountName $azstoragename2 -UseConnectedAccount
        $ContCheck = Get-AzStorageContainer -Name $containername2 -Context $ctx -ErrorAction SilentlyContinue
        if(-not $ContCheck)
            {
            Write-Host "The ADLS storage container '$containername2' doesn't exist and will be created"
            New-AzStorageContainer -Name $containername2 -Context $ctx
            }
            else
            {
            Write-Host "The ADLS storage container '$containername2' already there"
            }
    }



Write-Host "The Azure Synapse Workspace script was started " $startTime

$SynapseCheck =  Get-AzSynapseWorkspace -ResourceGroupName $ResourceGroupName -Name $azsynapsename -ErrorAction SilentlyContinue
if(-not $SynapseCheck)
    {
    Write-Host "Synapse workspace '$azsynapsename' doesn't exist and will be created"
    New-AzSynapseWorkspace -ResourceGroupName $resourceGroupName -Name $azsynapsename -Location $resourceGroupLocation -DefaultDataLakeStorageAccountName $azstoragename -DefaultDataLakeStorageFilesystem $containername -SqlAdministratorLoginCredential (Get-Credential)
    }
else 
    {Write-Host "Synapse workspace '$azsynapsename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse workspace creation script at " $endTime

$startTime = Get-Date
#$firewallrulename = "HopeClientIP"


#Add client IP to workspace 

$clientip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip


$firewallrule = Get-AzSynapseFirewallRule -ResourceGroupName $resourceGroupName -WorkspaceName $azsynapsename
$startip = $firewallrule.StartIpAddress



if(-not $firewallrule)
    {
    Write-Host "Synapse workspace firewall '$firewallrulename' doesn't exist and will be created"
    New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -Name $firewallrulename -StartIpAddress $clientip -EndIpAddress $clientip 
    }
else 
    {Write-Host "Synapse workspace firewall '$firewallrulename'  already created"}

$endTime = Get-Date
write-host "Ended Synapse firewall rule creation script at " $endTime

New-AzSynapseFirewallRule -WorkspaceName $azsynapsename -AllowAllAzureIP

$startTime = Get-Date
#$synapsepoolname = "hopemaddispool" 
#$perflevel = "DW100c" 

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

