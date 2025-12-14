@echo off
REM Interactive Claude Workflow Setup Script
REM This script will guide you through the complete setup process

setlocal enabledelayedexpansion

echo ================================================================
echo        Claude Workflow - Interactive Setup Wizard
echo ================================================================
echo.
echo This wizard will help you set up the Claude Workflow package
echo for your project. I'll ask you a few questions to customize
echo the setup for your needs.
echo.
pause

REM ================================================================
REM Step 1: Project Directory
REM ================================================================
echo.
echo ================================================================
echo Step 1: Project Directory
echo ================================================================
echo.
echo Where do you want to set up the Claude Workflow?
echo (This should be your project root directory)
echo.
set /p "PROJECT_DIR=Enter full path to your project: "

REM Validate project directory
if not exist "%PROJECT_DIR%" (
    echo.
    echo ERROR: Directory does not exist: %PROJECT_DIR%
    echo.
    pause
    exit /b 1
)

echo.
echo Project directory: %PROJECT_DIR%
echo.

REM ================================================================
REM Step 2: Linear Integration
REM ================================================================
echo.
echo ================================================================
echo Step 2: Linear Integration (Optional)
echo ================================================================
echo.
echo Do you want to set up Linear integration?
echo This allows you to manage Linear tickets from Claude Code.
echo.
set /p "USE_LINEAR=Set up Linear? (y/n): "

if /i "%USE_LINEAR%"=="y" (
    echo.
    echo Great! I'll need your Linear API key.
    echo You can get it from: https://linear.app/settings/api
    echo.
    set /p "LINEAR_API_KEY=Enter your Linear API key: "

    if "!LINEAR_API_KEY!"=="" (
        echo.
        echo ERROR: Linear API key cannot be empty
        echo.
        pause
        exit /b 1
    )

    echo.
    echo Linear API key saved: !LINEAR_API_KEY!
    echo.
) else (
    echo.
    echo Skipping Linear setup. You can add it later if needed.
    echo.
)

REM ================================================================
REM Step 3: GitHub Repository
REM ================================================================
echo.
echo ================================================================
echo Step 3: GitHub Repository (Optional)
echo ================================================================
echo.
echo Do you want to configure GitHub repository URLs?
echo This is used for generating links in Linear tickets and documentation.
echo.
set /p "USE_GITHUB=Configure GitHub repository? (y/n): "

if /i "%USE_GITHUB%"=="y" (
    echo.
    echo Enter your GitHub repository information:
    echo (Example: https://github.com/myorg/myrepo)
    echo.
    set /p "GITHUB_ORG=GitHub organization/user: "
    set /p "GITHUB_REPO=GitHub repository name: "

    if "!GITHUB_ORG!"=="" (
        echo ERROR: GitHub organization cannot be empty
        pause
        exit /b 1
    )

    if "!GITHUB_REPO!"=="" (
        echo ERROR: GitHub repository name cannot be empty
        pause
        exit /b 1
    )

    set "GITHUB_URL=https://github.com/!GITHUB_ORG!/!GITHUB_REPO!"
    echo.
    echo GitHub URL: !GITHUB_URL!
    echo.
) else (
    echo.
    echo Skipping GitHub configuration. You can add it later if needed.
    echo.
)

REM ================================================================
REM Step 4: Default Git Branch
REM ================================================================
echo.
echo ================================================================
echo Step 4: Default Git Branch
echo ================================================================
echo.
echo What is your default/main branch name?
echo (Usually 'main' or 'master')
echo.
set /p "DEFAULT_BRANCH=Default branch name [main]: "

if "%DEFAULT_BRANCH%"=="" (
    set "DEFAULT_BRANCH=main"
)

echo.
echo Default branch: %DEFAULT_BRANCH%
echo.

REM ================================================================
REM Step 5: Confirmation
REM ================================================================
echo.
echo ================================================================
echo Setup Summary
echo ================================================================
echo.
echo Project directory: %PROJECT_DIR%
echo Linear integration: %USE_LINEAR%
if /i "%USE_LINEAR%"=="y" (
    echo   API Key: !LINEAR_API_KEY!
)
echo GitHub integration: %USE_GITHUB%
if /i "%USE_GITHUB%"=="y" (
    echo   Repository: !GITHUB_URL!
)
echo Default branch: %DEFAULT_BRANCH%
echo.
echo ================================================================
echo.
set /p "CONFIRM=Proceed with setup? (y/n): "

if /i not "%CONFIRM%"=="y" (
    echo.
    echo Setup cancelled.
    echo.
    pause
    exit /b 0
)

REM ================================================================
REM INSTALLATION BEGINS
REM ================================================================
echo.
echo ================================================================
echo Starting Installation...
echo ================================================================
echo.

REM Step 1: Copy .claude folder
echo [1/6] Copying .claude folder to project...
xcopy /E /I /Y "%~dp0.claude" "%PROJECT_DIR%\.claude"
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy .claude folder
    pause
    exit /b 1
)
echo ✓ .claude folder copied
echo.

