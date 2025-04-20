Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Get source and target paths from environment variables
$sourcePath = $env:SOURCE_PATH
$targetPath = $env:TARGET_PATH

# Check if environment variables are set
if (-not $sourcePath -or -not $targetPath) {
    Write-Host "Error: SOURCE_PATH or TARGET_PATH environment variables are not set."
    exit 1
}


# Start the Docker container in detached mode
Start-Process -NoNewWindow -FilePath "docker" -ArgumentList "run", "--name", "gomachine", "--mount", "type=bind,source=$sourcePath,target=$targetPath", "-P", "gomachine"

# Exit PowerShell
exit
