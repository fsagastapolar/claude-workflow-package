# Your Linear Setup - Complete Summary

## ✅ What I've Done For You

I've created everything you need to set up Linear integration with Claude Code:

### 1. **Pre-Configured MCP Config**
**File:** [LINEAR-MCP-CONFIG.json](LINEAR-MCP-CONFIG.json)
- Contains your Linear API key: `lin_api_YOUR_LINEAR_API_KEY_HERE`
- Pre-configured with correct paths
- Ready to use

### 2. **Automated Setup Script**
**File:** [setup-linear.bat](setup-linear.bat)
- One-click setup
- Installs Linear MCP server
- Copies configuration to correct location
- Verifies everything works

### 3. **Detailed Instructions**
**File:** [LINEAR-MCP-SETUP-INSTRUCTIONS.md](LINEAR-MCP-SETUP-INSTRUCTIONS.md)
- Complete setup guide
- Troubleshooting section
- Alternative configuration methods

### 4. **Customization Checklist**
**File:** [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)
- Step-by-step checklist for customizing linear.md
- Shows exactly which lines to update
- Tracks your progress

### 5. **Security Protection**
**File:** [.gitignore](.gitignore)
- Prevents committing your API key
- Protects sensitive configuration files

---

## 🚀 Quick Setup (Project-Specific)

**Linear MCP configured ONLY for projects where you need it - no context bloat!**

1. **Navigate to your project:**
   ```bash
   cd C:\path\to\your-project
   ```

2. **Copy .claude folder (if not done yet):**
   ```bash
   cp -r C:\PolarCode\MultiAgentSetup\claude-workflow-windows\.claude .
   ```

3. **Run the setup script:**
   ```bash
   C:\PolarCode\MultiAgentSetup\claude-workflow-windows\setup-linear.bat
   ```

4. **Restart VS Code**

5. **Test (only works in this project):**
   ```
   mcp__linear__list_teams
   ```

**Result:** Linear MCP only in this project. Other projects unaffected! ✅

---

## 🛠️ Manual Setup (Alternative)

If you prefer manual setup:

### Step 1: Install Linear MCP Server
```bash
npm install -g @modelcontextprotocol/server-linear
```

### Step 2: Copy Configuration to Your Project
```bash
# Navigate to your project
cd C:\path\to\your-project

# Copy config to project .claude directory
cp C:\PolarCode\MultiAgentSetup\claude-workflow-windows\LINEAR-MCP-CONFIG.json .claude\mcp_config.json
```

### Step 3: Restart VS Code

### Step 4: Test
In Claude Code:
```
mcp__linear__list_teams
```

---

## 📋 After MCP Server is Working

Once `mcp__linear__list_teams` returns your teams, follow these steps:

### 1. Get Your Linear IDs

Run these commands in Claude Code:

```
mcp__linear__list_teams
```
→ Copy your team UUID

```
mcp__linear__list_workflow_states
```
→ Copy all state UUIDs (Backlog, Todo, In Progress, In Review, Done, Canceled)

```
mcp__linear__list_labels
```
→ Copy all label UUIDs (bug, feature, enhancement, etc.)

```
mcp__linear__list_users
```
→ Copy UUIDs for yourself and teammates

```
mcp__linear__list_projects
```
→ Copy project UUID (optional)

### 2. Customize linear.md

Open: `.claude\commands\linear.md`

Replace these sections:
- **Line ~362:** Team ID
- **Lines ~365-368:** Label IDs
- **Lines ~373-378:** Workflow State IDs
- **Lines ~383-385:** User IDs
- **Line ~59:** GitHub URLs (optional)
- **Lines ~40-46:** Workflow description

**Use the checklist:** [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)

### 3. Test Linear Integration

In Claude Code:
```
/linear
```

