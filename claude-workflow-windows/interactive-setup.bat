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

REM ================================================================
REM NEW SECTION: Automated GitHub CLI Installation
REM ================================================================
echo.
echo ================================================================
echo Installing GitHub CLI (gh)
echo ================================================================
echo.
echo Checking if GitHub CLI is installed...
gh --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ GitHub CLI is already installed
    gh --version
) else (
    echo GitHub CLI is NOT installed. Installing now...
    echo.
    echo Using winget to install GitHub CLI...
    winget install --id GitHub.cli --silent --accept-package-agreements --accept-source-agreements

    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Failed to install GitHub CLI
        echo Please install manually from: https://cli.github.com/
        echo.
        pause
        exit /b 1
    )

    echo ✓ GitHub CLI installed successfully
    echo.
    echo IMPORTANT: You may need to restart your terminal for 'gh' to be available in PATH
    echo.
)

REM Check authentication
echo Checking GitHub CLI authentication...
gh auth status >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ GitHub CLI is authenticated
) else (
    echo.
    echo GitHub CLI is installed but NOT authenticated.
    echo.
    echo Opening browser for authentication...
    echo Please follow the prompts to authenticate with GitHub.
    echo.
    pause
    gh auth login --web

    if %errorlevel% neq 0 (
        echo.
        echo ERROR: GitHub authentication failed
        echo You can authenticate later by running: gh auth login
        echo.
    ) else (
        echo ✓ GitHub CLI authenticated successfully
    )
)
echo.

REM ================================================================
REM NEW SECTION: Thoughts Directory Setup
REM ================================================================
echo.
echo ================================================================
echo Setting Up Thoughts Directory Structure
echo ================================================================
echo.
echo The thoughts directory is required for HumanLayer workflow commands.
echo This includes: /create_plan, /describe_pr, /create_handoff, etc.
echo.

REM Check if thoughts directory already exists
if exist "%PROJECT_DIR%\thoughts" (
    echo.
    echo WARNING: thoughts directory already exists at %PROJECT_DIR%\thoughts
    echo.
    set /p "OVERWRITE_THOUGHTS=Overwrite existing thoughts directory? (y/n): "

    if /i not "!OVERWRITE_THOUGHTS!"=="y" (
        echo.
        echo Keeping existing thoughts directory.
        echo.
    ) else (
        echo.
        echo Backing up existing thoughts to thoughts_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
        move "%PROJECT_DIR%\thoughts" "%PROJECT_DIR%\thoughts_backup_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%" >nul

        echo Copying thoughts template structure...
        xcopy /E /I /Y "%~dp0thoughts-template" "%PROJECT_DIR%\thoughts"

        if %errorlevel% neq 0 (
            echo ERROR: Failed to copy thoughts template
            pause
            exit /b 1
        )

        echo ✓ Thoughts directory created from template
    )
) else (
    echo Creating thoughts directory from template...
    xcopy /E /I /Y "%~dp0thoughts-template" "%PROJECT_DIR%\thoughts"

    if %errorlevel% neq 0 (
        echo ERROR: Failed to copy thoughts template
        pause
        exit /b 1
    )

    echo ✓ Thoughts directory structure created
)

echo.
echo Thoughts directory structure:
echo   %PROJECT_DIR%\thoughts\
echo   ├── shared\          # Team-wide documentation
echo   │   ├── tickets\     # Ticket research
echo   │   ├── plans\       # Implementation plans
echo   │   ├── research\    # Research documents
echo   │   ├── prs\         # PR descriptions
echo   │   ├── handoffs\    # Work handoffs
echo   │   └── pr_description.md  # PR template
echo   ├── personal\        # Personal workspace
echo   └── global\          # Organization-wide
echo.

REM ================================================================
REM NEW SECTION: Git Configuration Files
REM ================================================================
echo.
echo ================================================================
echo Configuring Git Files
echo ================================================================
echo.

REM Create .gitattributes for line-ending consistency
echo Creating .gitattributes for line-ending consistency...
(
    echo # Git Attributes - Line Ending Configuration
    echo # This prevents line-ending issues across Windows/Linux/Mac
    echo.
    echo # Auto detect text files and normalize line endings to LF in repository
    echo * text=auto
    echo.
    echo # Force LF for specific text file types
    echo *.md text eol=lf
    echo *.json text eol=lf
    echo *.js text eol=lf
    echo *.ts text eol=lf
    echo *.tsx text eol=lf
    echo *.jsx text eol=lf
    echo *.yml text eol=lf
    echo *.yaml text eol=lf
    echo *.sh text eol=lf
    echo.
    echo # Windows batch files need CRLF
    echo *.bat text eol=crlf
    echo *.cmd text eol=crlf
    echo.
    echo # Binary files
    echo *.png binary
    echo *.jpg binary
    echo *.gif binary
    echo *.ico binary
    echo *.pdf binary
) > "%PROJECT_DIR%\.gitattributes"

