
$modules = ("Az.Accounts","Az.Resources","Az.Storage","Az.Synapse","Az.KeyVault")
Write-Host "These modules are installed.  The versions are below."
foreach ($module in $modules)
        {
            if (Get-Module -Name $module -ListAvailable) 
            {
             Get-Module -Name $module -ListAvailable | Select-Object name, version}
            else
            {Write-Host -ForegroundColor Red "$module module does not exist. To install run command: Install-Module -Name $module" } 
        } 

