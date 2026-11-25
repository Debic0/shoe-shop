# Build ShoeStore.exe and the delivery package ShoeStore-release.zip.
# Run from the project root with the virtual environment activated:
#   powershell -ExecutionPolicy Bypass -File build_release.ps1
# NOTE: this file is ASCII-only on purpose (Windows PowerShell 5.1 reads files without BOM as ANSI).
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Check($step) { if ($LASTEXITCODE -ne 0) { throw "Failed at step: $step" } }

Write-Host "1/5 Installing build dependencies"
python -m pip install -r requirements-build.txt; Check "pip install"

Write-Host "2/5 PyInstaller"
python -m PyInstaller ShoeStore.spec --noconfirm --clean; Check "PyInstaller"

Write-Host "3/5 Creating the ShoeStore-release folder"
$release = "ShoeStore-release"
if (Test-Path $release) { Remove-Item $release -Recurse -Force }
New-Item -ItemType Directory -Force -Path `
    "$release\application", "$release\deployment\database", "$release\deployment\docker" | Out-Null

Copy-Item "dist\ShoeStore" "$release\application\ShoeStore" -Recurse
Copy-Item "compose.yaml", ".env.example" "$release\deployment"
Copy-Item "database\shoe_store_docker.sql" "$release\deployment\database"
Copy-Item "docker\db-check" "$release\deployment\docker\db-check" -Recurse
Copy-Item "release_files\README.md", "release_files\config.ini.example", "INSTALL.md" $release

# Secrets must not get into the package: remove the test config.ini copied from dist
Remove-Item "$release\application\ShoeStore\config.ini" -ErrorAction SilentlyContinue
$secrets = Get-ChildItem $release -Recurse -Force |
    Where-Object { $_.Name -in @(".env", "config.ini") -or $_.Name -like "*.dump" }
if ($secrets) { throw "Secrets found in the package: $($secrets.FullName -join ', ')" }

Write-Host "4/5 Creating ShoeStore-release.zip"
if (Test-Path "ShoeStore-release.zip") { Remove-Item "ShoeStore-release.zip" -Force }
Compress-Archive -Path $release -DestinationPath "ShoeStore-release.zip" -Force

Write-Host "5/5 Done: ShoeStore-release.zip (check the archive contents manually)"