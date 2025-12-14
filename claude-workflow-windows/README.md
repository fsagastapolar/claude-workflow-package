# Claude Workflow Package - Windows Edition

A Windows-compatible version of the Claude Code workflow system, cleaned up and customized for use without macOS-specific features or HumanLayer CLI dependencies.

## What's Included

This streamlined Windows version contains:
- **6 Specialized AI Agents** for codebase analysis
- **11 Workflow Commands** (all Windows-compatible)
- **Clean configuration** with no bash script dependencies
- **Linear integration support** (requires customization)

## What Was Removed

Compared to the original package, this version removes:
- ❌ macOS-only session orchestration commands (`ralph_*`, `oneshot*`, `create_worktree`)
- ❌ Bash scripts (they depend on HumanLayer CLI)
- ❌ HumanLayer-specific commands (`founder_mode`, `local_review`)
- ❌ Thoughts directory dependencies (using `_nt` variants)
- ❌ HumanLayer-specific Linear IDs (replaced with placeholders)

## Quick Start

### 🚀 Option 1: Interactive Setup Wizard (Recommended)

**Let AI guide you through the setup process!**

```bash
# Run the interactive setup wizard
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows
interactive-setup.bat
```

The wizard will ask you:
- 📁 Where to install (your project directory)
- 🔑 Linear API key (if you want Linear integration)
- 🔗 GitHub repository URL
- 🌿 Default branch name

Then it automatically sets everything up for you!

**See:** [INTERACTIVE-SETUP-GUIDE.md](INTERACTIVE-SETUP-GUIDE.md) for detailed instructions.

---

### ⚙️ Option 2: Manual Setup

If you prefer to set up manually:

#### 1. Copy to Your Project

```bash
# Copy the .claude folder to your project root
cp -r claude-workflow-windows/.claude /path/to/your-project/
```

#### 2. Test Basic Functionality

Open your project in Claude Code and try:
```
/research_codebase_nt what is the overall structure?
```

If that works, you're ready to go!

#### 3. (Optional) Set Up Linear Integration