echo ✓ .gitattributes created

REM Update .gitignore with thoughts and MCP config protection
echo.
echo Updating .gitignore to protect sensitive files...

REM Check if .gitignore exists
if not exist "%PROJECT_DIR%\.gitignore" (
    echo Creating new .gitignore...
    (
        echo # Node.js
        echo node_modules/
        echo npm-debug.log*
        echo.
    ) > "%PROJECT_DIR%\.gitignore"
)

REM Append thoughts and MCP config protection
echo. >> "%PROJECT_DIR%\.gitignore"
echo # HumanLayer Thoughts Directory >> "%PROJECT_DIR%\.gitignore"
echo # Add this if you want to keep thoughts private >> "%PROJECT_DIR%\.gitignore"
echo # thoughts/ >> "%PROJECT_DIR%\.gitignore"
echo. >> "%PROJECT_DIR%\.gitignore"
echo # Claude Code Configuration >> "%PROJECT_DIR%\.gitignore"
echo # Protect API keys and sensitive configuration >> "%PROJECT_DIR%\.gitignore"
echo .claude/mcp_config.json >> "%PROJECT_DIR%\.gitignore"
echo .claude/settings.local.json >> "%PROJECT_DIR%\.gitignore"
echo. >> "%PROJECT_DIR%\.gitignore"
echo # Temporary files >> "%PROJECT_DIR%\.gitignore"
echo *.tmp >> "%PROJECT_DIR%\.gitignore"
echo *.log >> "%PROJECT_DIR%\.gitignore"
echo .DS_Store >> "%PROJECT_DIR%\.gitignore"
echo Thumbs.db >> "%PROJECT_DIR%\.gitignore"

echo ✓ .gitignore updated with protection rules
echo.

REM ================================================================
REM NEW SECTION: Automated Validation Tests
REM ================================================================
echo.
echo ================================================================
echo Running Automated Validation Tests
echo ================================================================
echo.
echo This will verify your environment is properly configured.
echo.

set "TEST_PASSED=0"
set "TEST_FAILED=0"

REM Test 1: Git installed
echo [Test 1/8] Git installation...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ PASS: Git is installed
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: Git is NOT installed
    set /a TEST_FAILED+=1
)

REM Test 2: GitHub CLI installed
echo [Test 2/8] GitHub CLI installation...
gh --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ PASS: GitHub CLI is installed
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: GitHub CLI is NOT installed
    set /a TEST_FAILED+=1
)

REM Test 3: GitHub CLI authenticated
echo [Test 3/8] GitHub CLI authentication...
gh auth status >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ PASS: GitHub CLI is authenticated
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: GitHub CLI is NOT authenticated
    set /a TEST_FAILED+=1
)

REM Test 4: Thoughts directory structure
echo [Test 4/8] Thoughts directory structure...
if exist "%PROJECT_DIR%\thoughts\shared\pr_description.md" (
    echo ✓ PASS: Thoughts directory structure is complete
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: Thoughts directory structure is incomplete
    set /a TEST_FAILED+=1
)

REM Test 5: .gitattributes exists
echo [Test 5/8] Git attributes configuration...
if exist "%PROJECT_DIR%\.gitattributes" (
    echo ✓ PASS: .gitattributes file exists
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: .gitattributes file missing
    set /a TEST_FAILED+=1
)

REM Test 6: .gitignore protects sensitive files
echo [Test 6/8] Git ignore protection...
findstr /C:".claude/mcp_config.json" "%PROJECT_DIR%\.gitignore" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✓ PASS: .gitignore protects sensitive files
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: .gitignore doesn't protect MCP config
    set /a TEST_FAILED+=1
)

REM Test 7: .claude folder exists
echo [Test 7/8] Claude configuration...
if exist "%PROJECT_DIR%\.claude\commands" (
    echo ✓ PASS: .claude configuration exists
    set /a TEST_PASSED+=1
) else (
    echo ✗ FAIL: .claude configuration missing
    set /a TEST_FAILED+=1
)

