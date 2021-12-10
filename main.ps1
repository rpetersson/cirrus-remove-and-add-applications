Write-host "Login to your AZ Account"
Login-AzAccount

$subscriptionId = "afa13944-29a5-4287-952f-06b37e702385" #Azure Subscription I want to use

#$resourceGroup = "rg-test-migrate" #Resource Group my VMs are in

Set-AzContext -Subscription $subscriptionId #Select the right Azure subscription

#Get all Azure VMs which are in running state and are running Windows in a RG
#$myAzureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}


$myAzureVMs = Get-AzVM -status | Where-Object {$_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

#Run the script against all VMs in parallel
try {
    $myAzureVMs | ForEach-Object -Parallel {
        $out = Invoke-AzVMRunCommand `
            -ResourceGroupName $_.ResourceGroupName `
            -Name $_.Name  `
            -CommandId 'RunPowerShellScript' `
            -ScriptPath .\hello.ps1 `
            -ErrorAction Stop
        #Formating the Output with the VM name
        
            $output = $_.Name + " " + $out.Value[0].Message
            $output 
        }   
}
catch {
    Write-Warning -Message "Oops something bad happend"
    Write-Warning -Message $Error[0]
}