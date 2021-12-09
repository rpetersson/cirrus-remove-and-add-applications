#Applications to uninstall 
#EVERY INventory
#"C:\Program Files\EVRY\Inventory\uninstall.bat"

try {

    $EvryInventoryAgentUninstall = C:\Program Files\EVRY\Inventory\uninstall.bat
    $EvryInventoryAgentUninstall

}
catch {
    Write-Host "An Error occurred: "
    Write-Host $_
}
