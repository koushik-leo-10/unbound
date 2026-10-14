#Requires -Version 5.1
<#
.SYNOPSIS
  One-click launcher for the Unbound app (server + Flutter web frontend).
  Run this script from the project root: c:\unbond\

.USAGE
  Right-click start_app.ps1 -> "Run with PowerShell"
  OR in a terminal:  cd c:\unbond; .\start_app.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ROOT   = $PSScriptRoot
$SERVER = Join-Path $ROOT 'mindmap_ai_server'
$CLIENT = Join-Path $ROOT 'mindmap_ai_flutter'

function Write-Header { param([string]$m) Write-Host "`n=== $m ===" -ForegroundColor Cyan }
function Write-OK     { param([string]$m) Write-Host "  [OK] $m" -ForegroundColor Green }
function Write-Warn   { param([string]$m) Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Write-Fail   { param([string]$m) Write-Host "  [X]  $m" -ForegroundColor Red }

# --- 1. Prerequisites -------------------------------------------------------
Write-Header "Checking Prerequisites"

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Fail "Flutter not found. Install from: https://docs.flutter.dev/get-started/install/windows"
    Write-Fail "After installing, close and reopen this terminal, then run again."
    Read-Host "Press Enter to exit"
    exit 1
}
$flutterVer = flutter --version 2>&1 | Select-String 'Flutter' | Select-Object -First 1
Write-OK "Flutter: $flutterVer"

if (-not (Get-Command dart -ErrorAction SilentlyContinue)) {
    Write-Fail "Dart SDK not found (should come with Flutter)."
    Read-Host "Press Enter to exit"
    exit 1
}
Write-OK "Dart SDK found"

# --- 2. Fetch Dart/Flutter packages -----------------------------------------
Write-Header "Resolving packages"
Push-Location $ROOT
dart pub get
if ($LASTEXITCODE -ne 0) {
    Write-Fail "dart pub get failed. Check your internet connection and try again."
    Pop-Location; Read-Host "Press Enter to exit"; exit 1
}
Pop-Location
Write-OK "All packages resolved"

# --- 3. Check passwords.yaml ------------------------------------------------
Write-Header "Checking AI configuration"
$pwFile = Join-Path $SERVER 'config\passwords.yaml'
if (-not (Test-Path $pwFile)) {
    Write-Warn "passwords.yaml not found, creating with placeholder values."
    Set-Content -Path $pwFile -Encoding UTF8 -Value @"
# DO NOT COMMIT THIS FILE TO GIT.
# Get a FREE Gemini key (no credit card) at: https://aistudio.google.com/app/apikey
shared:
  openAiApiKey: 'PASTE_YOUR_OPENAI_KEY_HERE'
  geminiApiKey: 'PASTE_YOUR_GEMINI_KEY_HERE'
"@
}
$pwContent = Get-Content $pwFile -Raw
if ($pwContent -match 'PASTE_YOUR') {
    Write-Warn "No AI key configured - app will use built-in offline AI (fully functional)."
    Write-Warn "For smarter suggestions, add a FREE Gemini key:"
    Write-Warn "  https://aistudio.google.com/app/apikey"
} else {
    Write-OK "AI key configured"
}

# --- 4. Free port 8080 and database locks if busy ---------------------------
Write-Header "Checking ports and database state"
$busy = netstat -ano 2>$null | Select-String ':8080\s'
if ($busy) {
    Write-Warn "Port 8080 is in use. Attempting to free it..."
    $busy | ForEach-Object {
        $parts = ($_ -replace '\s+', ' ').Trim() -split ' '
        $procId = $parts[-1]
        if ($procId -match '^\d+$' -and [int]$procId -gt 4) {
            try { Stop-Process -Id ([int]$procId) -Force -ErrorAction SilentlyContinue } catch {}
        }
    }
    Start-Sleep -Seconds 2
    Write-OK "Port 8080 freed"
} else {
    Write-OK "Port 8080 is free"
}

# Clean stale embedded postgres locks if previous run was killed abruptly
Get-Process -Name postgres -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*serverpod*" } | Stop-Process -Force -ErrorAction SilentlyContinue
$runDir = Join-Path $SERVER '.serverpod\development\run'
$pgPid  = Join-Path $SERVER '.serverpod\development\pgdata\postmaster.pid'
if (Test-Path $runDir) { Remove-Item "$runDir\*" -Force -Recurse -ErrorAction SilentlyContinue }
if (Test-Path $pgPid)  { Remove-Item $pgPid -Force -ErrorAction SilentlyContinue }

# --- 5. Start Serverpod backend ---------------------------------------------
Write-Header "Starting backend server"
Write-Host "  Serverpod will apply migrations and start. First run downloads"
Write-Host "  embedded PostgreSQL automatically (may take 1-2 min)." -ForegroundColor Gray

$serverArgs = "-NoExit -Command `"cd '$SERVER'; dart run bin/main.dart --apply-migrations`""
Start-Process powershell -ArgumentList $serverArgs

# Wait up to 60 seconds for port 8080 to open
Write-Host "  Waiting for backend to be ready..." -ForegroundColor Gray
$ready = $false
for ($i = 1; $i -le 60; $i++) {
    Start-Sleep -Seconds 1
    $test = netstat -ano 2>$null | Select-String ':8080\s'
    if ($test) { $ready = $true; break }
    Write-Host "  [$i/60] waiting..." -ForegroundColor DarkGray -NoNewline
    Write-Host "`r" -NoNewline
}
Write-Host ""

if ($ready) {
    Write-OK "Backend is up on http://localhost:8080"
} else {
    Write-Warn "Backend did not appear on port 8080 within 60 s."
    Write-Warn "Check the server terminal window for errors."
}

# --- 6. Launch Flutter web --------------------------------------------------
Write-Header "Starting Flutter web frontend"
Write-Host "  First compile takes 30-60 seconds. App opens at http://localhost:8090" -ForegroundColor Gray

$flutterArgs = "-NoExit -Command `"cd '$CLIENT'; flutter run -d chrome --web-port 8090 --dart-define=SERVER_URL=http://localhost:8080/`""
Start-Process powershell -ArgumentList $flutterArgs

Write-Host ""
Write-OK "Both services started in separate windows."
Write-Host ""
Write-Host "  App URL    : http://localhost:8090" -ForegroundColor White
Write-Host "  Backend URL: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "  To stop: close the two terminal windows that opened." -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to close this launcher"