Should show:
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket
3. Search for tickets
4. Update ticket status or details
```

✅ **Success!** You can now manage Linear tickets from Claude Code!

---

## 🔒 Security Important!

Your API key is stored in:
- `LINEAR-MCP-CONFIG.json` (this directory - template)
- `C:\Users\sagas\.claude\mcp_config.json` (active config)

**These files are in .gitignore** - they won't be committed to git.

**Keep your API key secure:**
- Don't share these files
- Don't commit to public repos
- Regenerate key if exposed: https://linear.app/settings/api

---

## 📁 Files Created

```
claude-workflow-windows/
├── LINEAR-MCP-CONFIG.json              # ← Your pre-configured MCP config
├── LINEAR-MCP-SETUP-INSTRUCTIONS.md    # ← Detailed setup guide
├── LINEAR-CUSTOMIZATION-CHECKLIST.md   # ← Customization checklist
├── setup-linear.bat                    # ← Automated setup script
├── YOUR-LINEAR-SETUP-SUMMARY.md        # ← This file
└── .gitignore                          # ← Protects your API key
```

---

## ✅ Complete Setup Checklist

### Installation
- [ ] Run `setup-linear.bat` (or manual setup)
- [ ] Restart VS Code
- [ ] Test: `mcp__linear__list_teams` works

### Customization
- [ ] Run all `mcp__linear__list_*` commands
- [ ] Copy all UUIDs
- [ ] Update `.claude\commands\linear.md` with your IDs
- [ ] Verify no placeholder IDs remain

### Testing
- [ ] Test: `/linear` command works
- [ ] Create a test ticket
- [ ] Search for tickets
- [ ] Update ticket status
- [ ] Delete test ticket

### Cleanup
- [ ] Add `.gitignore` to your project
- [ ] Verify API key not in git
- [ ] Document your customizations

---

## 🆘 Troubleshooting

### "MCP tools not found"

**Solution:**
1. Check installation: `npm list -g @modelcontextprotocol/server-linear`
2. Restart VS Code completely
3. Check config exists: `cat C:\Users\sagas\.claude\mcp_config.json`

### "Module not found" or "Cannot find module"

**Solution:**
Update `LINEAR-MCP-CONFIG.json` to use `npx`:

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

Then copy to `C:\Users\sagas\.claude\mcp_config.json` again.

### "Invalid API key"

**Solution:**
1. Verify key is correct: `lin_api_YOUR_LINEAR_API_KEY_HERE`
2. Generate new key: https://linear.app/settings/api
3. Update in `LINEAR-MCP-CONFIG.json` and copy again

### Script fails

**Solution:**
Follow manual setup in [LINEAR-MCP-SETUP-INSTRUCTIONS.md](LINEAR-MCP-SETUP-INSTRUCTIONS.md)

---

## 📚 Documentation References

- **Quick Start:** [QUICK-START.md](QUICK-START.md)
- **Main Guide:** [README.md](README.md)
- **Setup Guide:** [SETUP-GUIDE.md](SETUP-GUIDE.md)
- **Linear Setup:** [LINEAR-MCP-SETUP-INSTRUCTIONS.md](LINEAR-MCP-SETUP-INSTRUCTIONS.md)
- **Customization:** [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md)

---

## 🎯 What You'll Be Able to Do

Once setup is complete:

✅ Create Linear tickets from Claude Code
✅ Update ticket status
✅ Add comments to tickets
✅ Search for tickets
✅ Manage ticket workflow
✅ Link tickets to code/docs
✅ All from within Claude Code!

---

## 🚀 Next Steps

1. **Right now:** Run `setup-linear.bat`
2. **Restart VS Code**
3. **Test:** `mcp__linear__list_teams`
4. **Get IDs:** Run all `mcp__linear__list_*` commands
5. **Customize:** Update `linear.md` with your IDs
6. **Use it:** `/linear` to manage tickets!

---

## Need Anything Else?

Your setup is complete! You have:
- ✅ Pre-configured Linear MCP server
- ✅ Automated setup script
- ✅ Complete documentation
- ✅ Security protection (.gitignore)
- ✅ Customization checklist

Just run `setup-linear.bat` and you're ready to go!

**Any questions or issues?** Check:
1. [LINEAR-MCP-SETUP-INSTRUCTIONS.md](LINEAR-MCP-SETUP-INSTRUCTIONS.md) - Detailed guide
2. [LINEAR-CUSTOMIZATION-CHECKLIST.md](LINEAR-CUSTOMIZATION-CHECKLIST.md) - Customization steps
3. Troubleshooting section above
