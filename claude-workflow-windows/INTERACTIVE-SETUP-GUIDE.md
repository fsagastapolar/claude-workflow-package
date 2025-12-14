# Interactive Setup Guide

## Overview

The **Interactive Setup Wizard** (`interactive-setup.bat`) guides you through the complete Claude Workflow setup process with a series of questions. No need to manually edit configuration files or understand the technical details upfront!

## What the Setup Wizard Does

### It Will Ask You:

1. **Project Directory** - Where to install the workflow
2. **Linear Integration** - Whether you want Linear integration
   - If yes: Your Linear API key
3. **GitHub Repository** - Your GitHub organization and repository name
   - Used for generating links in documentation and Linear tickets
4. **Default Branch** - Your main branch name (usually `main` or `master`)

### It Will Automatically:

1. ✅ Copy `.claude` folder to your project
2. ✅ Configure `.gitignore` to protect your API keys
3. ✅ Install Linear MCP server (if requested)
4. ✅ Create MCP configuration with your API key
5. ✅ Update Linear command with your GitHub URLs
6. ✅ Check prerequisites (git, GitHub CLI, Node.js)
7. ✅ Generate a detailed setup summary

## Quick Start

### Step 1: Run the Setup Wizard

```bash
# Navigate to the package directory
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows

# Run the interactive setup
interactive-setup.bat
```

### Step 2: Answer the Questions

The wizard will ask you questions one by one:

```
================================================================
Step 1: Project Directory
================================================================

Where do you want to set up the Claude Workflow?
(This should be your project root directory)

Enter full path to your project: C:\Users\sagas\Projects\MyProject
```

```
================================================================
Step 2: Linear Integration (Optional)
================================================================

Do you want to set up Linear integration?
This allows you to manage Linear tickets from Claude Code.

Set up Linear? (y/n): y

Great! I'll need your Linear API key.
You can get it from: https://linear.app/settings/api

Enter your Linear API key: lin_api_xxxxxxxxxxxxx
```

```
================================================================
Step 3: GitHub Repository (Optional)
================================================================

Do you want to configure GitHub repository URLs?
This is used for generating links in Linear tickets and documentation.

Configure GitHub repository? (y/n): y

Enter your GitHub repository information:
(Example: https://github.com/myorg/myrepo)

GitHub organization/user: myorg
GitHub repository name: myrepo
```

```
================================================================
Step 4: Default Git Branch
================================================================

What is your default/main branch name?
(Usually 'main' or 'master')

Default branch name [main]: main
```

### Step 3: Confirm and Install

The wizard will show you a summary:

```
================================================================
Setup Summary
================================================================

Project directory: C:\Users\sagas\Projects\MyProject
Linear integration: y
  API Key: lin_api_xxxxxxxxxxxxx
GitHub integration: y
  Repository: https://github.com/myorg/myrepo
Default branch: main

================================================================

Proceed with setup? (y/n): y
```

### Step 4: Restart VS Code

**IMPORTANT:** After the setup completes, you MUST restart VS Code for the MCP server changes to take effect.

### Step 5: Test Your Setup

After restarting VS Code:

1. **Test basic functionality:**
   ```
   /research_codebase_nt what is the structure?
   ```

2. **Test Linear (if configured):**
   ```
   mcp__linear__list_teams
   ```

3. **Get your Linear IDs** (if configured):
   ```
   mcp__linear__list_teams              → Copy team UUID
   mcp__linear__list_workflow_states    → Copy state UUIDs
   mcp__linear__list_labels             → Copy label UUIDs
   mcp__linear__list_users              → Copy user UUIDs
   ```

4. **Customize Linear command** (if configured):
   - Open: `.claude\commands\linear.md`
   - Replace all `YOUR_*_ID_HERE` placeholders with your actual Linear IDs
   - See: `LINEAR-CUSTOMIZATION-CHECKLIST.md` for step-by-step instructions

## What You Need to Prepare

### Required Information:

- ✅ **Project directory path** - Full path to your project root
  - Example: `C:\Users\sagas\Projects\MyProject`

### Optional (but recommended):

- 🔑 **Linear API key** - Get from https://linear.app/settings/api
  - Example: `lin_api_YOUR_LINEAR_API_KEY_HERE`

- 🔗 **GitHub repository info**:
  - Organization/user: `myorg`
  - Repository name: `myrepo`

- 🌿 **Default branch name** - Usually `main` or `master`

## Prerequisites

The setup wizard will check for these prerequisites:

### Required for all features:
- ✅ **Git** - For commit commands
  - Download: https://git-scm.com/download/win

### Required for PR features:
- ✅ **GitHub CLI (gh)** - For PR commands
  - Download: https://cli.github.com/
  - After installing, authenticate: `gh auth login`

### Required for Linear integration:
- ✅ **Node.js** - For Linear MCP server
  - Download: https://nodejs.org/

## After Setup

The wizard creates a detailed summary file in your project:
- **Location**: `your-project/SETUP-SUMMARY.txt`
- **Contains**:
  - Your configuration
  - Next steps
  - Available commands
  - Security reminders
  - Documentation links

## File Structure After Setup

```
your-project/
├── .claude/
│   ├── settings.json
│   ├── mcp_config.json              ← Your Linear API key (if configured)
│   ├── agents/                      ← 6 AI agents
│   │   ├── codebase-locator.md
│   │   ├── codebase-analyzer.md
│   │   ├── codebase-pattern-finder.md
│   │   ├── thoughts-locator.md
│   │   ├── thoughts-analyzer.md
│   │   └── web-search-researcher.md
│   └── commands/                    ← 11 workflow commands
│       ├── create_plan_nt.md
│       ├── implement_plan.md
│       ├── research_codebase_nt.md
│       ├── iterate_plan_nt.md
│       ├── validate_plan.md
│       ├── commit.md
│       ├── ci_commit.md
│       ├── describe_pr_nt.md
│       ├── ci_describe_pr.md
│       ├── debug.md
│       └── linear.md                ← Customized with your GitHub URLs
├── .gitignore                       ← Updated to protect API keys
└── SETUP-SUMMARY.txt                ← Your setup details
```

## Available Commands After Setup

| Command | What It Does | Requirements |
|---------|--------------|--------------|
| `/research_codebase_nt` | Deep codebase analysis | None |
| `/create_plan_nt` | Create implementation plans | None |
| `/implement_plan` | Execute plans step-by-step | None |
| `/iterate_plan_nt` | Refine existing plans | None |
| `/validate_plan` | Verify implementation | None |
| `/commit` | Create git commits | Git |
| `/ci_commit` | Automated commits for CI | Git |
| `/describe_pr_nt` | Generate PR descriptions | Git, GitHub CLI |
| `/ci_describe_pr` | Automated PR descriptions | Git, GitHub CLI |
| `/debug` | Debug issues systematically | None |
| `/linear` | Manage Linear tickets | Linear MCP setup + customization |

## GitHub Integration

### No MCP Server Needed!

Your setup uses **direct GitHub CLI integration** instead of an MCP server:

✅ **What's included:**
- PR description generation (`/describe_pr_nt`)
- Automated PR descriptions (`/ci_describe_pr`)
- Direct integration with `gh` CLI commands

✅ **How it works:**
- Commands use `gh pr view`, `gh pr diff`, `gh pr edit`
- No additional MCP server required
- More reliable than MCP-based solutions

✅ **What you need:**
- GitHub CLI installed: `gh --version`
- Authenticated: `gh auth login`
- Repository set as git remote

### Test GitHub Integration:

```bash
# Check GitHub CLI is installed
gh --version

# Check authentication
gh auth status

# View current repository
gh repo view

# List PRs
gh pr list

# View a PR
gh pr view 123
```

## Linear Integration Details

### Project-Specific Configuration

The Linear MCP server is configured **only for your project** - not globally!

✅ **What this means:**
- Linear tools available only in this project
- Other projects: No Linear, no context bloat
- Full control over which projects have Linear integration

✅ **Configuration location:**
- `your-project/.claude/mcp_config.json`
- Contains your Linear API key
- Protected by `.gitignore`

### After Linear Setup

1. **Test MCP connection:**
   ```
   mcp__linear__list_teams
   ```

2. **Get all your Linear IDs:**
   ```
   mcp__linear__list_teams              → Team UUID
   mcp__linear__list_workflow_states    → State UUIDs (Backlog, Todo, etc.)
   mcp__linear__list_labels             → Label UUIDs (bug, feature, etc.)
   mcp__linear__list_users              → User UUIDs
   mcp__linear__list_projects           → Project UUIDs (optional)
   ```

3. **Customize linear.md:**
   - Open: `.claude/commands/linear.md`
   - Lines 362-387: Replace all `YOUR_*_ID_HERE` placeholders
   - Use the UUIDs you copied from step 2
   - See: `LINEAR-CUSTOMIZATION-CHECKLIST.md` for detailed guide

