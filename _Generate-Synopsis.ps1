param (
    [string]$EmustationPath
)

# Ensure the path is specified
if (-Not $EmustationPath) {
    Write-Host -ForegroundColor Red "Error: Emustation path is required."
    exit
}

# Get the synopsis directory path
$SynopsisPath = Join-Path $EmustationPath "synopsis"

# Clear the synopsis directory if it exists
if (Test-Path $SynopsisPath) {
    Write-Host -ForegroundColor Yellow "Clearing existing synopsis directory: $SynopsisPath"
    Remove-Item -Path $SynopsisPath\* -Recurse -Force
}

# Get all system directories inside emustation\roms
$RomsPath = Join-Path $EmustationPath "roms"
$SystemDirs = Get-ChildItem -Path $RomsPath -Directory

foreach ($SystemDir in $SystemDirs) {
    $GamelistPath = Join-Path $SystemDir.FullName "gamelist.xml"
    $DestinationPath = Join-Path $EmustationPath "synopsis\$($SystemDir.Name)"

    # Check if gamelist.xml file exists
    if (-Not (Test-Path $GamelistPath)) {
        Write-Host -ForegroundColor Yellow "Warning: gamelist.xml not found in $($SystemDir.FullName). Skipping..."
        continue
    }

    # Create the destination folder
    if (-Not (Test-Path $DestinationPath)) {
        New-Item -Path $DestinationPath -ItemType Directory | Out-Null
    }
    
    $TextName = "Name: unknown"
    $TextDescription = "_________________________`n"
    $TextRating = "Rating: unknown"
    $TextReleaseDate = "Released: unknown"
    $TextDeveloper = "Developer: unknown"
    $TextPublisher = "Publisher: unknown"
    $TextGenre = "Genre: unknown"
    $TextPlayers = "Players: at least 1"

    $InputData = Get-Content -Path $GamelistPath

    foreach ($Line in $InputData) {
        if ($Line -match "<path>(.*?)</path>") {
            $TextFilename = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&' -replace '\+', '_'
            $TextFilename = $TextFilename.Trim()
            $BaseName, $Ext = [System.IO.Path]::GetFileNameWithoutExtension($TextFilename), [System.IO.Path]::GetExtension($TextFilename)
            $TextFilenameExt = "Filename: " + $BaseName
        }

        if ($Line -match "<name>(.*?)</name>") {
            $TextName = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextName = 'Name: ' + $TextName
            if ($TextName -eq "Name: ") {
                $TextName = "Name: " + $BaseName
            }
        }

        if ($Line -match "<desc>(.*?)</desc>") {
            $TextDescription = $matches[1] -replace '&amp;quot;', '"' -replace '&#39;', "'" -replace '&amp;', '&' -replace 'quot;', '"' -replace '&#xD;&#xA;', '[CR]' -replace '&#xA;&#xA;', '[CR]' -replace '&#xD;&#xD;', '[CR]' -replace '&#xA;', '[CR]' -replace '&#xD;', '[CR]'
            $TextDescription = "_________________________`n" + $TextDescription
        }

        if ($Line -match "<rating>(.*?)</rating>") {
            $TextRating = $matches[1]
            $TextRating = 'Rating: ' + $TextRating
            if ($TextRating -eq "Rating: ") {
                $TextRating = "Rating: unknown"
            }
        }

        if ($Line -match "<releasedate>(.*?)</releasedate>") {
            $TextReleaseDate = $matches[1] -replace 'T.*$', ''
            $TextReleaseDateYear = $TextReleaseDate.Substring(0, 4)
            $TextReleaseDate = 'Release Year: ' + $TextReleaseDateYear
            if ($TextReleaseDate -eq "Release Year: .." -or $TextReleaseDate -eq "Release Year: ") {
                $TextReleaseDate = "Released: unknown"
            }
        }

        if ($Line -match "<developer>(.*?)</developer>") {
            $TextDeveloper = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextDeveloper = 'Developer: ' + $TextDeveloper
            if ($TextDeveloper -eq "Developer: ") {
                $TextDeveloper = "Developer: unknown"
            }
        }

        if ($Line -match "<publisher>(.*?)</publisher>") {
            $TextPublisher = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextPublisher = 'Publisher: ' + $TextPublisher
            if ($TextPublisher -eq "Publisher: ") {
                $TextPublisher = "Publisher: unknown"
            }
        }

        if ($Line -match "<genre>(.*?)</genre>") {
            $TextGenre = $matches[1] -replace '&#39;', "'" -replace '&amp;', '&'
            $TextGenre = 'Genre: ' + $TextGenre
            if ($TextGenre -eq "Genre: ") {
                $TextGenre = "Genre: unknown"
            }
        }

        if ($Line -match "<players>(.*?)</players>") {
            $TextPlayers = $matches[1]
            $TextPlayers = 'Players: ' + $TextPlayers
            if ($TextPlayers -eq "Players: ") {
                $TextPlayers = "Players: unknown"
            }
        }

        if ($BaseName) {
            $OutputFilePath = Join-Path -Path $DestinationPath -ChildPath ($BaseName + '.txt')
            $OutputContent = @(
                $TextFilenameExt
                $TextName
                $TextRating
                $TextReleaseDate
                $TextDeveloper
                $TextPublisher
                $TextGenre
                $TextPlayers
                $TextDescription
            )
            $OutputContent | Set-Content -Path $OutputFilePath
        }
    }

    # Delete gamelist.xml file
    Remove-Item -Path $GamelistPath -Force
}

Write-Host -ForegroundColor Green "Synopsis files have been generated successfully."