If you use Linear for project management, follow the [Linear Setup Guide](#linear-integration-setup) below.

---

## Available Agents

All 6 agents work perfectly on Windows:

### 1. **codebase-locator**
Find WHERE code lives (files, functions, patterns)
- Example: "Find all authentication-related files"

### 2. **codebase-analyzer**
Understand HOW code works (detailed analysis)
- Example: "How does the login flow work?"

### 3. **codebase-pattern-finder**
Find similar implementations across the codebase
- Example: "Show me similar API endpoints"

### 4. **thoughts-locator**
Discover relevant documentation (if you add a docs structure)
- Example: "Find docs about authentication"

### 5. **thoughts-analyzer**
Deep dive on documentation
- Example: "Summarize the API design docs"

### 6. **web-search-researcher**
Research external information from the web
- Example: "How does OAuth2 PKCE flow work?"

---

## Available Commands

### Core Workflow Commands

#### `/create_plan_nt`
Create detailed implementation plans without thoughts directory
- Interactive planning session
- Spawns research agents in parallel
- No thoughts directory required
- Plans can be saved anywhere you specify

#### `/implement_plan`
Execute implementation plans phase by phase
- Step-by-step execution
- Verification at each phase
- Tracks progress with todos

#### `/validate_plan`
Verify implementation matches the plan
- Compares actual implementation to plan
- Identifies gaps or deviations

### Research Commands

#### `/research_codebase_nt`
Deep codebase analysis without thoughts directory
- Comprehensive codebase research
- Uses multiple agents in parallel
- Returns structured findings

#### `/iterate_plan_nt`
Iterate on existing plans without thoughts directory
- Refine and update plans
- Add new phases
- Adjust approach

### Git Workflow Commands

#### `/commit`
Interactive git commits with user approval
- Reviews changes
- Drafts commit messages
- Follows repo style
- **Requires:** Git (available in Git for Windows)

#### `/ci_commit`
Automated commits for CI environments
- Non-interactive version
- **Requires:** Git

#### `/describe_pr_nt`
Generate PR descriptions without thoughts directory
- Analyzes changes
- Creates comprehensive PR description
- **Requires:** Git, GitHub CLI (`gh`)

#### `/ci_describe_pr`
Automated PR descriptions for CI
- Non-interactive version
- **Requires:** Git, GitHub CLI

### Debugging

#### `/debug`
Debug issues using logs, database state, and git history
- Comprehensive debugging workflow
- Analyzes error patterns
- Investigates root causes

### Linear Integration

#### `/linear`
Manage Linear tickets
- Create tickets
- Update status
- Add comments
- Search tickets
- **Requires:** Linear MCP server + customization (see below)

---

## Linear Integration Setup

### Prerequisites

1. **Install Linear MCP Server**
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

2. **Configure in Claude Code**
   - Add Linear MCP server to your Claude Code configuration
   - Provide your Linear API key

### Customization Steps

#### Step 1: Get Your Linear IDs

In Claude Code, use these MCP tools:
```
mcp__linear__list_teams
mcp__linear__list_projects
mcp__linear__list_workflow_states
mcp__linear__list_labels
mcp__linear__list_users
```

Copy the UUIDs from the responses.

#### Step 2: Update linear.md

Edit `.claude/commands/linear.md` and replace ALL placeholder IDs:

1. **Team ID** (line ~362)
   - Replace `YOUR_TEAM_ID_HERE` with your team's UUID

2. **Label IDs** (lines ~365-368)
   - Replace with your label UUIDs
   - Customize labels based on your project structure

3. **Workflow State IDs** (lines ~370-380)
   - Replace with your workflow state UUIDs
   - Update to match YOUR actual workflow

4. **User IDs** (lines ~383-385)
   - Replace with your team members' UUIDs

5. **GitHub URLs** (line ~59)
   - Update to point to your org/repo

6. **Workflow Description** (lines ~36-48)
   - Update to match your team's actual workflow

#### Step 3: Test Linear Integration

```
/linear
```

Should prompt you about what you want to do with Linear tickets.

---

## Directory Structure

```
.claude/
├── settings.json           # Configuration (no bash scripts needed)
├── agents/                 # 6 specialized agents
│   ├── codebase-locator.md
│   ├── codebase-analyzer.md
│   ├── codebase-pattern-finder.md
│   ├── thoughts-locator.md
│   ├── thoughts-analyzer.md
│   └── web-search-researcher.md
└── commands/               # 11 workflow commands
    ├── create_plan_nt.md
    ├── implement_plan.md
    ├── research_codebase_nt.md
    ├── commit.md
    ├── describe_pr_nt.md
    ├── debug.md
    ├── validate_plan.md
    ├── linear.md
    ├── iterate_plan_nt.md
    ├── ci_commit.md
    └── ci_describe_pr.md
```

---

## Usage Examples

### Example 1: Researching a Feature

```
User: /research_codebase_nt how does authentication work?

Claude: I'll research how authentication works in your codebase...
[Spawns codebase-locator and codebase-analyzer agents in parallel]
[Returns comprehensive analysis with file references]
```

### Example 2: Creating a Plan

```
User: /create_plan_nt

Claude: I'll help you create an implementation plan. What are we building?

User: Add OAuth2 support to the login flow

Claude: [Asks clarifying questions, researches codebase, creates structured plan]
```

### Example 3: Making a Commit

```
User: /commit

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

## Customization

### Modify Command Behavior

Commands are just markdown files! Edit them to customize:

1. Open `.claude/commands/[command-name].md`
2. Edit the instructions
3. Save
4. Command behavior updates immediately

### Add Your Own Commands

1. Create new file: `.claude/commands/my_command.md`
2. Add frontmatter:
   ```markdown
   ---
   description: What this command does
   model: sonnet
   ---

   # Instructions for Claude
   [Your instructions here]
   ```
3. Use it: `/my_command`

### Add Your Own Agents

Same process - create `.claude/agents/my-agent.md` with agent definition.

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

## What About the "Thoughts Directory"?

The original package used a "thoughts directory" for storing plans, tickets, and documentation. This required the HumanLayer CLI which isn't available on Windows.

**This version uses `_nt` (no thoughts) command variants** which:
- Don't require the thoughts directory
- Can save plans anywhere you specify
- Work exactly the same, just without the predefined structure

**If you want structured documentation:**
- Create your own `docs/` folder structure
- Modify commands to save there
- Or just save plans in your project's docs

---

## Differences from Original

| Feature | Original | Windows Edition |
|---------|----------|-----------------|
| Agents | 6 | 6 ✅ |
| Commands | 35 | 11 |
| Bash Scripts | 3 | 0 (not needed) |
| Thoughts Dir | Required for some | None required |
| HumanLayer CLI | Required for some | Not required |
| Session Orchestration | Yes (macOS) | No |
| Linear Integration | Yes (with HumanLayer IDs) | Yes (needs customization) |
| Windows Compatible | Partial | Full ✅ |

---

## Best Practices

### Start Simple
1. Use basic commands first (`/research_codebase_nt`, `/commit`)
2. Add Linear integration when needed
3. Customize commands gradually

### Version Control
```bash
git add .claude/
git commit -m "Add Claude Code workflow system"
```

Track your customizations!

### Document Customizations

Create `.claude/README.md` in your project:
```markdown
# Our Claude Code Setup

## Modified Files
- linear.md - Updated with our Linear workspace IDs

## Our Workflow
1. /research_codebase_nt for exploration
2. /create_plan_nt for planning
3. /implement_plan for execution
4. /commit for commits
```

---

## Documentation

### Complete Guides
- **[COMMANDS.md](COMMANDS.md)** - Complete command reference with examples
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - How to customize commands, agents, and settings
- **[INTERACTIVE-SETUP-GUIDE.md](INTERACTIVE-SETUP-GUIDE.md)** - Interactive setup wizard guide
- **[LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)** - Linear setup checklist
- **[SETUP-OPTIONS-SUMMARY.md](SETUP-OPTIONS-SUMMARY.md)** - Setup options comparison
- **[CLEANUP-GUIDE.md](CLEANUP-GUIDE.md)** - What to delete from original package

### Quick References
- **[QUICK-START.md](QUICK-START.md)** - 2-minute quick start
- **[LINEAR-QUICK-SETUP.txt](LINEAR-QUICK-SETUP.txt)** - Linear setup quick reference

---

## Support

### Issues with Commands
- Read the command file (they're self-documenting)
- Commands are just markdown with instructions
- See [COMMANDS.md](COMMANDS.md) for detailed reference

### Need to Customize?
- See [CUSTOMIZATION.md](CUSTOMIZATION.md) for creating custom commands and agents
- All commands and agents are fully customizable

### Questions About Original Package
- See: https://github.com/humanlayer/humanlayer

---

## Credits

**Original Package:** Extracted from [HumanLayer](https://github.com/humanlayer/humanlayer) project

**Windows Edition:** Cleaned-up, Windows-compatible version with HumanLayer CLI dependencies removed

**License:** Same as original HumanLayer project

---

## Version

**Windows Edition Version:** 1.0
**Based On:** HumanLayer Claude Workflow Package (December 2024)
**Last Updated:** 2025-12-14

---

**Happy coding with Claude on Windows!** 🚀
