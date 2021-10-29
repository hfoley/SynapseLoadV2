
<# 

This will grant storage blob contributor role for mananged service account 
created with Synapse.  It will also grant admin AAD account in the 
paramfile that right as well.  (Could be redundant...I know...but it's needed)
#>
param(
        [Parameter(Mandatory)]
        [string]$filepath
    )


$startTime = Get-Date
$filestuff = (get-content $filepath -raw | ConvertFrom-Json)

$SubscriptionId = $filestuff.SubscriptionId
$resourceGroupName = $filestuff.resourceGroupName
$azstoragename2 = $filestuff.azstoragename2
$azsynapsename = $filestuff.azsynapsename
$adminuser = $filestuff.adminuser

Connect-AzAccount -UseDeviceAuthentication
Select-AzSubscription -SubscriptionId $SubscriptionId


$startTime = Get-Date
Write-Host "The granting of access to $azstoragename2 began at " $startTime

import-module AzureAD.Standard.Preview
AzureAD.Standard.Preview\Connect-AzureAD -Identity -TenantID $env:ACC_TID

$servicePrincipal = Get-AzureADServicePrincipal -Filter "DisplayName eq '$azsynapsename'"
#write-host $servicePrincipal
$ServicePrincipalId = $servicePrincipal.AppId
write-host $ServicePrincipalId 

#Grant permissions to storage for admin user and MSI 
New-AzRoleAssignment -RoleDefinitionName "storage blob data contributor" -ApplicationId $ServicePrincipalId `
-Scope  "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$azstoragename2"

New-AzRoleAssignment -SignInName $adminuser `
    -RoleDefinitionName "storage blob data contributor" `
    -Scope  "/subscriptions/$SubscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$azstoragename2"








