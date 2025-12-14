# Quick Start - 2 Minutes

## Install (30 seconds)

```bash
# Copy to your project
cp -r C:\PolarCode\MultiAgentSetup\claude-workflow-windows\.claude C:\path\to\your-project\
```

## Test (30 seconds)

Open your project in Claude Code and type:
```
/research_codebase_nt what is the overall structure?
```

If it works → ✅ You're done! Start using it.

---

## Most Useful Commands

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

Only if you use Linear:

1. Install MCP server:
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

2. Get your Linear IDs:
   ```
   mcp__linear__list_teams
   mcp__linear__list_workflow_states
   mcp__linear__list_labels
   mcp__linear__list_users
   ```

3. Edit `.claude\commands\linear.md` and replace placeholder IDs

4. Test: `/linear`

**OR skip Linear:** `rm .claude\commands\linear.md`

---

## Examples

### Research Code
```
You: /research_codebase_nt how does authentication work?
Claude: [spawns agents, analyzes code, returns findings with file references]
```

### Create Plan
```
You: /create_plan_nt
Claude: What are we building?
You: Add OAuth2 support to login
Claude: [asks questions, researches, creates structured plan]
```

### Make Commit
```
You: /commit
Claude: [reviews changes, drafts message, asks for approval]
```

### Linear Ticket
```
You: /linear
Claude: What would you like to do?
You: Create a ticket for adding OAuth2 support
Claude: [creates structured ticket in Linear]
```

---

## Full Documentation

- **README.md** - Complete guide
- **SETUP-GUIDE.md** - Step-by-step Linear setup
- **INSTALLATION-SUMMARY.md** - What you have

---

## That's It!

You now have:
- 6 AI agents for code analysis
- 11 workflow commands
- Linear integration support

**Start using it immediately** - no complex setup required!
