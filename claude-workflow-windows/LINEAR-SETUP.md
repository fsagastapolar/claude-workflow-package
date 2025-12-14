# Linear Integration Setup

Complete guide to setting up Linear integration with Claude Code on Windows.

---

## Prerequisites

Before you begin, make sure you have:

- **Node.js & npm** installed (download from https://nodejs.org/)
- **Linear account** with API access
- **Linear API key** (get from https://linear.app/settings/api)
- **Claude Code** VS Code extension installed

---

## Installation

### Step 1: Install Linear MCP Server

Install the Linear MCP server package globally:

```bash
npm install -g @modelcontextprotocol/server-linear
```

**Verify installation:**
```bash
npm list -g @modelcontextprotocol/server-linear
```

You should see the package version listed.

### Step 2: Understand Configuration Options

You have two options for configuring the Linear MCP server:

#### Option A: Global Configuration
**Location:** `C:\Users\YOUR_USERNAME\.claude\mcp_config.json`

**Pros:**
- Available in all Claude Code projects
- One-time setup

**Cons:**
- Could add Linear tools to context in projects that don't need them
- Less control over which projects have Linear access

#### Option B: Project-Specific Configuration (Recommended)
**Location:** `your-project\.claude\mcp_config.json`

**Pros:**
- ✅ Linear MCP only available where you need it
- ✅ No context bloat in other projects
- ✅ Full control per project
- ✅ Clean separation

**Cons:**
- Need to configure for each project

**Recommendation:** Use project-specific configuration to avoid context bloat.

---

## Configuration

### For Project-Specific Setup (Recommended)

#### 1. Locate Your npm Global Installation Path

Find where npm installed the Linear MCP server:

```bash
npm root -g
```

Common paths:
- `C:\Users\YOUR_USERNAME\AppData\Roaming\npm\node_modules\`
- `C:\Program Files\nodejs\node_modules\`
- `C:\Users\YOUR_USERNAME\AppData\Local\npm\node_modules\`

#### 2. Create MCP Configuration File

In your project's `.claude` directory, create `mcp_config.json`:

```json
{
  "mcpServers": {
    "linear": {
      "command": "node",
      "args": [
        "C:\\Users\\YOUR_USERNAME\\AppData\\Roaming\\npm\\node_modules\\@modelcontextprotocol\\server-linear\\dist\\index.js"
      ],
      "env": {
        "LINEAR_API_KEY": "lin_api_YOUR_LINEAR_API_KEY_HERE"
      }
    }
  }
}
```

**Important:** Replace the following:
- `YOUR_USERNAME` with your actual Windows username
- `lin_api_YOUR_LINEAR_API_KEY_HERE` with your actual Linear API key
- Update the path if your npm global directory is different

#### 3. Alternative: Use npx (Simpler)

If you want to avoid path issues, use `npx`:

```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-linear"
      ],
      "env": {
        "LINEAR_API_KEY": "lin_api_YOUR_LINEAR_API_KEY_HERE"
      }
    }
  }
}
```

This automatically finds the correct installation path.

#### 4. Restart VS Code

After creating the configuration:
1. Close VS Code completely (not just the window)
2. Reopen VS Code
3. Open your project in Claude Code

---

## Getting Your Linear IDs

Once the MCP server is configured, you need to get your workspace-specific IDs.

### Test the Connection First

In Claude Code, run:

```
mcp__linear__list_teams
```

**Expected result:** A list of your Linear teams with their IDs.

**If it works:** ✅ MCP server is configured correctly! Continue below.

**If it doesn't work:** See [Troubleshooting](#troubleshooting) section.

### Gather All Required IDs

Run these commands in Claude Code and copy the UUIDs:

#### 1. Team ID
```
mcp__linear__list_teams
```
Copy your team UUID (36 characters, format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

#### 2. Workflow State IDs
```
mcp__linear__list_workflow_states
```
Copy UUIDs for all states you use:
- Backlog
- Todo
- In Progress
- In Review
- Done
- Canceled
- Any custom states

#### 3. Label IDs
```
mcp__linear__list_labels
```
Copy UUIDs for labels you use:
- bug
- feature
- enhancement
- frontend
- backend
- docs
- Any custom labels

#### 4. User IDs
```
mcp__linear__list_users
```
Copy UUIDs for yourself and your team members.

#### 5. Project IDs (Optional)
```
mcp__linear__list_projects
```
Copy your default project UUID if you have one.

---

## Customizing linear.md

Now you need to update the Linear command file with your workspace-specific IDs.

### Open the File

Edit: `.claude\commands\linear.md`

### Required Updates

#### 1. Team ID (Line ~362)

Find:
```markdown
### Your Team
- **Team ID**: `YOUR_TEAM_ID_HERE`
```

Replace `YOUR_TEAM_ID_HERE` with your team's UUID.

#### 2. Label IDs (Lines ~365-368)

Find:
```markdown
### Your Labels (customize based on your project)
- **bug**: `YOUR_BUG_LABEL_ID`
- **feature**: `YOUR_FEATURE_LABEL_ID`
- **enhancement**: `YOUR_ENHANCEMENT_LABEL_ID`
```

Replace each placeholder with the corresponding UUID from your Linear workspace.

Add any additional labels your team uses.

#### 3. Workflow State IDs (Lines ~370-380)

Find:
```markdown
- **Backlog**: `YOUR_BACKLOG_STATE_ID` (type: backlog)
- **Todo**: `YOUR_TODO_STATE_ID` (type: unstarted)
- **In Progress**: `YOUR_IN_PROGRESS_STATE_ID` (type: started)
- **In Review**: `YOUR_IN_REVIEW_STATE_ID` (type: started)
- **Done**: `YOUR_DONE_STATE_ID` (type: completed)
- **Canceled**: `YOUR_CANCELED_STATE_ID` (type: canceled)
```

Replace each state ID with your actual workflow state UUIDs.

Update state names if your workflow uses different names (e.g., "Doing" instead of "In Progress").

#### 4. User IDs (Lines ~383-385)

Find:
```markdown
### Your Linear User IDs
- your_name: YOUR_USER_ID_HERE
- teammate1: TEAMMATE1_ID_HERE
- teammate2: TEAMMATE2_ID_HERE
```

Replace with your actual team members and their UUIDs.

#### 5. GitHub URLs (Line ~59, Optional)

Find:
```markdown
### URL Mapping for Documents (CUSTOMIZE THIS)
When referencing documentation, always provide GitHub links using the `links` parameter:
- `docs/...` → `https://github.com/YOUR_ORG/YOUR_REPO/blob/main/docs/...`
```

Replace `YOUR_ORG` and `YOUR_REPO` with your GitHub organization and repository.

#### 6. Workflow Description (Lines ~36-48, Optional)

Find:
```markdown
Example workflow (customize based on your Linear workspace):

