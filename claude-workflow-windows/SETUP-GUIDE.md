# Windows Setup Guide - Step by Step

This guide will walk you through setting up the Claude Code Workflow Package on Windows with Linear integration.

## Part 1: Basic Setup (5 minutes)

### Step 1: Copy .claude Folder

```bash
# Navigate to your project
cd C:\path\to\your\project

# Copy the .claude folder from this repository
cp -r path\to\claude-workflow-windows\.claude .

# Verify
ls .claude\
# Should see: agents/, commands/, settings.json
```

### Step 2: Test Basic Functionality

1. Open your project in Claude Code
2. Type: `/research_codebase_nt what is the structure?`
3. If it works, ✅ basic setup complete!

---

## Part 2: Linear Integration Setup (20 minutes)

### Prerequisites

1. **Install Linear MCP Server**
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

2. **Get Linear API Key**
   - Go to https://linear.app/settings/api
   - Create a new API key
   - Copy it (you'll need it next)

3. **Configure Claude Code MCP**
   - Open Claude Code settings
   - Add Linear MCP server configuration
   - Paste your API key

### Step 3: Gather Your Linear IDs

Open Claude Code and run these commands one by one:

#### Get Team ID
```
mcp__linear__list_teams
```
**Copy the team UUID** - looks like: `abc12345-1234-5678-90ab-cdef12345678`

#### Get Project IDs (optional)
```
mcp__linear__list_projects
```
**Copy your default project UUID**

#### Get Workflow State IDs
```
mcp__linear__list_workflow_states
```
**Copy UUIDs for:**
- Backlog
- Todo
- In Progress
- In Review
- Done
- Canceled
- Any other states you use

#### Get Label IDs
```
mcp__linear__list_labels
```
**Copy UUIDs for:**
- Bug
- Feature
- Enhancement
- Any other labels you use

#### Get User IDs
```
mcp__linear__list_users
```
**Copy UUIDs for yourself and teammates**

### Step 4: Update linear.md

Now open `.claude\commands\linear.md` in your editor and replace:

#### Line ~362: Team ID
```markdown
### Your Team
- **Team ID**: `YOUR_TEAM_ID_HERE`
```
Replace `YOUR_TEAM_ID_HERE` with your actual team UUID.

#### Lines ~365-368: Label IDs
```markdown
### Your Labels (customize based on your project)
- **bug**: `YOUR_BUG_LABEL_ID`
- **feature**: `YOUR_FEATURE_LABEL_ID`
- **enhancement**: `YOUR_ENHANCEMENT_LABEL_ID`
```
Replace with your actual label UUIDs.

#### Lines ~373-378: Workflow State IDs
```markdown
- **Backlog**: `YOUR_BACKLOG_STATE_ID` (type: backlog)
- **Todo**: `YOUR_TODO_STATE_ID` (type: unstarted)
- **In Progress**: `YOUR_IN_PROGRESS_STATE_ID` (type: started)
- **In Review**: `YOUR_IN_REVIEW_STATE_ID` (type: started)
- **Done**: `YOUR_DONE_STATE_ID` (type: completed)
- **Canceled**: `YOUR_CANCELED_STATE_ID` (type: canceled)
```
Replace with your actual workflow state UUIDs.

#### Lines ~383-385: User IDs
```markdown
### Your Linear User IDs
- your_name: YOUR_USER_ID_HERE
- teammate1: TEAMMATE1_ID_HERE
```
Replace with your actual user UUIDs.

#### Line ~59: GitHub URLs (optional)
If you have a docs repository, update:
```markdown
### URL Mapping for Documents (CUSTOMIZE THIS)
When referencing documentation, always provide GitHub links using the `links` parameter:
- `docs/...` → `https://github.com/YOUR_ORG/YOUR_REPO/blob/main/docs/...`
```

#### Lines ~40-46: Workflow Description
Update to match YOUR team's workflow:
```markdown
Example workflow (customize based on your Linear workspace):

1. **Backlog** → Tickets waiting to be prioritized
2. **Todo** → Ready to be worked on
3. **In Progress** → Active development
4. **In Review** → PR submitted for review
5. **Done** → Completed
```

### Step 5: Test Linear Integration

In Claude Code, try:
```
/linear
```

Should respond with:
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

✅ If you see this, Linear integration is working!

---

## Part 3: Recommended First Steps

### 1. Create a Test Plan

```
/create_plan_nt

When prompted: "Let's create a test plan to verify the workflow system works"
```

Claude will:
- Ask clarifying questions
- Research your codebase
- Create a structured plan
- Ask where to save it

### 2. Try Codebase Research

```
/research_codebase_nt how is the authentication implemented?
```

Claude will:
- Spawn multiple agents
- Analyze your codebase
- Return structured findings

### 3. Make a Test Commit

```bash
# Make a small change (like updating a comment)
# Then:
/commit
```

Claude will:
- Review your changes
- Draft a commit message
- Ask for approval
- Create the commit

### 4. (Optional) Create a Linear Ticket

If you have Linear set up:
```
/linear

Select option 1 (create ticket)
Provide a simple description
```

Claude will:
- Create a structured ticket
- Add it to your Linear workspace
- Return the ticket URL

---

## Troubleshooting

### Issue: `/research_codebase_nt` command not found

**Solution:**
```bash
# Verify commands exist
ls .claude\commands\

# Should see: research_codebase_nt.md
```

If missing, re-copy the .claude folder.

### Issue: Linear MCP tools not found

**Solution:**
1. Verify Linear MCP server is installed: `npm list -g @modelcontextprotocol/server-linear`
2. Check Claude Code MCP configuration
3. Restart Claude Code

### Issue: Git commands fail

**Solution:**
Install Git for Windows:
- Download from: https://git-scm.com/download/win
- Include Git Bash during installation

### Issue: `gh` command not found (for PR creation)

**Solution:**
Install GitHub CLI:
```bash
winget install --id GitHub.cli
```

---

## Customization Tips

### Simplify Commands

Don't need all 11 commands? Remove unwanted ones:
```bash
cd .claude\commands
rm iterate_plan_nt.md  # If you don't iterate on plans
rm ci_commit.md        # If not using CI
rm ci_describe_pr.md   # If not using CI
```

### Customize Agent Behavior

Agents are just markdown files! Edit `.claude\agents\codebase-locator.md` to:
- Change search patterns
- Adjust output format
- Modify instructions

### Add Your Own Commands

```bash
# Create new command
notepad .claude\commands\my_custom_command.md
```

Add:
```markdown
---
description: Brief description
model: sonnet
---

# My Custom Command

When the user types /my_custom_command:

1. Do this
2. Then this
3. Finally this
```

Save and use: `/my_custom_command`

---

## Next Steps

### Week 1: Core Usage
- ✅ Use `/research_codebase_nt` to explore your project
- ✅ Create plans with `/create_plan_nt`
- ✅ Make commits with `/commit`

### Week 2: Linear Integration
- ✅ Set up Linear MCP server
- ✅ Customize linear.md with your IDs
- ✅ Create tickets from Claude Code

### Week 3: Customization
- ✅ Modify commands to match your workflow
- ✅ Remove unused commands
- ✅ Add custom commands for your team

### Week 4: Team Adoption
- ✅ Share setup with team
- ✅ Document your customizations
- ✅ Establish workflow patterns

---

## Quick Reference

### Most Used Commands

| Command | Use When |
|---------|----------|
| `/research_codebase_nt` | Exploring unfamiliar code |
| `/create_plan_nt` | Planning new features |
| `/implement_plan` | Executing a plan |
| `/commit` | Creating commits |
| `/describe_pr_nt` | Creating PRs |
| `/debug` | Investigating bugs |
| `/linear` | Managing tickets |

### Linear MCP Tools

| Tool | Purpose |
|------|---------|
| `mcp__linear__list_teams` | Get team IDs |
| `mcp__linear__list_projects` | Get project IDs |
| `mcp__linear__list_workflow_states` | Get state IDs |
| `mcp__linear__list_labels` | Get label IDs |
| `mcp__linear__list_users` | Get user IDs |
| `mcp__linear__create_issue` | Create ticket |
| `mcp__linear__update_issue` | Update ticket |
| `mcp__linear__create_comment` | Add comment |

---

## Success Checklist

After setup, verify:

- [ ] `.claude` folder copied to project
- [ ] Can invoke `/research_codebase_nt` successfully
- [ ] Can invoke `/create_plan_nt` successfully
- [ ] Can invoke `/commit` successfully
- [ ] Linear MCP server installed (if using Linear)
- [ ] Linear IDs customized in linear.md (if using Linear)
- [ ] Can invoke `/linear` successfully (if using Linear)
- [ ] Git commands work (if using git workflows)
- [ ] GitHub CLI installed (if creating PRs)

---

## Getting Help

### Command Documentation
Commands are self-documenting:
```bash
cat .claude\commands\create_plan_nt.md
```

### Agent Documentation
```bash
cat .claude\agents\codebase-locator.md
```

### Issues
- Check [README.md](README.md) for detailed info
- Review original HumanLayer documentation

---

**Setup Complete!** 🎉

You now have a fully functional Claude Code workflow system on Windows with Linear integration support!
