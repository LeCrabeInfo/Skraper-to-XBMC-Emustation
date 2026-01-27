param (
    [string]$EmustationPath
)

# Ensure the path is specified
if (-Not $EmustationPath) {
    Write-Host -ForegroundColor Red "Error: Emustation path is required."
    exit
}

# Get the media directory path
$MediaPath = Join-Path $EmustationPath "media"

# Get all system directories inside emustation\roms
$RomsPath = Join-Path $EmustationPath "roms"
$SystemDirs = Get-ChildItem -Path $RomsPath -Directory

foreach ($SystemDir in $SystemDirs) {
    $SourceMediaPath = Join-Path $SystemDir.FullName "media"
    $DestinationPath = Join-Path $MediaPath $SystemDir.Name

    # Check if media folder exists
    if (-Not (Test-Path $SourceMediaPath)) {
        Write-Host -ForegroundColor Yellow "Warning: media folder not found in $($SystemDir.FullName). Skipping..."
        continue
    }

    # Create the destination folder
    if (-Not (Test-Path $DestinationPath)) {
        New-Item -Path $DestinationPath -ItemType Directory | Out-Null
    }

    # Move the media files
    Get-ChildItem -Path $SourceMediaPath | Move-Item -Destination $DestinationPath

    # Delete media folder
    Remove-Item -Path $SourceMediaPath -Force
}

Write-Host -ForegroundColor Green "media folders have been moved successfully."
