Write-host "Login to your AZ Account"
Login-AzAccount

$subscriptionId = "afa13944-29a5-4287-952f-06b37e702385" #Azure Subscription I want to use

$resourceGroup = "rg-test-migrate" #Resource Group my VMs are in

Set-AzContext -Subscription $subscriptionId #Select the right Azure subscription

#Get all Azure VMs which are in running state and are running Windows
$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}
Write-Host $myAzureVMs

#Run the script against all VMs in parallel
$myAzureVMs | ForEach-Object -Parallel {
    Write-Host "Running scripts..."
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath .\hello.ps1
}

#Formating the Output with the VM name
$output = $_.Name + " " + $out.Value[0].Message
$output