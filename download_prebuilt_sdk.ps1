# create tmp folder
$tmpFolder = New-Item -ItemType Directory -Path "tmp" -Force

# setup download url link and file name
$url = "https://github.com/SnowLeopardEngine/SPhysX/releases/download/v0.1.0_windows/Prebuilt_windows.zip"
$zipFileName = "Prebuilt.zip"

# prepare folder names
$downloadDirectory = $tmpFolder.FullName
$extractDirectory = $downloadDirectory

# if .zip not exist.
if (-not (Test-Path -Path (Join-Path $downloadDirectory $zipFileName))) {
    Write-Host "Start downloading PhysX Prebuilt SDK..."
    # download the file
    Invoke-WebRequest -Uri $url -OutFile (Join-Path $downloadDirectory $zipFileName)
    Write-Host "Finished downloading PhysX Prebuilt SDK."
}

if (-not (Test-Path -Path (Join-Path $extractDirectory "Prebuilt"))) {
    Write-Host "Start extracting PhysX Prebuilt SDK..."
    # extract file
    Expand-Archive -Path (Join-Path $downloadDirectory $zipFileName) -DestinationPath $extractDirectory -Force
    Write-Host "Finished extracting PhysX Prebuilt SDK."
}

if (-not (Test-Path -Path "Prebuilt")) {
    # copy prebuilt files
    Copy-Item -Path (Join-Path $extractDirectory "Prebuilt") -Destination "Prebuilt" -Recurse -Force
    Write-Host "Finished copying PhysX Prebuilt SDK to project root."
}