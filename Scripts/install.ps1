#
# Walnut AI CLI Installer for Windows
# Usage: powershell -c "irm https://raw.githubusercontent.com/walnutai-labs/Walnut-Extension/main/install.ps1 | iex"
#

$ErrorActionPreference = "Stop"

$repo = "walnutai-labs/Walnut-Extension"
# API-free "latest release" asset redirect — avoids the api.github.com rate limit
# (60 req/hour, unauthenticated) that shared networks hit. Requires each release
# to also carry a stable-named walnut-ai.zip asset (scripts/build-release.sh emits
# it). Falls back to the rate-limited API if that asset is missing.
$stableUrl = "https://github.com/$repo/releases/latest/download/walnut-ai.zip"

Write-Host ""
Write-Host "  Walnut AI CLI - Windows Install" -ForegroundColor Yellow
Write-Host ""

# Step 1: Check/install Bun
$bunCmd = Get-Command bun -ErrorAction SilentlyContinue
if ($bunCmd) {
    $bunVersion = & bun --version 2>$null
    Write-Host "  [OK] Bun v$bunVersion found" -ForegroundColor Green
} else {
    Write-Host "  [..] Installing Bun..." -ForegroundColor Cyan
    try {
        irm bun.sh/install.ps1 | iex
    } catch {
        Write-Host "  [!!] Bun install failed. Install manually:" -ForegroundColor Red
        Write-Host "       powershell -c ""irm bun.sh/install.ps1 | iex""" -ForegroundColor Cyan
        exit 1
    }
    $env:BUN_INSTALL = "$env:USERPROFILE\.bun"
    $env:PATH = "$env:BUN_INSTALL\bin;$env:PATH"
    $bunCmd = Get-Command bun -ErrorAction SilentlyContinue
    if (-not $bunCmd) {
        Write-Host "  [!!] Bun not found after install. Restart terminal and retry." -ForegroundColor Red
        exit 1
    }
    Write-Host "  [OK] Bun installed" -ForegroundColor Green
}

# Step 2: Download the latest release
$tmp = Join-Path $env:TEMP ("walnut-ai-" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
$zip = Join-Path $tmp "walnut-ai.zip"

Write-Host "  [..] Downloading latest release..." -ForegroundColor Cyan
$downloaded = $false
try {
    # API-free redirect path — no rate limit.
    Invoke-WebRequest -Uri $stableUrl -OutFile $zip -UseBasicParsing
    $downloaded = $true
} catch {
    Write-Host "  [..] Stable asset not found, querying GitHub API..." -ForegroundColor Cyan
    try {
        $rel = Invoke-RestMethod -Uri "https://api.github.com/repos/$repo/releases/latest" -UseBasicParsing
        $asset = $rel.assets | Where-Object { $_.name -like "*.zip" } | Select-Object -First 1
        if ($asset) {
            Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip -UseBasicParsing
            $downloaded = $true
        }
    } catch {
        Write-Host "  [!!] GitHub API rate limit reached or no release found." -ForegroundColor Red
        Write-Host "       Wait ~an hour, or download manually:" -ForegroundColor Cyan
        Write-Host "       https://github.com/$repo/releases" -ForegroundColor Cyan
        Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
        exit 1
    }
}
if (-not $downloaded) {
    Write-Host "  [!!] No release found at github.com/$repo/releases" -ForegroundColor Red
    Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue
    exit 1
}

# Step 3: Extract
Expand-Archive -Path $zip -DestinationPath $tmp -Force
$srcDir = Join-Path $tmp "walnut-ai"
Write-Host "  [OK] Downloaded" -ForegroundColor Green

# Step 4: Install to ~/.walnut-ai
$installDir = Join-Path $env:USERPROFILE ".walnut-ai"
if (Test-Path $installDir) {
    Remove-Item -Recurse -Force $installDir
}
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
Copy-Item -Path (Join-Path $srcDir "*") -Destination $installDir -Recurse -Force
Write-Host "  [OK] Installed to $installDir" -ForegroundColor Green

# Step 5: Install platform-specific native dependencies.
# The zip ships node_modules from the build OS, so @opentui/core's native binding
# only matches that build. bun install pulls the correct win32-x64 binding.
Write-Host "  [..] Installing native dependencies..." -ForegroundColor Cyan
$bunProc = Start-Process -FilePath "bun" -ArgumentList "install", "--production" -WorkingDirectory $installDir -NoNewWindow -Wait -PassThru -RedirectStandardError "NUL"
if ($bunProc.ExitCode -ne 0) {
    Write-Host "  [!!] bun install failed (exit code $($bunProc.ExitCode))" -ForegroundColor Red
    exit 1
}
Write-Host "  [OK] Dependencies ready" -ForegroundColor Green

# Step 6: Create walnutai.cmd
$bunBin = Join-Path $env:USERPROFILE ".bun\bin"
if (-not (Test-Path $bunBin)) {
    New-Item -ItemType Directory -Path $bunBin -Force | Out-Null
}
$cmdLines = "@echo off"
$cmdLines += "`r`n" + "bun ""$installDir\cli.js"" %*"
Set-Content -Path (Join-Path $bunBin "walnutai.cmd") -Value $cmdLines -Encoding ASCII
Write-Host "  [OK] Created walnutai command" -ForegroundColor Green

# Step 7: Add to PATH if needed
$userPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)
if ($userPath -and (-not $userPath.Contains($bunBin))) {
    [Environment]::SetEnvironmentVariable("PATH", "$bunBin;$userPath", [EnvironmentVariableTarget]::User)
    $env:PATH = "$bunBin;$env:PATH"
    Write-Host "  [OK] Added to PATH" -ForegroundColor Green
}

# Cleanup
Remove-Item -Recurse -Force $tmp -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "  [OK] Walnut AI CLI installed!" -ForegroundColor Green
Write-Host ""
Write-Host "  Close and reopen your terminal, then run:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  walnutai                              Start" -ForegroundColor Cyan
Write-Host "  walnutai --server-url http://...      Connect to server" -ForegroundColor Cyan
Write-Host "  walnutai --help                       Help" -ForegroundColor Cyan
Write-Host ""
Write-Host "  To update: re-run this command" -ForegroundColor Yellow
Write-Host ""