4. **Test Linear command:**
   ```
   /linear
   ```

## Troubleshooting

### "ERROR: Directory does not exist"
**Problem:** The project path you entered doesn't exist

**Solution:**
- Check the path is correct
- Use full absolute path (e.g., `C:\Users\sagas\Projects\MyProject`)
- Make sure the directory exists before running setup

### "ERROR: Failed to install Linear MCP server"
**Problem:** npm installation failed

**Solutions:**
1. Check Node.js is installed: `node --version`
2. Check npm is installed: `npm --version`
3. Install manually: `npm install -g @modelcontextprotocol/server-linear`
4. Restart VS Code and try again

### "MCP tools not found" after setup
**Problem:** Linear MCP server not available in Claude Code

**Solutions:**
1. **Restart VS Code completely** (close all windows)
2. Check configuration exists: `cat .claude\mcp_config.json`
3. Check Linear MCP server installed: `npm list -g @modelcontextprotocol/server-linear`
4. Check API key is correct in `.claude\mcp_config.json`

### "gh: command not found"
**Problem:** GitHub CLI not installed

**Solution:**
1. Download from: https://cli.github.com/
2. Install and restart terminal
3. Authenticate: `gh auth login`

### "/linear command doesn't work"
**Problem:** Linear command not responding correctly

**Solutions:**
1. Make sure you've customized `.claude\commands\linear.md` with your Linear IDs
2. Replace all `YOUR_*_ID_HERE` placeholders
3. Test MCP connection: `mcp__linear__list_teams`
4. See: `LINEAR-CUSTOMIZATION-CHECKLIST.md`

## Security

### Protected Files

The setup wizard automatically adds these to `.gitignore`:

```gitignore
# Linear API Key - DO NOT COMMIT
LINEAR-MCP-CONFIG.json
mcp_config.json

# Project-specific MCP configuration (contains API key)
.claude/mcp_config.json

# User-specific customizations
.claude/commands/linear.md.backup
```

### Your API Key

**Stored in:**
- `.claude/mcp_config.json` (your project)

**Protected by:**
- ✅ `.gitignore` (won't commit to git)

**Security reminders:**
- ⚠️ Keep this file secure
- ⚠️ Don't share or commit to public repos
- ⚠️ Regenerate if exposed: https://linear.app/settings/api

## Manual Setup (Alternative)

If you prefer to set up manually instead of using the wizard, see:
- `SETUP-GUIDE.md` - Complete manual setup guide
- `YOUR-LINEAR-SETUP-SUMMARY.md` - Linear-specific setup
- `LINEAR-MCP-SETUP-INSTRUCTIONS.md` - Detailed Linear instructions

## Next Steps After Setup

### Today:
1. ✅ Run `interactive-setup.bat`
2. ✅ Restart VS Code
3. ✅ Test basic commands: `/research_codebase_nt`
4. ✅ Test Linear (if configured): `mcp__linear__list_teams`

### This Week:
1. Get all Linear IDs (if using Linear)
2. Customize `.claude/commands/linear.md` with your IDs
3. Test `/linear` command
4. Try other workflow commands

### This Month:
1. Use commands regularly in your workflow
2. Customize commands to your needs
3. Add custom commands if needed

## Need Help?

### Documentation:
- **This Guide** - Interactive setup instructions
- `QUICK-START.md` - 2-minute quick start
- `README.md` - Complete package overview
- `SETUP-GUIDE.md` - Manual setup guide
- `LINEAR-CUSTOMIZATION-CHECKLIST.md` - Linear customization
- `MCP-GLOBAL-VS-PROJECT.md` - Configuration details
- `FINAL-SUMMARY.md` - Package summary

### Check Your Setup:
- View setup summary: `cat SETUP-SUMMARY.txt` (in your project)
- Test commands: `/research_codebase_nt`
- Test Linear: `mcp__linear__list_teams`

## Summary

The **Interactive Setup Wizard** makes it easy to set up the Claude Workflow package:

✅ **No manual configuration** - Wizard asks questions and sets everything up
✅ **Project-specific Linear** - No context bloat in other projects
✅ **GitHub CLI integration** - No MCP server needed for GitHub
✅ **Security built-in** - API keys protected by `.gitignore`
✅ **Detailed summary** - Everything documented in `SETUP-SUMMARY.txt`

Just run `interactive-setup.bat`, answer the questions, and you're ready to go!
