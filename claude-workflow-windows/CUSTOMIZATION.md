# Customization Guide - Windows Edition

This guide walks you through customizing the Claude Code workflow package for Windows.

## Table of Contents

1. [Quick Customization Checklist](#quick-customization-checklist)
2. [Linear Integration Setup](#linear-integration-setup)
3. [GitHub Integration Setup](#github-integration-setup)
4. [Creating Custom Commands](#creating-custom-commands)
5. [Creating Custom Agents](#creating-custom-agents)
6. [Testing Your Setup](#testing-your-setup)

---

## Quick Customization Checklist

### Basic Setup
- [ ] Copied `.claude/` folder to your project (or ran interactive setup)
- [ ] Tested basic command: `/research_codebase_nt`

### Linear Integration (Optional)
- [ ] Installed Linear MCP server: `npm install -g @modelcontextprotocol/server-linear`
- [ ] Created `.claude/mcp_config.json` with your API key
- [ ] Restarted VS Code
- [ ] Tested MCP connection: `mcp__linear__list_teams`
- [ ] Updated Linear team/project IDs in `linear.md`
- [ ] Updated Linear workflow state IDs in `linear.md`
- [ ] Updated Linear label IDs in `linear.md`
- [ ] Updated Linear user IDs in `linear.md`
- [ ] Updated GitHub URL mappings in `linear.md`
- [ ] Tested Linear command: `/linear`

### GitHub Integration (Optional)
- [ ] Installed GitHub CLI: https://cli.github.com/
- [ ] Authenticated: `gh auth login`
- [ ] Tested: `gh repo view`
- [ ] Tested PR command: `/describe_pr_nt`

---

## Linear Integration Setup

### Step 1: Install Linear MCP Server

```bash
npm install -g @modelcontextprotocol/server-linear
```

### Step 2: Configure MCP Server

**Option A: Use Interactive Setup (Recommended)**
```bash
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows
interactive-setup.bat
```

The wizard will:
- Ask for your Linear API key
- Create `.claude/mcp_config.json` automatically
- Configure everything for you

**Option B: Manual Setup**
```bash
# From your project directory
C:\PolarCode\MultiAgentSetup\claude-workflow-windows\setup-linear.bat
```

Then enter your Linear API key when prompted.

**Option C: Create Config Manually**

Create `.claude/mcp_config.json` in your project:
```json
{
  "mcpServers": {
    "linear": {
      "command": "node",
      "args": [
        "C:\\Users\\YOUR_USERNAME\\AppData\\Roaming\\npm\\node_modules\\@modelcontextprotocol\\server-linear\\dist\\index.js"
      ],
      "env": {
        "LINEAR_API_KEY": "lin_api_YOUR_API_KEY_HERE"
      }
    }
  }
}
```

Replace:
- `YOUR_USERNAME` with your Windows username
- `YOUR_API_KEY_HERE` with your Linear API key from https://linear.app/settings/api

### Step 3: Restart VS Code

**IMPORTANT:** You MUST restart VS Code for MCP server changes to take effect.

### Step 4: Get Your Linear IDs

In Claude Code, use MCP tools to query your workspace:

```
mcp__linear__list_teams
mcp__linear__list_projects
mcp__linear__list_workflow_states
mcp__linear__list_labels
mcp__linear__list_users
```

Copy the UUIDs from the responses.

### Step 5: Update `.claude/commands/linear.md`

See [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md) for detailed step-by-step instructions.

**Quick summary of what to replace:**

1. **Lines 64-68:** Update team and project IDs
2. **Lines 58-62:** Update GitHub URL mappings
3. **Lines 362-387:** Replace all `YOUR_*_ID_HERE` placeholders with your Linear workspace IDs

**Find and replace:**
- `YOUR_TEAM_UUID` → Your actual team UUID
- `YOUR_PROJECT_UUID` → Your actual project UUID
- `YOUR_BACKLOG_STATE_UUID` → Your "Backlog" state UUID
- `YOUR_TODO_STATE_UUID` → Your "Todo" state UUID
- `YOUR_IN_PROGRESS_STATE_UUID` → Your "In Progress" state UUID
- `YOUR_DONE_STATE_UUID` → Your "Done" state UUID
- And so on for all labels and users...

### Step 6: Test Linear Integration

```
/linear
```

Claude should guide you through Linear operations using your workspace IDs.

---

## GitHub Integration Setup

### Step 1: Install GitHub CLI

Download from: https://cli.github.com/

### Step 2: Authenticate

```bash
gh auth login
```

Follow the prompts to authenticate with GitHub.

### Step 3: Test GitHub CLI

```bash
# View current repository
gh repo view

# List pull requests
gh pr list

# View a specific PR
gh pr view 123
```

### Step 4: Update GitHub URLs in Linear Command (Optional)

If you want Linear tickets to link to your GitHub repository:

**Edit `.claude/commands/linear.md` lines 58-62:**

Find:
```markdown
- `thoughts/shared/...` → `https://github.com/YOUR_ORG/YOUR_REPO/blob/main/...`
```

Replace with:
```markdown
- `docs/...` → `https://github.com/your-org/your-repo/blob/main/docs/...`
- `src/...` → `https://github.com/your-org/your-repo/blob/main/src/...`
```

Replace `your-org` and `your-repo` with your actual GitHub organization and repository name.

### Step 5: Test PR Commands

```
/describe_pr_nt
```

Claude should be able to fetch PR information and generate descriptions.

---

## Creating Custom Commands

### Step 1: Create Command File

Create a new file in `.claude/commands/`:

```bash
# Create new command file
echo. > .claude\commands\my_custom_command.md
```

### Step 2: Add Command Definition

Edit `.claude/commands/my_custom_command.md`:

```markdown
---
description: Brief description of what this command does
model: sonnet
---

# Custom Command Name

You are tasked with [doing something specific].

## Steps to follow:

1. **First step:**
   - Do this first
   - Then do this

2. **Second step:**
   - Do this next
   - Then do that

3. **Final step:**
   - Complete the task
   - Confirm with user

## Important notes:
- Note about the command
- Another important detail
```

### Step 3: Test Your Command

```
/my_custom_command
```

### Example Custom Commands

**Example 1: Code Review Command**

`.claude/commands/code_review.md`:
```markdown
---
description: Review code changes for best practices and potential issues
model: sonnet
---

# Code Review

Review all uncommitted changes in the codebase for:

1. **Code Quality:**
   - Check for code smells
   - Verify best practices
   - Look for potential bugs

2. **Security:**
   - Check for security vulnerabilities
   - Verify input validation
   - Check for exposed secrets

3. **Performance:**
   - Identify performance issues
   - Suggest optimizations

Provide a detailed review report.
```

**Example 2: Documentation Generator**

`.claude/commands/generate_docs.md`:
```markdown
---
description: Generate documentation for code files
model: sonnet
---

# Generate Documentation

Generate comprehensive documentation for the specified files or modules.

1. Analyze the code structure
2. Document all public APIs
3. Add usage examples
4. Create README if needed

Format documentation using markdown.
```

---

## Creating Custom Agents

### Step 1: Create Agent File

Create a new file in `.claude/agents/`:

```bash
echo. > .claude\agents\my-custom-agent.md
```

### Step 2: Add Agent Definition

Edit `.claude/agents/my-custom-agent.md`:

```markdown
---
description: Brief description of agent's purpose
model: sonnet
---

# Role

You are a specialized agent that [does something specific].

# Capabilities

You have access to these tools:
- Glob - Find files by pattern
- Grep - Search file contents
- Read - Read file contents
- Bash - Execute commands (if needed)

# Instructions

When invoked, you should:

1. **First:** Do this first
2. **Second:** Then do this
3. **Third:** Finally do this

Return your findings in this format:

## Summary
[Brief summary]

## Details
[Detailed findings]

## Files Analyzed
- file1.ts
- file2.ts

# Key Principles

- Be thorough but concise
- Focus on facts, not opinions
- Document what exists
```

### Step 3: Use Agent in Commands

Reference your agent in command files using the Task tool:

```markdown
Use the Task tool to spawn the my-custom-agent agent to analyze the codebase.
```

### Example Custom Agents

**Example 1: Test Finder Agent**

`.claude/agents/test-finder.md`:
```markdown
---
description: Locates test files and analyzes test coverage
model: sonnet
---

# Role

You are a test analysis agent that finds and analyzes test files.

# Capabilities

- Glob tool to find test files
- Read tool to analyze test content
- Grep tool to search for test patterns

# Instructions

1. Search for test files (*.test.ts, *.spec.ts, etc.)
2. Analyze test coverage
3. Identify untested code paths
4. Report findings

Return findings in this format:

## Test Files Found
- List of test files

## Coverage Analysis
- Covered areas
- Uncovered areas

## Recommendations
- Suggested tests to add
```

**Example 2: Dependency Analyzer**

`.claude/agents/dependency-analyzer.md`:
```markdown
---
description: Analyzes project dependencies and their usage
model: sonnet
---

# Role

You analyze project dependencies and how they're used.

# Capabilities

- Read package.json
- Search for import statements
- Analyze dependency usage

# Instructions

1. Read package.json
2. Search for imports in codebase
3. Identify unused dependencies
4. Identify missing dependencies
5. Report security vulnerabilities

Return findings in structured format.
```

---

## Testing Your Setup

### Test 1: Verify File Structure

```bash
# Check main structure
dir .claude

# Check agents
dir .claude\agents

# Check commands
dir .claude\commands
```

### Test 2: Test Basic Commands

```
# Test research
/research_codebase_nt what is the overall structure?

# Test planning
/create_plan_nt

# Test debugging
/debug investigate the recent errors
```

### Test 3: Test Linear (If Configured)

```
# Test MCP connection
mcp__linear__list_teams

# Test Linear command
/linear
```

### Test 4: Test Git/GitHub (If Available)

```bash
# Test git status
git status

# Test GitHub CLI
gh repo view

# Test PR command (if on a branch with PR)
/describe_pr_nt
```

### Test 5: Verify No HumanLayer References

```bash
# Search for HumanLayer-specific patterns
findstr /s /i "humanlayer" .claude\*
findstr /s /i "thoughts/" .claude\*

# Should return minimal or no results
```

---

## Advanced Customization

### Change Default Model for Commands

Edit individual command files to change the model used:

```markdown
---
description: Create implementation plan
model: opus  # Change to: sonnet, haiku, or opus
---
```

**Model guidelines:**
- `haiku` - Fast, cheap, good for simple tasks
- `sonnet` - Balanced, good for most tasks (default) ⭐
- `opus` - Powerful, expensive, use for complex tasks

### Customize Agent Behavior

Edit agent files in `.claude/agents/` to:
- Change analysis depth
- Add specific patterns to look for
- Customize output format
- Add domain-specific knowledge

### Create Command Aliases

You can create short aliases for frequently used commands:

`.claude/commands/p.md` → Alias for `/create_plan_nt`
`.claude/commands/r.md` → Alias for `/research_codebase_nt`
`.claude/commands/i.md` → Alias for `/implement_plan`

Just copy the original command content to the new file.

---

## Troubleshooting Customization

### Problem: Commands not appearing

**Solution:** Check file names and location
```bash
dir .claude\commands\*.md
# Files must end in .md and be in commands/ directory
```

### Problem: Linear commands failing with "tool not found"

**Solution:**
1. Verify Linear MCP server is installed: `npm list -g @modelcontextprotocol/server-linear`
2. Check `.claude/mcp_config.json` exists and has correct API key
3. Restart VS Code
4. Test MCP tools manually: `mcp__linear__list_teams`

### Problem: Agents not being invoked

**Solution:** Check agent file names match references in commands
```bash
dir .claude\agents\
# Compare names to agent references in command files
```

### Problem: GitHub CLI not working

**Solution:**
1. Install GitHub CLI: https://cli.github.com/
2. Authenticate: `gh auth login`
3. Set default repo: `gh repo set-default`
4. Test: `gh repo view`

---

## Security Best Practices

### Protect Your API Keys

**Never commit these files:**
- `.claude/mcp_config.json` (contains Linear API key)

**The `.gitignore` file protects:**
```gitignore
# Linear API Key - DO NOT COMMIT
LINEAR-MCP-CONFIG.json
mcp_config.json

# Project-specific MCP configuration (contains API key)
.claude/mcp_config.json

# User-specific customizations
.claude/commands/linear.md.backup
```

### Verify .gitignore

```bash
# Check what would be committed
git status

# .claude/mcp_config.json should NOT appear
```

If it appears, make sure `.gitignore` is properly configured.

---

## Final Checklist

Before considering customization complete:

- [ ] Tested at least one command successfully
- [ ] Linear integration working (if configured)
- [ ] GitHub integration working (if configured)
- [ ] All Linear IDs replaced (if using Linear)
- [ ] All GitHub URLs updated (if using Linear)
- [ ] `.gitignore` protecting API keys
- [ ] Custom commands working (if created)
- [ ] Custom agents working (if created)
- [ ] Documented customizations in project README

---

## Getting Help

### Documentation Files
- **README.md** - Package overview
- **COMMANDS.md** - Command reference
- **LINEAR-CUSTOMIZATION-CHECKLIST.md** - Linear setup steps

### Interactive Setup
For guided setup, run:
```bash
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows
interactive-setup.bat
```

---

**Document Version:** 1.1
**Last Updated:** 2025-12-14
**Platform:** Windows-optimized
