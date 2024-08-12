param (
    [string]$EmustationPath,
    [int]$MaxLength = 38
)

function Rename-FilesRecursively {
    param (
        [string]$Directory
    )

    # Check if the directory exists
    if (-Not (Test-Path $Directory)) {
        Write-Host "The specified directory '$Directory' does not exist. Skipping..."
        return
    }

    # Process files in the directory
    Get-ChildItem -Path $Directory -Recurse -File | ForEach-Object {
        # Remove text within parentheses () and brackets []
        $NewName = $_.Name -replace '\s*[\(\[].*?[\)\]]', ''

        # Check if the filename length (without the extension) exceeds the maximum length
        $NameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($NewName)
        if ($NameWithoutExtension.Length -gt $MaxLength) {
            $NameWithoutExtension = $NameWithoutExtension.Substring(0, $MaxLength)
            $Extension = [System.IO.Path]::GetExtension($NewName)
            $NewName = "$NameWithoutExtension$Extension"
        }

        # Rename the file if necessary
        if ($_.Name -ne $NewName) {
            Rename-Item -Path $_.FullName -NewName $NewName
        }
    }
}

Rename-FilesRecursively -Directory $EmustationPath

Write-Host -ForegroundColor Green "File renaming process completed."
