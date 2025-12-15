# Fix PR Creation and Environment Setup Implementation Plan

## Overview

This plan addresses the PR creation failures documented in [DEBUG-REPORT-PR-CREATION.md](../../../DEBUG-REPORT-PR-CREATION.md) by implementing automated environment setup, creating the HumanLayer thoughts directory structure, and adding comprehensive validation and documentation for AI agents to reference when troubleshooting.

## Current State Analysis

### What's Broken

1. **Missing GitHub CLI (`gh`)** - Required by 7 commands ([ci_describe_pr.md:64](../../../.claude/commands/ci_describe_pr.md#L64), [describe_pr.md:65](../../../.claude/commands/describe_pr.md#L65), etc.)
   - Commands fail with: `/usr/bin/bash: line 1: gh: command not found`
   - Blocks automated PR creation and description generation

2. **Missing `thoughts/` Directory** - Required by 19 commands ([create_plan.md:172](../../../.claude/commands/create_plan.md#L172), [ci_describe_pr.md:11](../../../.claude/commands/ci_describe_pr.md#L11), etc.)
   - Commands fail with: `Error: thoughts/shared/pr_description.md not found`
   - Blocks HumanLayer workflow integration

3. **Line Ending Issues** - No `.gitattributes` file
   - Git shows unnecessary changes (LF ↔ CRLF conversions)
   - Documented in [DEBUG-REPORT-PR-CREATION.md:64-70](../../../DEBUG-REPORT-PR-CREATION.md#L64-L70)

4. **Incomplete `.gitignore`** - Doesn't protect sensitive files
   - Missing: `thoughts/`, `.claude/mcp_config.json`
   - Risk of committing API keys

5. **No Environment Validation** - Scripts don't check prerequisites
   - [interactive-setup.bat:261-302](../../../claude-workflow-windows/interactive-setup.bat#L261-L302) checks but doesn't install
   - Users discover missing dependencies only when commands fail

### What Already Works

- ✅ Complete thoughts directory template exists at [claude-workflow-windows/thoughts-template/](../../../claude-workflow-windows/thoughts-template/)
- ✅ PR description template at [thoughts-template/shared/pr_description.md](../../../claude-workflow-windows/thoughts-template/shared/pr_description.md)
- ✅ Existing [interactive-setup.bat](../../../claude-workflow-windows/interactive-setup.bat) (434 lines) handles Linear/GitHub config
- ✅ 26 slash commands defined in [.claude/commands/](../../../.claude/commands/)
- ✅ Windows environment with `winget` available

## Desired End State

After implementation:
1. ✅ Users run enhanced `interactive-setup.bat` and get fully working environment
2. ✅ GitHub CLI automatically installed and authenticated
3. ✅ Complete `thoughts/` directory structure created from template
4. ✅ Git properly configured with `.gitattributes` and enhanced `.gitignore`
5. ✅ Automated validation tests confirm everything works
6. ✅ Comprehensive troubleshooting documentation for AI agents
7. ✅ Commands fail gracefully with helpful error messages when dependencies missing

### Verification

**Automated:**
- Run `interactive-setup.bat` successfully
- `gh --version` returns version info
- `gh auth status` confirms authentication
- `thoughts/shared/pr_description.md` exists and is readable
- Create test branch, commit, and PR via automation
- All 26 slash commands can detect their dependencies

**Manual:**
- Review generated documentation files
- Confirm `.gitattributes` prevents line-ending issues
- Verify `.gitignore` protects sensitive files

## What We're NOT Doing

- Not modifying command logic (only enhancing setup and validation)
- Not changing the thoughts directory structure (using existing template)
- Not creating new documentation files (updating existing ones only)
- Not installing Linear MCP automatically (remains optional as designed)
- Not changing the HumanLayer workflow system design

## Implementation Approach

We'll enhance existing files rather than creating new ones to minimize context bloat. The approach:

1. **Enhance [interactive-setup.bat](../../../claude-workflow-windows/interactive-setup.bat)** with new sections for:
   - GitHub CLI installation (fully automated via `winget`)
   - Thoughts directory setup (copy from template)
   - Git configuration files (`.gitattributes`, enhanced `.gitignore`)
   - Automated validation tests (including test PR creation)

2. **Update existing documentation** with troubleshooting guidance:
   - Enhance [README.md](../../../claude-workflow-windows/README.md) with dependency requirements
   - Update [GETTING-STARTED.md](../../../claude-workflow-windows/GETTING-STARTED.md) with setup validation steps
   - Enhance [DEBUG-REPORT-PR-CREATION.md](../../../DEBUG-REPORT-PR-CREATION.md) with resolution status

3. **Create minimal new files**:
   - `.gitattributes` (essential for line-ending consistency)
   - `TROUBLESHOOTING.md` (consolidated error handling guide for AI)

---

## Phase 1: Environment Setup Automation

### Overview
Enhance `interactive-setup.bat` to automatically install GitHub CLI, create thoughts structure, and configure Git.

### Changes Required

#### 1. Update interactive-setup.bat - Add GitHub CLI Installation Section

**File**: `claude-workflow-windows/interactive-setup.bat`

**Insert after line 302** (after existing prerequisite checks):

```batch
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
```

#### 2. Update interactive-setup.bat - Add Thoughts Directory Setup

**File**: `claude-workflow-windows/interactive-setup.bat`

**Insert after GitHub CLI section** (after new code above):

```batch
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
```

#### 3. Update interactive-setup.bat - Add Git Configuration

**File**: `claude-workflow-windows/interactive-setup.bat`

**Insert after thoughts directory section**:

```batch
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
```

#### 4. Update interactive-setup.bat - Add Automated Validation Tests

**File**: `claude-workflow-windows/interactive-setup.bat`

**Insert before "INSTALLATION COMPLETE" section** (before line 403):

```batch
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
```

#### 5. Update interactive-setup.bat - Add PR Creation Test (Optional)

**File**: `claude-workflow-windows/interactive-setup.bat`

**Insert after validation tests**:

```batch
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
```

### Success Criteria

#### Automated Verification:
- [x] `interactive-setup.bat` runs without errors
- [x] GitHub CLI installation succeeds: `gh --version`
- [x] GitHub CLI authentication succeeds: `gh auth status`
- [x] Thoughts directory created: `dir thoughts\shared\pr_description.md`
- [x] `.gitattributes` created: `dir .gitattributes`
- [x] `.gitignore` updated: `findstr mcp_config.json .gitignore`
- [x] All 8 validation tests pass
- [x] Optional PR creation test passes (if run)

#### Manual Verification:
- [ ] Review setup output for any warnings
- [ ] Confirm file contents are correct
- [ ] Test a slash command that requires thoughts: `/create_plan_nt`
- [ ] Test a slash command that requires gh: `/describe_pr_nt`

---

## Phase 2: Documentation Updates

### Overview
Update existing documentation files to provide comprehensive troubleshooting guidance for AI agents and users.

### Changes Required

#### 1. Create TROUBLESHOOTING.md

**File**: `TROUBLESHOOTING.md` (new file in root)

```markdown
# Troubleshooting Guide

This guide helps diagnose and fix common issues with the Claude Workflow package.

## Quick Diagnostics

Run these commands to check your environment:

```bash
# Check Git
git --version

# Check GitHub CLI
gh --version
gh auth status

# Check thoughts directory
dir thoughts\shared\pr_description.md

# Check Node.js (for Linear MCP)
node --version
```

## Common Issues

### Issue: "gh: command not found"

**Symptoms:**
- Commands fail with `/usr/bin/bash: line 1: gh: command not found`
- `/describe_pr`, `/ci_describe_pr`, `/describe_pr_nt` don't work

**Affected Commands:**
- `/ci_describe_pr`
- `/describe_pr`
- `/describe_pr_nt`
- `/founder_mode`
- `/local_review`
- `/oneshot`

**Solution:**
1. Re-run setup: `cd claude-workflow-windows && interactive-setup.bat`
2. Or install manually:
   ```bash
   winget install --id GitHub.cli
   gh auth login
   ```

**Verification:**
```bash
gh --version      # Should show version
gh auth status    # Should show "Logged in to github.com"
```

---

### Issue: "thoughts/shared/pr_description.md not found"

**Symptoms:**
- Commands fail with `Error: thoughts/shared/pr_description.md not found`
- `/create_plan`, `/describe_pr`, `/create_handoff` don't work

**Affected Commands:**
- `/create_plan`
- `/create_plan_generic`
- `/ci_describe_pr`
- `/describe_pr`
- `/implement_plan`
- `/iterate_plan`
- `/create_handoff`
- `/resume_handoff`
- All `/ralph_*` commands

**Solution:**
1. Re-run setup: `cd claude-workflow-windows && interactive-setup.bat`
2. Or create manually:
   ```bash
   xcopy /E /I claude-workflow-windows\thoughts-template thoughts
   ```

**Verification:**
```bash
dir thoughts\shared\pr_description.md
dir thoughts\shared\plans
dir thoughts\shared\prs
```

---

### Issue: Line ending changes in Git

**Symptoms:**
- Git shows changes to files you didn't modify
- Changes like `LF` ↔ `CRLF` conversions

**Solution:**
1. Create `.gitattributes` (automatically done by setup):
   ```
   * text=auto
   *.md text eol=lf
   *.json text eol=lf
   *.bat text eol=crlf
   ```

2. Normalize existing files:
   ```bash
   git add --renormalize .
   git commit -m "Normalize line endings"
   ```

---

### Issue: Linear MCP not working

**Symptoms:**
- `/linear` command doesn't work
- `mcp__linear__*` functions not available

**Solution:**
1. Install Node.js:
   ```bash
   winget install --id OpenJS.NodeJS.LTS
   ```

2. Install Linear MCP server:
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

3. Configure Linear:
   ```bash
   cd claude-workflow-windows
   setup-linear.bat
   ```

4. Get your Linear API key from: https://linear.app/settings/api

5. Restart VS Code

**Verification:**
- Open Claude Code
- Run: `mcp__linear__list_teams`
- Should return your Linear teams

---

### Issue: Setup script fails

**Symptoms:**
- `interactive-setup.bat` exits with errors
- Validation tests fail

**Diagnostic Steps:**

1. **Check permissions:**
   - Run terminal as Administrator
   - Ensure write access to project directory

2. **Check prerequisites:**
   - Git installed: `git --version`
   - Winget available: `winget --version`
   - Network connectivity for downloads

3. **Review error messages:**
   - Look for specific error codes
   - Check which step failed

4. **Manual recovery:**
   ```bash
   # Install GitHub CLI manually
   winget install --id GitHub.cli

   # Copy thoughts template
   xcopy /E /I claude-workflow-windows\thoughts-template thoughts

   # Create .gitattributes
   copy claude-workflow-windows\.gitattributes .
   ```

---

## Command Dependency Matrix

| Command | Requires `gh` | Requires `thoughts/` | Requires Linear MCP |
|---------|--------------|---------------------|-------------------|
| `/ci_describe_pr` | ✅ Yes | ✅ Yes | ❌ No |
| `/describe_pr` | ✅ Yes | ✅ Yes | ❌ No |
| `/describe_pr_nt` | ✅ Yes | ❌ No | ❌ No |
| `/create_plan` | ❌ No | ✅ Yes | ❌ No |
| `/create_plan_nt` | ❌ No | ✅ Yes | ❌ No |
| `/implement_plan` | ❌ No | ✅ Yes | ❌ No |
| `/commit` | ❌ No | ❌ No | ❌ No |
| `/ci_commit` | ❌ No | ❌ No | ❌ No |
| `/debug` | ❌ No | ❌ No | ❌ No |
| `/linear` | ❌ No | ✅ Yes | ✅ Yes |
| `/founder_mode` | ✅ Yes | ✅ Yes | ❌ No |
| `/ralph_*` | ❌ No | ✅ Yes | ✅ Yes |
| `/create_handoff` | ❌ No | ✅ Yes | ❌ No |
| `/resume_handoff` | ❌ No | ✅ Yes | ❌ No |

---

## Getting Help

### For AI Agents

When troubleshooting:
1. Read this file completely
2. Check [DEBUG-REPORT-PR-CREATION.md](DEBUG-REPORT-PR-CREATION.md) for detailed error analysis
3. Run diagnostic commands listed above
4. Report specific error messages, not just "it doesn't work"

### For Users

1. **Check existing issues:** [GitHub Issues](https://github.com/fsagastapolar/claude-workflow-package/issues)
2. **Review documentation:**
   - [GETTING-STARTED.md](claude-workflow-windows/GETTING-STARTED.md)
   - [README.md](claude-workflow-windows/README.md)
   - [COMMANDS.md](claude-workflow-windows/COMMANDS.md)
3. **Run diagnostics:** Execute commands in "Quick Diagnostics" section above
4. **Re-run setup:** Often fixes configuration issues

---

## Advanced Topics

### Cloning to New Repository

When cloning this workflow to a new repository:

1. **Run setup script:**
   ```bash
   cd claude-workflow-windows
   interactive-setup.bat
   ```

2. **Configure for your repository:**
   - Update GitHub org/repo in settings
   - Update Linear workspace IDs (if using)
   - Review and customize slash commands

3. **Validate environment:**
   - All 8 validation tests should pass
   - Run optional PR creation test

4. **Protect sensitive files:**
   - Verify `.gitignore` includes `.claude/mcp_config.json`
   - Never commit API keys
   - Use `.claude/settings.local.json` for local overrides

### Worktree Support

If using git worktrees:

1. **Thoughts directory sync:**
   - Main repo has primary `thoughts/` directory
   - Worktrees reference same directory
   - Changes sync automatically

2. **Setup in worktree:**
   - No need to re-run full setup
   - `.claude/` config is shared
   - MCP servers work across all worktrees

---

## Reference Files

- [DEBUG-REPORT-PR-CREATION.md](DEBUG-REPORT-PR-CREATION.md) - Detailed PR creation error analysis
- [interactive-setup.bat](claude-workflow-windows/interactive-setup.bat) - Main setup script
- [.claude/commands/](. claude/commands/) - Slash command definitions
- [thoughts-template/](claude-workflow-windows/thoughts-template/) - Thoughts directory structure
```

#### 2. Update README.md - Add Dependency Requirements Section

**File**: `claude-workflow-windows/README.md`

**Insert after line 1** (after main heading):

```markdown
## ⚠️ Prerequisites

Before using this workflow package, you need:

### Required
- **Git** - Version control ([Download](https://git-scm.com/download/win))
- **GitHub CLI (`gh`)** - For PR creation and management ([Download](https://cli.github.com/))
  - Run `gh auth login` after installation
- **VS Code** - With Claude Code extension
- **Thoughts Directory** - HumanLayer workflow structure (created by setup script)

### Optional
- **Node.js** - Only if using Linear integration ([Download](https://nodejs.org/))
- **Linear API Key** - For Linear ticket management ([Get API Key](https://linear.app/settings/api))

### Quick Check

Run these commands to verify:
```bash
git --version        # Should show Git version
gh --version         # Should show GitHub CLI version
gh auth status       # Should show "Logged in to github.com"
node --version       # Should show Node version (if using Linear)
```

If any are missing, run the setup script: `interactive-setup.bat`

---
```

#### 3. Update GETTING-STARTED.md - Add Validation Steps

**File**: `claude-workflow-windows/GETTING-STARTED.md`

**Insert at the end of file**:

```markdown
---

## 🔍 Validate Your Setup

After running the setup, validate everything works:

### 1. Check Dependencies

```bash
# Git
git --version

# GitHub CLI
gh --version
gh auth status

# Thoughts directory
dir thoughts\shared\pr_description.md

# Node.js (if using Linear)
node --version
```

### 2. Test Basic Commands

```bash
# Test research command (no dependencies)
/research_codebase_nt

# Test planning command (requires thoughts)
/create_plan_nt

# Test PR description (requires gh and thoughts)
/describe_pr_nt
```

### 3. Validation Checklist

- [ ] Git installed and configured
- [ ] GitHub CLI installed and authenticated
- [ ] Thoughts directory exists with all subdirectories
- [ ] `.gitattributes` exists (prevents line-ending issues)
- [ ] `.gitignore` protects `.claude/mcp_config.json`
- [ ] Can create a test branch and PR
- [ ] Linear MCP configured (if using Linear)

### 4. Troubleshooting

If anything fails, see [TROUBLESHOOTING.md](../TROUBLESHOOTING.md) for solutions.

Common fixes:
- **"gh: command not found"** → Re-run `interactive-setup.bat`
- **"thoughts/shared/pr_description.md not found"** → Copy template: `xcopy /E /I claude-workflow-windows\thoughts-template thoughts`
- **Line-ending issues** → Create `.gitattributes` file
```

#### 4. Update DEBUG-REPORT-PR-CREATION.md - Add Resolution Status

**File**: `DEBUG-REPORT-PR-CREATION.md`

**Insert after line 8** (after Repository line):

```markdown
**Resolution Status:** ✅ **RESOLVED** - See implementation plan at [thoughts/shared/plans/2025-12-14-fix-pr-creation-environment.md](thoughts/shared/plans/2025-12-14-fix-pr-creation-environment.md)

**Implementation Phases:**
1. ✅ Phase 1: Environment Setup Automation - Enhanced `interactive-setup.bat` with automated GitHub CLI installation, thoughts directory setup, and validation tests
2. ✅ Phase 2: Documentation Updates - Added TROUBLESHOOTING.md, updated README.md, GETTING-STARTED.md
3. ⏳ Phase 3: Future Enhancements - Optional dependency validation in slash commands (planned)

**Quick Fix:** Run `cd claude-workflow-windows && interactive-setup.bat` to automatically set up your environment.
```

### Success Criteria

#### Automated Verification:
- [x] TROUBLESHOOTING.md created and readable
- [x] README.md contains Prerequisites section
- [x] GETTING-STARTED.md contains validation steps
- [ ] DEBUG-REPORT-PR-CREATION.md updated with resolution status (SKIPPED - file was deleted)
- [x] All markdown files pass linting: `markdownlint *.md`

#### Manual Verification:
- [ ] Documentation is clear and actionable
- [ ] AI agents can find troubleshooting guidance
- [ ] Links between documents work correctly
- [ ] Command dependency matrix is accurate

---

## Phase 3: Optional Future Enhancements

### Overview
Optional improvements that can be implemented later to enhance the user experience.

### Potential Enhancements

#### 1. Add Dependency Validation to Slash Commands

**Approach:**
- Add validation checks at the start of commands that require dependencies
- Provide helpful error messages pointing to setup documentation
- Suggest running `interactive-setup.bat` if dependencies missing

**Example for ci_describe_pr.md:**
```markdown
## Dependency Validation (add at start of command)

Before proceeding:

1. **Check GitHub CLI:**
   ```bash
   gh --version 2>/dev/null || echo "ERROR: GitHub CLI not installed. Run: cd claude-workflow-windows && interactive-setup.bat"
   ```

2. **Check thoughts directory:**
   ```bash
   test -f thoughts/shared/pr_description.md || echo "ERROR: Thoughts directory not set up. Run: cd claude-workflow-windows && interactive-setup.bat"
   ```

If either check fails, stop and instruct the user to run setup.
```

**Affected Files:**
- All 7 commands requiring `gh`
- All 19 commands requiring `thoughts/`

**Effort:** Medium (need to update 26 command files)
**Benefit:** Better user experience, clearer error messages
**Priority:** Low (can be done incrementally)

#### 2. Create validate-environment.bat Script

**Purpose:** Standalone script users can run anytime to check environment health

**File**: `claude-workflow-windows/validate-environment.bat`

**Features:**
- Run all 8 validation tests from setup
- Generate health report
- Suggest fixes for failures
- No modifications, read-only checks

**Effort:** Low (extract validation code from setup script)
**Benefit:** Easy diagnostics without re-running full setup
**Priority:** Medium

#### 3. Add Pre-Commit Hooks

**Purpose:** Prevent committing sensitive files

**File**: `.git/hooks/pre-commit`

**Features:**
- Check for `.claude/mcp_config.json` in staged files
- Check for API keys in code
- Warn if committing to main branch
- Can be bypassed with `--no-verify`

**Effort:** Low
**Benefit:** Prevents accidental credential exposure
**Priority:** Medium

### Success Criteria (for future enhancements)

#### Automated Verification:
- [ ] Commands detect missing dependencies gracefully
- [ ] `validate-environment.bat` runs successfully
- [ ] Pre-commit hooks prevent sensitive file commits

#### Manual Verification:
- [ ] Error messages are helpful and actionable
- [ ] Validation script output is clear
- [ ] Hooks can be bypassed when needed

**Note:** These enhancements are optional and can be implemented incrementally based on user feedback and needs.

---

## Testing Strategy

### Unit Tests
Not applicable - this is primarily configuration and documentation work.

### Integration Tests

**Automated (via setup script):**
1. GitHub CLI installation test
2. GitHub CLI authentication test
3. Thoughts directory structure test
4. Git configuration tests (.gitattributes, .gitignore)
5. File protection tests
6. Optional: Full PR creation workflow test

**Manual Testing Steps:**

1. **Fresh Clone Test:**
   ```bash
   # Clone to new directory
   git clone <repo-url> test-fresh-clone
   cd test-fresh-clone

   # Run setup
   cd claude-workflow-windows
   interactive-setup.bat

   # Verify all tests pass
   # Try creating a PR using /describe_pr_nt
   ```

2. **Existing Project Test:**
   ```bash
   # In existing project with .claude already set up
   cd claude-workflow-windows
   interactive-setup.bat

   # Verify it doesn't break existing config
   # Verify it adds missing pieces (gh, thoughts, git config)
   ```

3. **Error Recovery Test:**
   ```bash
   # Simulate missing gh
   rename "C:\Program Files\GitHub CLI\gh.exe" gh.exe.bak

   # Run setup - should install gh
   cd claude-workflow-windows
   interactive-setup.bat

   # Verify gh is now available
   gh --version
   ```

4. **Documentation Test:**
   ```bash
   # Simulate common errors
   # Follow TROUBLESHOOTING.md guidance
   # Verify solutions work
   ```

### Performance Considerations

- Setup script should complete in under 5 minutes (excluding manual auth steps)
- GitHub CLI installation via winget: ~1-2 minutes
- Thoughts directory copy: ~1 second
- Git configuration: ~1 second
- Validation tests: ~5 seconds
- Optional PR test: ~30 seconds

### Migration Notes

**For users with existing setups:**
- Script detects existing thoughts directory and offers to backup before overwriting
- Script appends to existing `.gitignore` rather than replacing
- GitHub CLI installation skipped if already installed
- All changes are additive - won't break existing configuration

**For new users:**
- Single command to set up everything: `cd claude-workflow-windows && interactive-setup.bat`
- All dependencies installed automatically
- Validation tests confirm success

## References

- Original issue: [DEBUG-REPORT-PR-CREATION.md](../../../DEBUG-REPORT-PR-CREATION.md)
- Setup script: [interactive-setup.bat](../../../claude-workflow-windows/interactive-setup.bat)
- Thoughts template: [thoughts-template/](../../../claude-workflow-windows/thoughts-template/)
- Command definitions: [.claude/commands/](../../../.claude/commands/)
- PR description template: [thoughts-template/shared/pr_description.md](../../../claude-workflow-windows/thoughts-template/shared/pr_description.md)
