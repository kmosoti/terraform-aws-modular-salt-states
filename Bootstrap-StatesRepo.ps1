# Bootstrap-StatesRepo.ps1
# This script sets up the directory structure and placeholder files for the Salt States repository.

$ErrorActionPreference = "Stop"

# Define the directories to create for states
$directories = @(
    "states",
    "states/common",
    "states/roles",
    "states/apps",
    "states/apps/discord-bot",
    "environments",
    "secrets"
)

foreach ($dir in $directories) {
    if (-Not (Test-Path -Path $dir)) {
        Write-Output "Creating directory: $dir"
        New-Item -Path $dir -ItemType Directory | Out-Null
    }
    else {
        Write-Output "Directory already exists: $dir"
    }
}

# Create a top.sls file if it doesn't exist
if (-Not (Test-Path -Path "top.sls")) {
    $topContent = @"
base:
  '*':
    - common
    - roles
    - apps
"@
    Set-Content -Path "top.sls" -Value $topContent
    Write-Output "Created top.sls"
} else {
    Write-Output "top.sls already exists"
}

# Create an init.sls file if it doesn't exist
if (-Not (Test-Path -Path "init.sls")) {
    $initContent = "# This is the root state file for the Salt States repository."
    Set-Content -Path "init.sls" -Value $initContent
    Write-Output "Created init.sls"
} else {
    Write-Output "init.sls already exists"
}

Write-Output "Salt States repository bootstrapping completed."
