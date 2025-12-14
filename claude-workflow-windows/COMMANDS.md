# Command Reference - Windows Edition

Complete reference for all 11 Windows-compatible workflow commands.

## Command Categories

- [Planning & Research](#planning--research) (4 commands)
- [Implementation](#implementation) (2 commands)
- [Git Workflows](#git-workflows) (4 commands)
- [Linear Integration](#linear-integration) (1 command)

---

## Planning & Research

### `/create_plan_nt`

**Description:** Interactive plan creation with parallel agent research (No Thoughts directory)

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:**
- Multiple agents (codebase-locator, codebase-analyzer, codebase-pattern-finder)

**What it does:**
1. Reads ticket/context from user
2. Spawns multiple agents in parallel to research codebase
3. Interactive planning session with user
4. Presents comprehensive implementation plan
5. Documents architectural decisions

**Usage:**
```
/create_plan_nt
```

**Best for:**
- Planning new features
- Understanding complex changes
- Architectural decisions

---

### `/iterate_plan_nt`

**Description:** Improve and update existing implementation plans

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:** None

**What it does:**
1. Reviews current plan (from conversation or file)
2. Researches codebase for updates
3. Interactive iteration with user
4. Refines plan based on new information
5. Updates architectural approach if needed

**Usage:**
```
/iterate_plan_nt
```

**Best for:**
- Refining plans after feedback
- Adapting to discovered complexity
- Course corrections

---

### `/research_codebase_nt`

**Description:** Deep codebase analysis and documentation

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:** None

**What it does:**
1. Parallel agent research of codebase
2. Documents findings as-is (no recommendations)
3. Provides comprehensive analysis
4. Maps code structure and patterns

**Usage:**
```
/research_codebase_nt what is the authentication system?
/research_codebase_nt how does the API layer work?
```

**Key Principle:** Agents are documentarians, not critics - they describe what exists without suggesting improvements.

**Best for:**
- Understanding unfamiliar codebases
- Onboarding to new projects
- Investigating specific subsystems

---

### `/debug`

**Description:** Debug issues using logs, database state, and git history

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:** None

**What it does:**
1. Investigates logs and error messages
2. Examines database state (if applicable)
3. Reviews git history for context
4. Identifies potential root causes
5. Suggests debugging steps

**Usage:**
```
/debug investigate the login failure
/debug why is the API returning 500 errors?
```

**Best for:**
- Investigating bugs
- Understanding error patterns
- Root cause analysis

---

## Implementation

### `/implement_plan`

**Description:** Execute implementation plan phase by phase with verification

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:**
- Existing plan (from `/create_plan_nt` or conversation)

**What it does:**
1. Reads implementation plan
2. Executes plan phase by phase
3. Checkpoints after each phase
4. Runs tests to verify correctness
5. Reports progress and issues

**Usage:**
```
/implement_plan
```

**Best Practice:** Often combined with other commands:
```
/implement_plan and when done, create commit and PR description
```

**Best for:**
- Executing planned features
- Systematic implementation
- Multi-phase changes

---

### `/validate_plan`

**Description:** Validate implementation against plan and verify success criteria

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:**
- Existing plan (from conversation or file)
- Implemented code

**What it does:**
1. Reads the implementation plan
2. Analyzes current codebase state
3. Checks if success criteria are met
4. Identifies gaps or issues
5. Reports validation results

**Usage:**
```
/validate_plan
```

**Best for:**
- Verifying implementations
- Quality assurance
- Pre-PR reviews

---

## Git Workflows

### `/commit`

**Description:** Interactive git commits with user approval (no Claude attribution)

**Platform:** ✅ Windows (Git required), macOS, Linux

**Dependencies:**
- `git` command

**What it does:**
1. Runs `git status` and `git diff`
2. Reviews recent commits for style
3. Drafts commit message
4. Adds relevant files to staging
5. Creates commit
6. Handles pre-commit hooks

**Usage:**
```
/commit
```

**Note:** Does NOT include Claude attribution (unlike `/ci_commit`)

**Best for:**
- Regular development commits
- Following project commit style
- Interactive workflows

---

### `/ci_commit`

**Description:** Automated git commits for CI with Claude attribution

**Platform:** ✅ Windows (Git required), macOS, Linux

**Dependencies:**
- `git` command

**What it does:**
Same as `/commit` but:
- Less interactive
- Includes Claude Code attribution
- Designed for automated workflows

**Usage:**
```
/ci_commit
```

**Commit format:**
```
Your commit message here

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Best for:**
- CI/CD pipelines
- Automated workflows
- Bot-driven commits

---

### `/describe_pr_nt`

**Description:** Generate comprehensive PR descriptions following repository templates

**Platform:** ✅ Windows (Git + GitHub CLI required), macOS, Linux

**Dependencies:**
- `git` command
- `gh` CLI (GitHub CLI)

**What it does:**
1. Identifies the PR (current branch or asks user)
2. Analyzes all commits in the PR
3. Reviews full code diff
4. Uses inline PR template
5. Generates comprehensive description
6. Updates PR directly using `gh pr edit`

**Usage:**
```
/describe_pr_nt
```

**PR format:**
```markdown
## What problem(s) was I solving?

## What user-facing changes did I ship?

## How I implemented it

## How to verify it

### Manual Testing

## Description for the changelog

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**Best for:**
- Creating detailed PR descriptions
- Documenting changes
- Team code reviews

---

### `/ci_describe_pr`

**Description:** Automated PR description generation for CI workflows

**Platform:** ✅ Windows (Git + GitHub CLI required), macOS, Linux

**Dependencies:**
- `git` command
- `gh` CLI (GitHub CLI)

**What it does:**
Same as `/describe_pr_nt` but optimized for automation.

**Usage:**
```
/ci_describe_pr
```

**Best for:**
- CI/CD pipelines
- Automated PR workflows
- Bot-driven documentation

---

## Linear Integration

### `/linear`

**Description:** Full Linear ticket management workflow

**Platform:** ✅ Windows, macOS, Linux

**Dependencies:**
- Linear MCP server (installed via npm)
- Linear API key configured in `.claude/mcp_config.json`

**Capabilities:**
- Create tickets
- Update ticket status through workflow
- Add comments and links to tickets
- Search and query tickets
- Manage team-specific workflow states
- Handle labels and priorities
- Assign tickets to users

**Usage:**
```
/linear
```

Then Claude will guide you through available operations.

**Common operations:**
- Create ticket
- Update ticket status
- Move ticket through workflow
- Add comment to ticket
- Link PR to ticket

**Customization Required:**
Must update these in `.claude/commands/linear.md`:
- Team ID
- Project ID
- Workflow state IDs
- Label IDs
- User IDs
- GitHub URL mappings

See [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md) for step-by-step instructions.

**Best for:**
- Project management
- Ticket tracking
- Workflow automation

---

## Command Quick Reference

### By Purpose

#### Code Understanding
- `/research_codebase_nt` - Understand codebase structure
- `/debug` - Investigate bugs and errors

#### Planning
- `/create_plan_nt` - Plan new features
- `/iterate_plan_nt` - Refine plans

#### Building
- `/implement_plan` - Execute implementation
- `/validate_plan` - Verify implementation

#### Version Control
- `/commit` - Create git commits
- `/ci_commit` - Automated commits

#### Pull Requests
- `/describe_pr_nt` - Generate PR descriptions
- `/ci_describe_pr` - Automated PR descriptions

#### Project Management
- `/linear` - Manage Linear tickets

---

## Prerequisites

### Required for All Commands
- ✅ Claude Code (VSCode extension or CLI)
- ✅ Project with `.claude/` folder

### Required for Git Commands
- ✅ Git installed: `git --version`

### Required for PR Commands
- ✅ Git installed
- ✅ GitHub CLI installed: `gh --version`
- ✅ GitHub CLI authenticated: `gh auth login`

### Required for Linear Integration
- ✅ Node.js installed: `node --version`
- ✅ npm installed: `npm --version`
- ✅ Linear MCP server: `npm install -g @modelcontextprotocol/server-linear`
- ✅ Linear API key: https://linear.app/settings/api
- ✅ Configured `.claude/mcp_config.json`

---

## Best Practices

### Command Combinations

**Common workflows:**

```bash
# Research → Plan → Implement → Commit → PR
/research_codebase_nt about authentication
/create_plan_nt
/implement_plan
/commit
/describe_pr_nt

# Quick implementation with validation
/implement_plan
/validate_plan
/commit

# Implement and complete in one command
/implement_plan and when done, create commit and PR description
```

### Model Selection

Commands use different models based on complexity:

- **haiku** - Fast, cheap (can override for simple tasks)
- **sonnet** - Balanced, default for most commands ⭐
- **opus** - Powerful, best for complex workflows

You can override in command frontmatter if needed.

---

## Troubleshooting Commands

### Command Not Found

**Cause:** Command file not in `.claude/commands/` or wrong file name

**Solution:**
```bash
# Check available commands
dir .claude\commands\*.md
```

### Linear Commands Fail

**Cause:** Linear MCP server not configured

**Solution:**
1. Install Linear MCP server: `npm install -g @modelcontextprotocol/server-linear`
2. Configure API key in `.claude/mcp_config.json`
3. Restart VS Code
4. Test: `mcp__linear__list_teams`
5. Update Linear IDs in `linear.md`

See [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md) for details.

### PR Commands Fail

**Cause:** GitHub CLI not installed or not authenticated

**Solution:**
1. Install GitHub CLI: https://cli.github.com/
2. Authenticate: `gh auth login`
3. Test: `gh repo view`

### Git Commands Fail

**Cause:** Git not installed

**Solution:**
1. Install Git: https://git-scm.com/download/win
2. Restart terminal
3. Test: `git --version`

---

## Getting Help

### Documentation Files
- **README.md** - Package overview
- **QUICK-START.md** - 2-minute quick start
- **SETUP-GUIDE.md** - Manual setup instructions
- **INTERACTIVE-SETUP-GUIDE.md** - Interactive wizard guide
- **LINEAR-CUSTOMIZATION-CHECKLIST.md** - Linear setup steps
- **SETUP-OPTIONS-SUMMARY.md** - Setup comparison

### Interactive Setup
Run the interactive wizard for guided setup:
```bash
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows
interactive-setup.bat
```

---

**Document Version:** 1.0 - Windows Edition
**Last Updated:** 2025-12-14
**Platform:** Windows-optimized (also works on macOS/Linux)
