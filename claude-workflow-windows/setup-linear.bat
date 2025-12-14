@echo off
REM Linear MCP Server Setup Script - PROJECT-SPECIFIC VERSION
REM This script sets up Linear MCP for the CURRENT PROJECT ONLY

echo ========================================
echo Linear MCP Server Setup - Project Only
echo ========================================
echo.
echo This will configure Linear MCP for this project only.
echo Other projects will NOT have Linear MCP enabled.
echo.

REM Get current directory
set "PROJECT_DIR=%CD%"
echo Current project: %PROJECT_DIR%
echo.

REM Step 1: Install Linear MCP Server (globally - but only used when configured)
echo [Step 1/3] Installing Linear MCP Server package...
echo Note: Package installed globally, but only enabled for this project
call npm install -g @modelcontextprotocol/server-linear
if %errorlevel% neq 0 (
    echo ERROR: Failed to install Linear MCP server
    pause
    exit /b 1
)
echo ✓ Linear MCP server package installed
echo.

REM Step 2: Ensure .claude directory exists in project
echo [Step 2/3] Checking .claude directory in project...
if not exist ".claude" (
    echo ERROR: .claude directory not found in current project
    echo Please run this script from your project root where .claude exists
    echo Or copy the .claude folder first: cp -r claude-workflow-windows\.claude .
    pause
    exit /b 1
)
echo ✓ .claude directory found
echo.

REM Step 3: Copy MCP configuration to PROJECT .claude directory
echo [Step 3/3] Configuring Linear MCP for THIS PROJECT ONLY...
copy /Y "LINEAR-MCP-CONFIG.json" ".claude\mcp_config.json"
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy configuration file
    pause
    exit /b 1
)
echo ✓ MCP configuration saved to .claude\mcp_config.json
echo.

echo ========================================
echo Setup Complete! ✓
echo ========================================
echo.
echo Linear MCP is now configured for THIS PROJECT ONLY:
echo   %PROJECT_DIR%\.claude\mcp_config.json
echo.
echo Other projects will NOT have Linear MCP enabled.
echo.
echo Next steps:
echo 1. Restart VS Code completely
echo 2. Open THIS project in Claude Code
echo 3. Test with: mcp__linear__list_teams
echo 4. Get your Linear IDs
echo 5. Customize .claude\commands\linear.md with your IDs
echo 6. Test with: /linear
echo.
echo ⚠ SECURITY: Do not commit .claude\mcp_config.json to git!
echo   (Already protected by .gitignore)
echo.
pause
