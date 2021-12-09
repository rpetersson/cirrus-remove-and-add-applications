#Test to say hello

try {
    Write-Host "Hello"
}
catch {
    Write-Host "An Error occurred: "
    Write-Host $_
}