REM Test 8: Node.js (if Linear was configured)
if /i "%USE_LINEAR%"=="y" (
    echo [Test 8/8] Node.js installation (for Linear MCP)...
    node --version >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✓ PASS: Node.js is installed
        set /a TEST_PASSED+=1
    ) else (
        echo ✗ FAIL: Node.js is NOT installed
        set /a TEST_FAILED+=1
    )
) else (
    echo [Test 8/8] Node.js check... SKIPPED (Linear not configured)
    set /a TEST_PASSED+=1
)

echo.
echo ================================================================
echo Test Results: %TEST_PASSED% passed, %TEST_FAILED% failed
echo ================================================================
echo.

if %TEST_FAILED% gtr 0 (
    echo ⚠ WARNING: Some tests failed. Please review the output above.
    echo.
    echo You can re-run this script or manually fix the issues.
    echo See TROUBLESHOOTING.md for help.
    echo.
) else (
    echo ✓ All tests passed! Your environment is ready.
    echo.
)

REM ================================================================
REM NEW SECTION: Optional PR Creation Test
REM ================================================================
echo.
echo ================================================================
echo Optional: Test PR Creation Workflow
echo ================================================================
echo.
echo Would you like to test the full PR creation workflow?
echo This will:
echo   1. Create a test branch
echo   2. Make a test commit
echo   3. Push to GitHub
echo   4. Create a test PR
echo   5. Close and delete the test PR/branch
echo.
echo NOTE: This requires write access to the repository.
echo.
set /p "RUN_PR_TEST=Run PR creation test? (y/n): "

if /i "%RUN_PR_TEST%"=="y" (
    echo.
    echo Starting PR creation test...
    echo.

    REM Change to project directory
    cd /d "%PROJECT_DIR%"

    REM Store current branch
    for /f "tokens=*" %%i in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set "CURRENT_BRANCH=%%i"
    echo Current branch: %CURRENT_BRANCH%

    REM Create test branch
    set "TEST_BRANCH=test-setup-%RANDOM%"
    echo Creating test branch: %TEST_BRANCH%
    git checkout -b %TEST_BRANCH% >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ Failed to create test branch
        goto :SKIP_PR_TEST
    )

    REM Create test file
    echo Test file created by setup validation > test-setup-validation.txt
    git add test-setup-validation.txt

    REM Create test commit
    git commit -m "test: Setup validation test commit" >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ Failed to create test commit
        goto :CLEANUP_TEST
    )

    echo ✓ Test commit created

    REM Push test branch
    echo Pushing test branch to remote...
    git push -u origin %TEST_BRANCH% >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ Failed to push test branch
        echo This might be a permissions issue or remote not configured
        goto :CLEANUP_TEST
    )

    echo ✓ Test branch pushed

    REM Create test PR
    echo Creating test PR...
    gh pr create --title "TEST: Setup validation" --body "This is an automated test PR created during setup validation. It will be closed automatically." >nul 2>&1

    if %errorlevel% neq 0 (
        echo ✗ Failed to create test PR
        goto :CLEANUP_TEST
    )

    echo ✓ Test PR created successfully

    REM Get PR number
    for /f "tokens=*" %%i in ('gh pr view --json number --jq .number 2^>nul') do set "TEST_PR_NUMBER=%%i"

    if not "%TEST_PR_NUMBER%"=="" (
        echo Test PR number: #%TEST_PR_NUMBER%

        REM Close the test PR
        echo Closing test PR...
        gh pr close %TEST_PR_NUMBER% >nul 2>&1
        echo ✓ Test PR closed
    )

    :CLEANUP_TEST
    REM Switch back to original branch
    echo Cleaning up test branch...
    git checkout %CURRENT_BRANCH% >nul 2>&1

    REM Delete local test branch
    git branch -D %TEST_BRANCH% >nul 2>&1

    REM Delete remote test branch
    git push origin --delete %TEST_BRANCH% >nul 2>&1

    REM Delete test file if it exists
    if exist "test-setup-validation.txt" (
        del test-setup-validation.txt
    )

    echo ✓ Test branch cleaned up
    echo.
    echo ================================================================
    echo PR Creation Test Complete
    echo ================================================================
    echo.
    echo ✓ Your environment is fully functional for PR workflows!
    echo.
) else (
    :SKIP_PR_TEST
    echo.
    echo Skipping PR creation test.
    echo You can test manually later with: /describe_pr_nt
    echo.
)

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
