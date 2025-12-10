# How to Test the Standalone Executable

This guide shows different ways to verify that `mind_map-mcp-server.exe` is truly standalone and requires no prerequisites.

## Option 1: Ultimate Standalone Test (Recommended - Easiest)

This test removes all development tools from PATH and runs the exe in an isolated environment.

```powershell
.\test-ultimate-standalone.ps1
```

**What it does:**
- ✓ Removes Python, Node.js, npm from PATH temporarily
- ✓ Tests exe with minimal Windows-only PATH
- ✓ Verifies exe size and functionality
- ✓ Automatically restores environment after test
- ✓ **No additional setup required**

## Option 2: Windows Sandbox Test (Most Realistic)

Tests in a completely clean, disposable Windows environment.

**Requirements:**
- Windows 10 Pro/Enterprise/Education OR Windows 11
- Windows Sandbox feature enabled

**How to enable Windows Sandbox:**
1. Open PowerShell as Administrator
2. Run: `Enable-WindowsOptionalFeature -Online -FeatureName 'Containers-DisposableClientVM'`
3. Restart computer
4. Or use: Control Panel → Programs → Turn Windows features on or off → Check "Windows Sandbox"

**Run the test:**
```powershell
.\launch-sandbox-test.ps1
```

Or manually:
```powershell
# Double-click this file:
.\test-sandbox.wsb

# Or run:
Start-Process .\test-sandbox.wsb
```

**What it does:**
- ✓ Launches completely clean Windows installation
- ✓ No Python, Node.js, or any dev tools installed
- ✓ Maps only the exe into the sandbox
- ✓ Automatically runs and tests the exe
- ✓ Sandbox is destroyed after testing (no cleanup needed)

## Option 3: Copy to Another Machine

**Simplest real-world test:**

1. Copy `dist\mind_map-mcp-server.exe` to a USB drive
2. Plug USB into a different computer (preferably one without dev tools)
3. Run the exe:
   ```cmd
   E:\mind_map-mcp-server.exe version --json
   ```

**Target machine should have:**
- ✓ Windows 10 or Windows 11
- ❌ No Python needed
- ❌ No Node.js needed
- ❌ No npm needed

## Option 4: Different User Account

Create a temporary test user without development tools:

```powershell
# As Administrator, create test user
net user testuser Test123! /add

# Log out and log in as testuser
# Copy exe to testuser's desktop
# Run: .\mind_map-mcp-server.exe version --json
```

## Option 5: Virtual Machine

**Most thorough test:**

1. Create a new Windows 10/11 VM (VirtualBox, VMware, Hyper-V)
2. Install **only** Windows (no Visual Studio, Python, Node.js, etc.)
3. Copy the exe to the VM
4. Test it

## Quick Manual Test

If you just want to quickly verify:

```powershell
# Go to dist folder
cd dist

# Test version command
.\mind_map-mcp-server.exe version --json

# Should output JSON with version info
# Exit code should be 0
```

## Expected Results

For ALL tests, the exe should:
- ✓ Run without errors
- ✓ Display version information in JSON format
- ✓ Exit with code 0 (success)
- ✓ Work without Python, Node.js, or npm installed

**Example successful output:**
```json
{
  "success": true,
  "message": "mind_map MCP Server v1.0.0",
  "timestamp": 1734567890,
  "protocol": "stdio",
  "data": {
    "version": "1.0.0",
    "python_version": "3.14.0",
    "platform": "Windows-11-10.0.26200-SP0",
    "protocol": "stdio"
  }
}
```

## Troubleshooting

**Windows Sandbox not available:**
- You need Windows 10 Pro/Enterprise/Education or Windows 11
- Enable virtualization in BIOS
- Use Option 1 (Ultimate Standalone Test) instead

**Access denied errors:**
- Run PowerShell as Administrator for some tests
- Check Windows Defender or antivirus settings

**Exe not found:**
- Build the exe first: `.\build.bat`
- Check that `dist\mind_map-mcp-server.exe` exists

## Summary

**Easiest:** Option 1 - `.\test-ultimate-standalone.ps1`  
**Most Realistic:** Option 2 - Windows Sandbox  
**Most Thorough:** Option 5 - Clean VM  
**Simplest:** Option 3 - Copy to another PC
