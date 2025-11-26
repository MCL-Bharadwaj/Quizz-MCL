# Execute the views creation script
# This script creates all required database views for the LMS Reports API

$serverName = "mcl-lms-dev"
$databaseName = "postgres"
$adminUser = "mcladmin"
$sqlFile = "C:\CodeRepos\LMS_Azurefunction_App\DatabaseScripts\20_create_views.sql"

Write-Host "Creating database views..." -ForegroundColor Cyan
Write-Host "Server: $serverName" -ForegroundColor Yellow
Write-Host "Database: $databaseName" -ForegroundColor Yellow
Write-Host ""

# Prompt for password securely
$securePassword = Read-Host "Enter database password" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Execute the SQL file
Write-Host "Executing SQL script..." -ForegroundColor Cyan
az postgres flexible-server execute `
    --name $serverName `
    --admin-user $adminUser `
    --admin-password $password `
    --database-name $databaseName `
    --file-path $sqlFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nViews created successfully!" -ForegroundColor Green
    Write-Host "Your Report APIs should now work." -ForegroundColor Green
} else {
    Write-Host "`nError creating views. Exit code: $LASTEXITCODE" -ForegroundColor Red
}

# Clear password from memory
$password = $null
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
