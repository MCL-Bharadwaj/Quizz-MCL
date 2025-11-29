# Execute the user registrations table creation script
# This script creates the user_registrations table for storing registration form submissions

$serverName = "mcl-lms-dev"
$databaseName = "postgres"
$adminUser = "mcladmin"
$sqlFile = "C:\CodeRepos\LMS_Azurefunction_App\DatabaseScripts\21_create_user_registrations_table.sql"

Write-Host "Creating user_registrations table..." -ForegroundColor Cyan
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
    Write-Host "`nTable created successfully!" -ForegroundColor Green
    Write-Host "The user_registrations table is now ready." -ForegroundColor Green
    Write-Host ""
    Write-Host "Verifying table creation..." -ForegroundColor Cyan
    
    # Verify table was created
    $verifyQuery = "SELECT COUNT(*) as column_count FROM information_schema.columns WHERE table_schema = 'lms' AND table_name = 'user_registrations';"
    az postgres flexible-server execute `
        --name $serverName `
        --admin-user $adminUser `
        --admin-password $password `
        --database-name $databaseName `
        --querytext $verifyQuery
} else {
    Write-Host "`nError creating table. Exit code: $LASTEXITCODE" -ForegroundColor Red
}

# Clear password from memory
$password = $null
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
