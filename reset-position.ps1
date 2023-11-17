# PowerShell script to modify 'window-position' in 'config.json'

# If YouTube Music is in your 2nd (extended) monitor when you unplug it, it will open in the 1st monitor (main) out of view
# This script pulls the X value back to a comfortable 100px from the left edge of the screen

# Define the path to the config.json file using the %APPDATA% environment variable
$jsonFilePath = Join-Path $env:APPDATA "youtube-music-desktop-app\config.json"
# Define the path to the YouTube Music Desktop App executable using the %LOCALAPPDATA% environment variable
$appPath = Join-Path $env:LOCALAPPDATA "Programs\youtube-music-desktop-app\YouTube Music Desktop App.exe"

# Check if the file exists
if (Test-Path $jsonFilePath) {
    # Read the file and convert from JSON
    $jsonData = Get-Content $jsonFilePath -Raw | ConvertFrom-Json

    # Check if 'window-position' property exists
    if ($jsonData.'window-position') {
        # Replace the 'x' value - replace [value] with your desired number
        $jsonData.'window-position'.x = 100

        # Convert back to JSON and write to the file
        $jsonData | ConvertTo-Json | Set-Content $jsonFilePath
        Write-Host "Window position updated successfully."
    }
    else {
        Write-Host "'window-position' property not found in the JSON file."
    }
}
else {
    Write-Host "The specified config.json file does not exist at the path: $jsonFilePath"
}

# Check if the application is running and stop it
Get-Process | Where-Object { $_.Path -eq $appPath } | Stop-Process -Force

# Wait a moment to ensure the process has completely terminated
Start-Sleep -Seconds 2

# Start the application again
Start-Process $appPath

Write-Host "YouTube Music Desktop App has been restarted."
