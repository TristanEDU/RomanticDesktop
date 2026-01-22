# CONFIG_VALIDATOR.ps1
# Validates Romantic Customization config.txt file
# UTF-8 with BOM encoding

[CmdletBinding()]
param([string]$ConfigFile)

function Test-RomanticConfig {
    param([string]$ConfigPath)
    
    $result = @{
        IsValid   = $true
        Errors    = @()
        Warnings  = @()
        Details   = @()
    }
    
    if (-not (Test-Path $ConfigPath)) {
        $result.IsValid = $false
        $result.Errors += "File does not exist: $ConfigPath"
        return [PSCustomObject]$result
    }
    
    try {
        $content = Get-Content $ConfigPath -Raw -ErrorAction Stop
        
        # Check UTF-8 encoding
        $bytes = [System.IO.File]::ReadAllBytes($ConfigPath)
        $hasUtf8Bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
        
        if ($hasUtf8Bom) {
            $result.Details += " File encoding: UTF-8 with BOM"
        }
        
        # Parse sections
        $lines = $content -split "\?\
"
        $herName = $null
        $anniversaryDate = $null
        $messageCount = 0
        
        foreach ($line in $lines) {
            $line = $line.Trim()
            
            if ($line -match '^HER_NAME=(.+)$') {
                $herName = $Matches[1]
            }
            elseif ($line -match '^ANNIVERSARY_DATE=(\d{4}-\d{2}-\d{2})$') {
                try {
                    $date = [DateTime]::ParseExact($Matches[1], "yyyy-MM-dd", $null)
                    $anniversaryDate = $Matches[1]
                }
                catch {
                    $result.Errors += "Invalid date format: $($Matches[1])"
                }
            }
            elseif ($line -match '^MESSAGE=(.+)$') {
                $messageCount++
            }
        }
        
        if ([string]::IsNullOrWhiteSpace($herName)) {
            $result.Errors += "HER_NAME is required"
        }
        elseif ($herName.Length -gt 100) {
            $result.Errors += "HER_NAME exceeds 100 characters"
        }
        else {
            $result.Details += " HER_NAME: '$herName'"
        }
        
        if ($null -eq $anniversaryDate) {
            $result.Warnings += "ANNIVERSARY_DATE not found, will use default"
        }
        else {
            $result.Details += " ANNIVERSARY_DATE: $anniversaryDate"
        }
        
        if ($messageCount -eq 0) {
            $result.Errors += "At least one MESSAGE is required"
        }
        else {
            $result.Details += " Found $messageCount message(s)"
        }
    }
    catch {
        $result.Errors += "Error reading file: $_"
    }
    
    if ($result.Errors.Count -gt 0) {
        $result.IsValid = $false
    }
    
    return [PSCustomObject]$result
}

if ($ConfigFile -eq "") {
    $ConfigFile = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "config.txt"
}

$result = Test-RomanticConfig -ConfigPath $ConfigFile

Write-Host "
" -ForegroundColor Cyan
Write-Host "CONFIG VALIDATION REPORT" -ForegroundColor Cyan
Write-Host "
" -ForegroundColor Cyan

if ($result.IsValid) {
    Write-Host "Status:  PASSED" -ForegroundColor Green
} else {
    Write-Host "Status:  FAILED" -ForegroundColor Red
}

if ($result.Details) {
    Write-Host "
Details:" -ForegroundColor Green
    $result.Details | ForEach-Object { Write-Host "  $_" }
}

if ($result.Warnings) {
    Write-Host "
Warnings:" -ForegroundColor Yellow
    $result.Warnings | ForEach-Object { Write-Host "   $_" }
}

if ($result.Errors) {
    Write-Host "
Errors:" -ForegroundColor Red
    $result.Errors | ForEach-Object { Write-Host "   $_" }
}

Write-Host "

" -ForegroundColor Cyan

exit ($result.IsValid ? 0 : 1)