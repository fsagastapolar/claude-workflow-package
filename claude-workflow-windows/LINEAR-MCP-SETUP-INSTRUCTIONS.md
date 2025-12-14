# Linear MCP Server Setup Instructions

## Your Configuration

I've created a pre-configured MCP server configuration file for you with your Linear API key.

**File:** [LINEAR-MCP-CONFIG.json](LINEAR-MCP-CONFIG.json)

---

## Step 1: Install Linear MCP Server

First, install the Linear MCP server globally:

```bash
npm install -g @modelcontextprotocol/server-linear
```

**Verify installation:**
```bash
npm list -g @modelcontextprotocol/server-linear
```

You should see the package version listed.

---

## Step 2: Locate Your Claude Code Configuration

Claude Code (VS Code extension) stores MCP configuration in one of these locations:

### Option A: Global Configuration (Recommended)
**Location:** `C:\Users\sagas\.claude\mcp_config.json`

Create this directory if it doesn't exist:
```bash
mkdir C:\Users\sagas\.claude
```

### Option B: Workspace Configuration
**Location:** In your project's `.claude\mcp_config.json`

This is project-specific and won't affect other projects.

---

## Step 3: Configure MCP Server

### If using Global Configuration (Recommended):

1. **Create the directory:**
   ```bash
   mkdir C:\Users\sagas\.claude
   ```

2. **Copy the config file:**
   ```bash
   cp C:\PolarCode\MultiAgentSetup\claude-workflow-windows\LINEAR-MCP-CONFIG.json C:\Users\sagas\.claude\mcp_config.json
   ```

3. **Verify the file exists:**
   ```bash
   cat C:\Users\sagas\.claude\mcp_config.json
   ```

### If using Workspace Configuration:

1. **Copy to your project:**
   ```bash
   cp C:\PolarCode\MultiAgentSetup\claude-workflow-windows\LINEAR-MCP-CONFIG.json C:\path\to\your-project\.claude\mcp_config.json
   ```

2. **Verify:**
   ```bash
   cat C:\path\to\your-project\.claude\mcp_config.json
   ```

---

## Step 4: Verify Installation Path

The configuration assumes the Linear MCP server is installed at:
```
C:\Users\sagas\AppData\Roaming\npm\node_modules\@modelcontextprotocol\server-linear\dist\index.js
```

**Verify this path exists:**
```bash
ls "C:\Users\sagas\AppData\Roaming\npm\node_modules\@modelcontextprotocol\server-linear\dist\index.js"
```

**If the file doesn't exist,** find the correct path:
```bash
npm root -g
```

This will show you where global npm packages are installed. Update the path in `mcp_config.json` accordingly.

**Common paths:**
- `C:\Users\sagas\AppData\Roaming\npm\node_modules\...`
- `C:\Program Files\nodejs\node_modules\...`
- `C:\Users\sagas\AppData\Local\npm\node_modules\...`

---

## Step 5: Restart VS Code / Claude Code

After configuring the MCP server:

1. **Close VS Code completely** (not just the window)
2. **Reopen VS Code**
3. **Open your project** in Claude Code

---

## Step 6: Test the Connection

In Claude Code, try running:

```
mcp__linear__list_teams
```

**Expected result:** A list of your Linear teams with their IDs.

**If it works:** ✅ MCP server is configured correctly!

**If it doesn't work:** See troubleshooting below.

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

Edit `mcp_config.json` and change the command:
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
1. Verify your API key is correct: `lin_api_YOUR_LINEAR_API_KEY_HERE`
2. Generate a new API key at: https://linear.app/settings/api
3. Update the key in `mcp_config.json`

---

## Step 7: Get Your Linear IDs

Once the MCP server is working, get your workspace IDs:

### Get Team ID
```
mcp__linear__list_teams
```
Copy your team UUID.

### Get Workflow State IDs
```
mcp__linear__list_workflow_states
```
Copy UUIDs for all states you use (Backlog, Todo, In Progress, In Review, Done, etc.)

### Get Label IDs
```
mcp__linear__list_labels
```
Copy UUIDs for labels you use (bug, feature, enhancement, etc.)

### Get User IDs
```
mcp__linear__list_users
```
Copy UUIDs for yourself and teammates.

### Get Project IDs (optional)
```
mcp__linear__list_projects
```
Copy your default project UUID if you have one.

---

## Step 8: Customize linear.md

Now update `.claude\commands\linear.md` with your IDs:

**Use the checklist:** [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)

Replace all placeholders:
- Line ~362: Team ID
- Lines ~365-368: Label IDs
- Lines ~373-378: Workflow State IDs
- Lines ~383-385: User IDs

---

## Step 9: Test Linear Integration

In Claude Code:
```
/linear
```

Should respond:
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

**If you see this:** ✅ Linear integration is fully working!

---

## Alternative: Manual MCP Configuration

If you prefer to configure manually or the paths are different:

### 1. Find the correct config location

Check VS Code settings:
- Open VS Code
- Press `Ctrl+Shift+P`
- Type "Preferences: Open User Settings (JSON)"
- Look for MCP configuration

### 2. Add Linear MCP server

Add this configuration:
```json
{
  "mcpServers": {
    "linear": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-linear"],
      "env": {
        "LINEAR_API_KEY": "lin_api_YOUR_LINEAR_API_KEY_HERE"
      }
    }
  }
}
```

---

## Security Note

**⚠️ IMPORTANT:** The `LINEAR-MCP-CONFIG.json` file contains your Linear API key.

**DO NOT:**
- Commit this file to git
- Share this file publicly
- Include it in your repository

**Add to .gitignore:**
```bash
echo "LINEAR-MCP-CONFIG.json" >> .gitignore
echo "mcp_config.json" >> .gitignore
echo ".claude/mcp_config.json" >> .claude/.gitignore
```

**The key is stored in:**
- `LINEAR-MCP-CONFIG.json` (template/backup)
- `C:\Users\sagas\.claude\mcp_config.json` (active config)

Keep these files secure!

---

## Summary

✅ **What you have:**
- Linear API key: `lin_api_YOUR_LINEAR_API_KEY_HERE`
- Pre-configured MCP config: `LINEAR-MCP-CONFIG.json`

✅ **What to do:**
1. Install Linear MCP server: `npm install -g @modelcontextprotocol/server-linear`
2. Copy config to: `C:\Users\sagas\.claude\mcp_config.json`
3. Restart VS Code
4. Test: `mcp__linear__list_teams`
5. Get your Linear IDs
6. Customize `linear.md`
7. Test: `/linear`

✅ **When done:**
- ✅ Can use `/linear` command
- ✅ Can create tickets from Claude Code
- ✅ Can update ticket status
- ✅ Can search tickets
- ✅ Can add comments

---

**Need help?** Check the troubleshooting section above or ask!