1. **Backlog** → Tickets waiting to be prioritized
2. **Todo** → Ready to be worked on
3. **In Progress** → Active development
4. **In Review** → PR submitted for review
5. **Done** → Completed
```

Update to match your team's actual workflow and process.

### Verification Checklist

After updating, search for these in `linear.md` - **none should exist:**

- [ ] No `YOUR_TEAM_ID_HERE`
- [ ] No `YOUR_BUG_LABEL_ID`
- [ ] No `YOUR_FEATURE_LABEL_ID`
- [ ] No `YOUR_ENHANCEMENT_LABEL_ID`
- [ ] No `YOUR_BACKLOG_STATE_ID`
- [ ] No `YOUR_TODO_STATE_ID`
- [ ] No `YOUR_IN_PROGRESS_STATE_ID`
- [ ] No `YOUR_IN_REVIEW_STATE_ID`
- [ ] No `YOUR_DONE_STATE_ID`
- [ ] No `YOUR_CANCELED_STATE_ID`
- [ ] No `YOUR_USER_ID_HERE`
- [ ] No `TEAMMATE1_ID_HERE`
- [ ] No `YOUR_ORG`
- [ ] No `YOUR_REPO`

**Format checks:**
- [ ] All UUIDs are 36 characters (8-4-4-4-12 format)
- [ ] All UUIDs are lowercase
- [ ] All UUIDs are wrapped in backticks

---

## Testing

### Test 1: Basic Command

In Claude Code:
```
/linear
```

**Expected response:**
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

**If you see this:** ✅ Linear command is working!

### Test 2: Create a Ticket

```
/linear
```
Select: Create a new ticket
Provide: "Test ticket - verifying Linear integration works"

**Expected:**
- Ticket created successfully
- Ticket appears in your Linear workspace
- Ticket has correct default status

### Test 3: Search for Tickets

```
/linear
```
Select: Search for tickets
Search: "test"

**Expected:**
- Search returns results
- Results include the test ticket you just created

### Test 4: Update Ticket Status

```
/linear
```
Select: Update ticket status
Ticket: [the test ticket]
New status: In Progress

**Expected:**
- Status updated successfully
- Status change visible in Linear workspace

### Test 5: Cleanup

After successful testing:
- Delete the test ticket from Linear
- ✅ Linear integration is fully functional!

---

## Troubleshooting

### Issue: "MCP tools not found"

**Solution 1: Check installation path**
```bash
# Find where the server is installed
npm root -g

