param (
    [string]$EmustationPath
)

# Ensure the path is specified
if (-Not $EmustationPath) {
    Write-Host -ForegroundColor Red "Error: Emustation path is required."
    exit
}

# Check if the path exists
if (-Not (Test-Path $EmustationPath)) {
    Write-Host -ForegroundColor Red "Error: The specified path '$EmustationPath' does not exist."
    exit
}

Write-Host
Write-Host -ForegroundColor Cyan "# Starting to move media folders..."
& ".\_Move-Media.ps1" -EmustationPath $EmustationPath

Write-Host
Write-Host -ForegroundColor Green "Operation completed successfully!"
