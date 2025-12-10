# Launcher for Windows Sandbox Test
# This script helps launch the Windows Sandbox test

Write-Host "Windows Sandbox Test Launcher" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Check if Windows Sandbox is available
$sandboxFeature = Get-WindowsOptionalFeature -Online -FeatureName "Containers-DisposableClientVM" -ErrorAction SilentlyContinue

if ($null -eq $sandboxFeature) {
    Write-Host "❌ Windows Sandbox is not available on this system" -ForegroundColor Red
    Write-Host ""
    Write-Host "Windows Sandbox requires:" -ForegroundColor Yellow
    Write-Host "  - Windows 10 Pro/Enterprise/Education (Build 18305+)" -ForegroundColor Gray
    Write-Host "  - Windows 11 (any edition)" -ForegroundColor Gray
    Write-Host "  - Virtualization enabled in BIOS" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To enable Windows Sandbox:" -ForegroundColor Yellow
    Write-Host "  1. Open 'Turn Windows features on or off'" -ForegroundColor Gray
    Write-Host "  2. Check 'Windows Sandbox'" -ForegroundColor Gray
    Write-Host "  3. Restart your computer" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Alternative: Use the ultimate standalone test instead:" -ForegroundColor Cyan
    Write-Host "  .\test-ultimate-standalone.ps1" -ForegroundColor White
    exit 1
}

if ($sandboxFeature.State -ne "Enabled") {
    Write-Host "❌ Windows Sandbox is not enabled" -ForegroundColor Red
    Write-Host ""
    Write-Host "To enable it, run as Administrator:" -ForegroundColor Yellow
    Write-Host "  Enable-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM' -NoRestart" -ForegroundColor White
    Write-Host ""
    Write-Host "Or use Control Panel:" -ForegroundColor Yellow
    Write-Host "  1. Open 'Turn Windows features on or off'" -ForegroundColor Gray
    Write-Host "  2. Check 'Windows Sandbox'" -ForegroundColor Gray
    Write-Host "  3. Restart your computer" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Alternative: Use the ultimate standalone test instead:" -ForegroundColor Cyan
    Write-Host "  .\test-ultimate-standalone.ps1" -ForegroundColor White
    exit 1
}

# Check if exe exists
$exePath = Join-Path $PSScriptRoot "dist\mind_map-mcp-server.exe"
if (-not (Test-Path $exePath)) {
    Write-Host "❌ Executable not found: $exePath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please build the executable first:" -ForegroundColor Yellow
    Write-Host "  .\build.bat" -ForegroundColor White
    exit 1
}

Write-Host "✓ Windows Sandbox is enabled" -ForegroundColor Green
Write-Host "✓ Executable found: $exePath" -ForegroundColor Green
Write-Host ""

# Create WSB file with absolute path
$wsbPath = Join-Path $PSScriptRoot "test-sandbox-auto.wsb"
$distPath = Join-Path $PSScriptRoot "dist"

@"
<Configuration>
  <VGpu>Enable</VGpu>
  <Networking>Enable</Networking>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>$distPath</HostFolder>
      <ReadOnly>true</ReadOnly>
    </MappedFolder>
  </MappedFolders>
  <LogonCommand>
    <Command>powershell.exe -ExecutionPolicy Bypass -Command "cd C:\Users\WDAGUtilityAccount\Desktop\dist; Write-Host '======================================' -ForegroundColor Cyan; Write-Host 'Windows Sandbox - Clean Environment Test' -ForegroundColor Cyan; Write-Host '======================================' -ForegroundColor Cyan; Write-Host ''; Write-Host 'This is a COMPLETELY CLEAN Windows installation' -ForegroundColor Yellow; Write-Host 'No Python, Node.js, or development tools installed' -ForegroundColor Yellow; Write-Host ''; Write-Host 'Testing mind_map-mcp-server.exe...' -ForegroundColor White; Write-Host ''; .\mind_map-mcp-server.exe version --json; if (`$LASTEXITCODE -eq 0) { Write-Host ''; Write-Host '✓ SUCCESS! Exe works in clean environment!' -ForegroundColor Green; Write-Host ''; Write-Host 'The executable is TRULY STANDALONE!' -ForegroundColor Green } else { Write-Host ''; Write-Host '✗ FAILED!' -ForegroundColor Red }; Write-Host ''; Write-Host 'Press any key to close sandbox...' -ForegroundColor Gray; `$null = `$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')"</Command>
  </LogonCommand>
</Configuration>
"@ | Out-File -FilePath $wsbPath -Encoding UTF8

Write-Host "Launching Windows Sandbox..." -ForegroundColor Cyan
Write-Host ""
Write-Host "The sandbox will:" -ForegroundColor White
Write-Host "  1. Start a clean Windows environment" -ForegroundColor Gray
Write-Host "  2. Map the dist folder to the desktop" -ForegroundColor Gray
Write-Host "  3. Automatically test the exe" -ForegroundColor Gray
Write-Host "  4. Show results in the sandbox window" -ForegroundColor Gray
Write-Host ""
Write-Host "Please wait for Windows Sandbox to start..." -ForegroundColor Yellow
Write-Host ""

try {
    Start-Process -FilePath $wsbPath -Wait
    Write-Host "✓ Sandbox test completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to launch sandbox: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try launching manually:" -ForegroundColor Yellow
    Write-Host "  1. Double-click: $wsbPath" -ForegroundColor White
    Write-Host "  2. Or run: Start-Process '$wsbPath'" -ForegroundColor White
}