REM Step 2: Copy .gitignore
echo [2/6] Setting up .gitignore for security...
if exist "%PROJECT_DIR%\.gitignore" (
    echo Appending to existing .gitignore...
    type "%~dp0.gitignore" >> "%PROJECT_DIR%\.gitignore"
) else (
    echo Creating new .gitignore...
    copy /Y "%~dp0.gitignore" "%PROJECT_DIR%\.gitignore"
)
echo ✓ .gitignore configured
echo.

REM Step 3: Setup Linear if requested
if /i "%USE_LINEAR%"=="y" (
    echo [3/6] Setting up Linear integration...

    REM Install Linear MCP server
    echo Installing Linear MCP server package...
    call npm install -g @modelcontextprotocol/server-linear
    if %errorlevel% neq 0 (
        echo WARNING: Failed to install Linear MCP server
        echo You may need to install it manually later.
    ) else (
        echo ✓ Linear MCP server installed
    )

    REM Create MCP config with user's API key
    echo Creating MCP configuration...
    (
        echo {
        echo   "mcpServers": {
        echo     "linear": {
        echo       "command": "node",
        echo       "args": [
        echo         "%APPDATA%\\npm\\node_modules\\@modelcontextprotocol\\server-linear\\dist\\index.js"
        echo       ],
        echo       "env": {
        echo         "LINEAR_API_KEY": "!LINEAR_API_KEY!"
        echo       }
        echo     }
        echo   }
        echo }
    ) > "%PROJECT_DIR%\.claude\mcp_config.json"

    echo ✓ Linear MCP configuration created
    echo.
) else (
    echo [3/6] Skipping Linear setup (not requested)
    echo.
)

REM Step 4: Configure GitHub URLs if requested
if /i "%USE_GITHUB%"=="y" (
    echo [4/6] Configuring GitHub repository URLs...

    REM Update linear.md with GitHub URLs
    powershell -Command "(Get-Content '%PROJECT_DIR%\.claude\commands\linear.md') -replace 'https://github.com/YOUR_ORG/YOUR_REPO', '!GITHUB_URL!' | Set-Content '%PROJECT_DIR%\.claude\commands\linear.md'"

    echo ✓ GitHub URLs configured in linear.md
    echo.
) else (
    echo [4/6] Skipping GitHub configuration (not requested)
    echo.
)

REM Step 5: Check prerequisites
echo [5/6] Checking prerequisites...
echo.

REM Check git
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ Git is installed
) else (
    echo ✗ Git is NOT installed - required for commit/PR commands
    echo   Download from: https://git-scm.com/download/win
)

REM Check GitHub CLI
gh --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ GitHub CLI (gh) is installed

    REM Check if authenticated
    gh auth status >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✓ GitHub CLI is authenticated
    ) else (
        echo ✗ GitHub CLI is NOT authenticated
        echo   Run: gh auth login
    )
) else (
    echo ✗ GitHub CLI (gh) is NOT installed - required for PR commands
    echo   Download from: https://cli.github.com/
)

REM Check Node.js (for Linear MCP)
if /i "%USE_LINEAR%"=="y" (
    node --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✓ Node.js is installed
    ) else (
        echo ✗ Node.js is NOT installed - required for Linear MCP
        echo   Download from: https://nodejs.org/
    )
)

echo.

REM Step 6: Create setup summary file
echo [6/6] Creating setup summary...

