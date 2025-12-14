# Getting Started - 5 Minutes

A quick guide to get you up and running with Claude Code workflow system on Windows.

---

## Installation (1 minute)

### Option 1: Interactive Setup (Recommended)

Let AI guide you through the setup process!

```bash
# Run the interactive setup wizard
cd claude-workflow-windows
interactive-setup.bat
```

The wizard will ask you:
- 📁 Where to install (your project directory)
- 🔑 Linear API key (if you want Linear integration)
- 🔗 GitHub repository URL
- 🌿 Default branch name

Then it automatically sets everything up for you!

### Option 2: Manual Setup

If you prefer to set up manually:

```bash
# Copy the .claude folder to your project root
cp -r claude-workflow-windows/.claude /path/to/your-project/
```

---

## First Steps (2 minutes)

### Test Basic Functionality

Open your project in Claude Code and try:

```
/research_codebase_nt what is the overall structure?
```

If that works → ✅ You're ready to go!

### Most Useful Commands

```
/research_codebase_nt <question>     # Explore unfamiliar code
/create_plan_nt                      # Plan a new feature
/implement_plan                      # Execute a plan
/commit                              # Create a commit
/debug                               # Debug an issue
/linear                              # Manage Linear tickets (after setup)
```

---

## Linear Setup (Optional, 10 minutes)

Only if you use Linear for project management.

### Quick Overview

1. **Install Linear MCP server:**
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

2. **Get your Linear IDs:**
   ```
   mcp__linear__list_teams
   mcp__linear__list_workflow_states
   mcp__linear__list_labels
   mcp__linear__list_users
   ```

3. **Update configuration:**
   - Edit `.claude/commands/linear.md`
   - Replace all placeholder IDs with your actual Linear IDs

4. **Test:**
   ```
   /linear
   ```

**Need detailed Linear setup?** → See [LINEAR-SETUP.md](LINEAR-SETUP.md)

**Don't use Linear?** You can safely remove it:
```bash
rm .claude/commands/linear.md
```

---

## Common Workflows

### Research → Plan → Implement → Commit

This is the recommended workflow for building new features:

#### 1. Research the Codebase

```
You: /research_codebase_nt how does authentication work?

Claude: I'll research how authentication works in your codebase...
[Spawns codebase-locator and codebase-analyzer agents in parallel]
[Returns comprehensive analysis with file references]
```

#### 2. Create a Plan

```
You: /create_plan_nt

Claude: I'll help you create an implementation plan. What are we building?

You: Add OAuth2 support to the login flow

Claude: [Asks clarifying questions, researches codebase, creates structured plan]
```

#### 3. Implement the Plan

```
You: /implement_plan path/to/your-plan.md

Claude: [Executes plan phase by phase, verifies each step]
```

#### 4. Commit Your Changes

```
You: /commit

Claude: [Reviews changes, drafts commit message in repo style]
Here's my proposed commit message:

Add OAuth2 authentication support

- Implement OAuth2 PKCE flow for secure authentication
- Add token refresh mechanism
- Update login UI with OAuth2 button

🤖 Generated with Claude Code
Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>

Should I proceed with this commit?
```

---

## Quick Examples

### Example: Debug an Issue

```
You: /debug

Claude: I'll help you debug the issue. What's the problem?

You: Users are getting 401 errors on login

Claude: [Investigates logs, database state, git history, identifies root cause]
```

### Example: Manage Linear Tickets

```
You: /linear

Claude: What would you like to do?

You: Create a ticket for adding OAuth2 support

Claude: [Creates structured ticket in Linear with proper labels and status]
```

---

## Next Steps

### Explore the Commands

- **[COMMANDS.md](COMMANDS.md)** - Complete command reference with detailed examples
- All 11 commands are documented with usage patterns

### Customize Your Setup

- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - How to create custom commands and agents
- Commands are just markdown files - easy to modify!

### Set Up Linear Integration

- **[LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)** - Step-by-step Linear setup
- **[LINEAR-QUICK-SETUP.txt](LINEAR-QUICK-SETUP.txt)** - Quick reference card

---

## What You Have

After installation, you have:
- **6 AI agents** for codebase analysis
- **11 workflow commands** (all Windows-compatible)
- **Linear integration support** (optional)
- **Clean configuration** with no bash script dependencies

---

## Troubleshooting

### Commands Don't Appear

**Check:** `.claude/commands/` exists and contains `.md` files
```bash
ls .claude/commands/
```

### Agents Not Working

**Check:** `.claude/agents/` exists and contains `.md` files
```bash
ls .claude/agents/
```

### Linear Commands Fail

**Options:**
1. Set up Linear MCP server and customize IDs
2. Remove Linear integration: `rm .claude/commands/linear.md`

### Git Commands Fail

**Install:** Git for Windows (includes Git Bash)
- Download from: https://git-scm.com/download/win

### GitHub CLI Not Found

**Install:** GitHub CLI
```bash
winget install --id GitHub.cli
```

---

## Ready to Start!

You now have everything you need. Try your first command:

```
/research_codebase_nt what is the overall structure?
```

**Happy coding with Claude on Windows!** 🚀