# Update the path in mcp_config.json to match the actual location
```

**Solution 2: Verify Node.js is in PATH**
```bash
node --version
```
Should show Node.js version. If not, add Node.js to your PATH.

**Solution 3: Use npx instead**

Edit `mcp_config.json` and use the npx configuration shown earlier.

**Solution 4: Restart VS Code**

Close VS Code completely and reopen.

### Issue: "Permission denied"

**Solution:**
Run VS Code as administrator once, then restart normally.

### Issue: "Module not found"

**Solution:**
Reinstall the Linear MCP server:
```bash
npm uninstall -g @modelcontextprotocol/server-linear
npm install -g @modelcontextprotocol/server-linear
```

### Issue: "Invalid API key"

**Solution:**
1. Verify your API key is correct in `mcp_config.json`
2. Generate a new API key at: https://linear.app/settings/api
3. Update the key in `mcp_config.json`
4. Restart VS Code

### Issue: "Invalid team ID" or "State not found"

**Solution:**
1. Re-run the appropriate `mcp__linear__list_*` command
2. Copy the exact UUID (including dashes)
3. Ensure it's wrapped in backticks in `linear.md`
4. Ensure it's lowercase

### Issue: Tickets created with wrong status

**Solution:**
1. Check the default "Triage" state ID in `linear.md` is correct
2. Verify the state ID matches your workspace
3. Update the status progression logic in `linear.md`

---

## Security Important!

**⚠️ Your Linear API key is sensitive!**

The API key is stored in:
- `mcp_config.json` (in your project's `.claude` directory)
- Or `C:\Users\YOUR_USERNAME\.claude\mcp_config.json` (if using global config)

**Protect your API key:**

1. **Add to .gitignore:**
   ```bash
   echo "mcp_config.json" >> .gitignore
   echo ".claude/mcp_config.json" >> .claude/.gitignore
   ```

2. **Never commit to git:**
   - Don't add `mcp_config.json` to version control
   - Don't share this file publicly

3. **Regenerate if exposed:**
   - If your key is ever exposed, regenerate immediately at: https://linear.app/settings/api

---

## Quick Reference: MCP Commands

| Command | Purpose |
|---------|---------|
| `mcp__linear__list_teams` | Get team IDs |
| `mcp__linear__list_projects` | Get project IDs |
| `mcp__linear__list_workflow_states` | Get state IDs |
| `mcp__linear__list_labels` | Get label IDs |
| `mcp__linear__list_users` | Get user IDs |
| `mcp__linear__create_issue` | Create ticket |
| `mcp__linear__update_issue` | Update ticket |
| `mcp__linear__create_comment` | Add comment |
| `mcp__linear__list_issues` | Search tickets |

---

## What You Can Do Now

Once setup is complete, you can:

✅ Create Linear tickets from Claude Code
✅ Update ticket status
✅ Add comments to tickets
✅ Search for tickets
✅ Manage ticket workflow
✅ Link tickets to code/docs
✅ All from within Claude Code!

---

## Additional Resources

- **[LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)** - Detailed step-by-step checklist
- **[LINEAR-QUICK-SETUP.txt](LINEAR-QUICK-SETUP.txt)** - One-page reference card
- **[GETTING-STARTED.md](GETTING-STARTED.md)** - Overall setup guide
- **Linear API Documentation:** https://developers.linear.app/

---

**Setup Complete!** ✅

Your Linear integration is now fully configured for your workspace!
