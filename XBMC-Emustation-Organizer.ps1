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

# Script paths
$ScriptRoot = $PSScriptRoot
$MoveMediaScript = Join-Path $ScriptRoot "_Move-Media.ps1"
$GenerateSynopsisScript = Join-Path $ScriptRoot "_Generate-Synopsis.ps1"
$RenameFilesScript = Join-Path $ScriptRoot "_Rename-Files.ps1"

Write-Host
Write-Host -ForegroundColor Cyan "# Starting to move media folders..."
& $MoveMediaScript -EmustationPath $EmustationPath

Write-Host
Write-Host -ForegroundColor Cyan "# Starting to generate synopsis files..."
& $GenerateSynopsisScript -EmustationPath $EmustationPath

Write-Host
Write-Host -ForegroundColor Cyan "# Starting to rename files..."
& $RenameFilesScript -EmustationPath $EmustationPath

Write-Host
Write-Host -ForegroundColor Green "Operation completed successfully!"