(
    echo # Claude Workflow Setup Summary
    echo.
    echo Generated: %date% %time%
    echo.
    echo ## Configuration
    echo.
    echo - **Project Directory**: %PROJECT_DIR%
    echo - **Default Branch**: %DEFAULT_BRANCH%

    if /i "%USE_LINEAR%"=="y" (
        echo - **Linear Integration**: Enabled
        echo   - API Key: !LINEAR_API_KEY! ^(stored in .claude\mcp_config.json^)
    ) else (
        echo - **Linear Integration**: Not configured
    )

    if /i "%USE_GITHUB%"=="y" (
        echo - **GitHub Repository**: !GITHUB_URL!
    ) else (
        echo - **GitHub Repository**: Not configured
    )

    echo.
    echo ## Next Steps
    echo.
    echo 1. **Restart VS Code** - Required for MCP server changes to take effect
    echo.
    echo 2. **Test basic functionality**:
    echo    ```
    echo    /research_codebase_nt what is the structure?
    echo    ```
    echo.

    if /i "%USE_LINEAR%"=="y" (
        echo 3. **Test Linear integration**:
        echo    ```
        echo    mcp__linear__list_teams
        echo    ```
        echo.
        echo 4. **Get your Linear IDs**:
        echo    - Run: `mcp__linear__list_teams` ^(copy team UUID^)
        echo    - Run: `mcp__linear__list_workflow_states` ^(copy state UUIDs^)
        echo    - Run: `mcp__linear__list_labels` ^(copy label UUIDs^)
        echo    - Run: `mcp__linear__list_users` ^(copy user UUIDs^)
        echo.
        echo 5. **Customize Linear command**:
        echo    - Open: `.claude\commands\linear.md`
        echo    - Replace placeholder IDs with your Linear workspace IDs
        echo    - See: LINEAR-CUSTOMIZATION-CHECKLIST.md for details
        echo.
    )

    echo 6. **Test GitHub integration** ^(if gh CLI is installed^):
    echo    ```
    echo    gh repo view
    echo    ```
    echo.
    echo ## Available Commands
    echo.
    echo - `/research_codebase_nt` - Deep codebase analysis
    echo - `/create_plan_nt` - Create implementation plans
    echo - `/implement_plan` - Execute plans step-by-step
    echo - `/validate_plan` - Verify implementation
    echo - `/commit` - Create git commits
    echo - `/describe_pr_nt` - Generate PR descriptions
    echo - `/debug` - Debug issues systematically

    if /i "%USE_LINEAR%"=="y" (
        echo - `/linear` - Manage Linear tickets ^(after customization^)
    )

    echo.
    echo ## Security Reminders
    echo.
    echo - ✓ Your API keys are protected by .gitignore
    echo - ✓ Do not commit `.claude\mcp_config.json` to git
    echo - ✓ Keep your API keys secure
    echo.
    echo ## Documentation
    echo.
    echo - Quick Start: QUICK-START.md
    echo - Complete Guide: README.md

    if /i "%USE_LINEAR%"=="y" (
        echo - Linear Setup: YOUR-LINEAR-SETUP-SUMMARY.md
        echo - Linear Customization: LINEAR-CUSTOMIZATION-CHECKLIST.md
    )

    echo - Setup Guide: SETUP-GUIDE.md
    echo.
) > "%PROJECT_DIR%\SETUP-SUMMARY.txt"

echo ✓ Setup summary saved to SETUP-SUMMARY.txt
echo.

REM ================================================================
REM INSTALLATION COMPLETE
REM ================================================================
echo.
echo ================================================================
echo        Installation Complete! ✓
echo ================================================================
echo.
echo Your Claude Workflow is now set up in:
echo   %PROJECT_DIR%
echo.
echo ** IMPORTANT: Restart VS Code now! **
echo.
echo After restarting VS Code:
echo 1. Open your project: %PROJECT_DIR%
echo 2. Open Claude Code
echo 3. Test: /research_codebase_nt
echo.

if /i "%USE_LINEAR%"=="y" (
    echo 4. Test Linear: mcp__linear__list_teams
    echo 5. Customize: .claude\commands\linear.md with your Linear IDs
    echo.
)

echo A detailed summary has been saved to:
echo   %PROJECT_DIR%\SETUP-SUMMARY.txt
echo.
echo ================================================================
echo.
pause
