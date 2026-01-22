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
            $result.Details += "File encoding: UTF-8 with BOM ✓"
        } else {
            $result.Warnings += "File does not have UTF-8 BOM encoding (may cause emoji issues)"
        }
        
        # Parse sections
        $lines = $content -split '[\r\n]+'
        
        # Track sections
        $sectionsFound = @{}
        $currentSection = $null
        $herName = $null
        $anniversaryDate = $null
        $welcomeTimeout = $null
        $messages = @()
        
        foreach ($line in $lines) {
            $line = $line.Trim()
            
            # Track current section
            if ($line -match '^\[([A-Z_]+)\]') {
                $currentSection = $matches[1]
                if (-not $sectionsFound.ContainsKey($currentSection)) {
                    $sectionsFound[$currentSection] = 0
                }
                $sectionsFound[$currentSection]++
                continue
            }
            
            # Skip comments and empty lines
            if ($line -match '^\s*#' -or [string]::IsNullOrWhiteSpace($line)) {
                continue
            }
            
            # Parse based on current section
            if ($currentSection -eq 'USER') {
                if ($line -match '^HER_NAME=(.+)$') {
                    $herName = $Matches[1]
                }
                elseif ($line -match '^WELCOME_TIMEOUT=(\d+)$') {
                    $welcomeTimeout = [int]$Matches[1]
                }
            }
            elseif ($currentSection -eq 'DATES') {
                if ($line -match '^ANNIVERSARY_DATE=(\d{4}-\d{2}-\d{2})$') {
                    try {
                        $date = [DateTime]::ParseExact($Matches[1], "yyyy-MM-dd", $null)
                        $anniversaryDate = $date
                    }
                    catch {
                        $result.Errors += "Invalid ANNIVERSARY_DATE format: '$($Matches[1])' (use YYYY-MM-DD, e.g., 2024-01-06)"
                    }
                }
            }
            elseif ($currentSection -eq 'MESSAGES') {
                if ($line -match '^MESSAGE=(.+)$') {
                    $messages += $Matches[1]
                }
            }
        }
        
        # Validate required sections exist
        if (-not $sectionsFound.ContainsKey('USER')) {
            $result.Errors += "Required section [USER] not found"
        }
        if (-not $sectionsFound.ContainsKey('DATES')) {
            $result.Errors += "Required section [DATES] not found"
        }
        if (-not $sectionsFound.ContainsKey('MESSAGES')) {
            $result.Errors += "Required section [MESSAGES] not found"
        }
        
        # Validate HER_NAME
        if ([string]::IsNullOrWhiteSpace($herName)) {
            $result.Errors += "HER_NAME is required in [USER] section"
        }
        elseif ($herName.Length -gt 100) {
            $result.Errors += "HER_NAME exceeds maximum 100 characters (found: $($herName.Length))"
        }
        else {
            $result.Details += "HER_NAME: '$herName' (length: $($herName.Length))"
        }
        
        # Validate WELCOME_TIMEOUT
        if ($null -eq $welcomeTimeout) {
            $result.Warnings += "WELCOME_TIMEOUT not specified, will default to 20 seconds"
        }
        else {
            if ($welcomeTimeout -lt 5 -or $welcomeTimeout -gt 300) {
                $result.Errors += "WELCOME_TIMEOUT must be between 5-300 seconds (found: $welcomeTimeout)"
            }
            else {
                $result.Details += "WELCOME_TIMEOUT: $welcomeTimeout seconds"
            }
        }
        
        # Validate ANNIVERSARY_DATE
        if ($null -eq $anniversaryDate) {
            $result.Warnings += "ANNIVERSARY_DATE not found in [DATES] section, will use default"
        }
        else {
            # Check if date is in the future
            if ($anniversaryDate -gt (Get-Date)) {
                $result.Errors += "ANNIVERSARY_DATE cannot be in the future (found: $($anniversaryDate.ToString('yyyy-MM-dd')))"
            }
            else {
                $result.Details += "ANNIVERSARY_DATE: $($anniversaryDate.ToString('yyyy-MM-dd'))"
            }
        }
        
        # Validate MESSAGES
        if ($messages.Count -eq 0) {
            $result.Errors += "At least one MESSAGE is required in [MESSAGES] section"
        }
        else {
            $overLengthMessages = $messages | Where-Object { $_.Length -gt 200 }
            
            if ($overLengthMessages.Count -gt 0) {
                $result.Errors += "Found $($overLengthMessages.Count) message(s) exceeding 200 character limit:"
                $overLengthMessages | ForEach-Object {
                    $result.Errors += "  - Length: $($_.Length) chars (max 200)"
                }
            }
            else {
                $result.Details += "Messages: $($messages.Count) valid message(s)"
                $messages | ForEach-Object {
                    $result.Details += "  - $($_.Substring(0, [Math]::Min(50, $_.Length)))$(if($_.Length -gt 50) { '...' })"
                }
            }
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

Write-Host "" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  CONFIG VALIDATION REPORT (v1.2)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "" -ForegroundColor Cyan

if ($result.IsValid) {
    Write-Host "✓ Status: PASSED - Configuration is valid" -ForegroundColor Green
} else {
    Write-Host "✗ Status: FAILED - Configuration has errors" -ForegroundColor Red
}

if ($result.Details) {
    Write-Host "" -ForegroundColor Cyan
    Write-Host "Details:" -ForegroundColor Green
    $result.Details | ForEach-Object { Write-Host "  ✓ $_" -ForegroundColor Green }
}

if ($result.Warnings) {
    Write-Host "" -ForegroundColor Cyan
    Write-Host "Warnings:" -ForegroundColor Yellow
    $result.Warnings | ForEach-Object { Write-Host "  ⚠ $_" -ForegroundColor Yellow }
}

if ($result.Errors) {
    Write-Host "" -ForegroundColor Cyan
    Write-Host "Errors:" -ForegroundColor Red
    $result.Errors | ForEach-Object { Write-Host "  ✗ $_" -ForegroundColor Red }
}

Write-Host "" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan

exit ($result.IsValid ? 0 : 1)