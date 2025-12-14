# MCP Server: Global vs. Project Configuration

## Your Question

> Will installing MCP servers globally make them available in all projects and bloat context?

**Short Answer:** No! The npm package is installed globally, but MCP servers are **only active where you configure them**.

---

## How It Actually Works

### **Two Separate Things:**

1. **NPM Package Installation** (where the code lives)
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```
   - Installs the Linear MCP server CODE to your system
   - Just files on disk - doesn't run automatically
   - Location: `C:\Users\sagas\AppData\Roaming\npm\node_modules\...`

2. **MCP Server Configuration** (which projects can use it)
   - This is what actually ENABLES the MCP server
   - Only projects with `mcp_config.json` can use it
   - No config = no MCP server running = no context bloat

---

## Configuration Options

### **Option 1: Global Configuration** ❌ Not Recommended for You

**Config File:** `C:\Users\sagas\.claude\mcp_config.json`

**Result:**
- Linear MCP available in **ALL** Claude Code projects
- Could add Linear tools to context in projects that don't need them
- Convenient if you use Linear everywhere

**When to use:**
- You use Linear in every project
- You want one-time setup

---

### **Option 2: Project-Specific Configuration** ✅ Recommended for You

**Config File:** `your-project\.claude\mcp_config.json`

**Result:**
- Linear MCP **ONLY** available in projects where you add the config
- Other projects: No Linear MCP, no bloat ✅
- Full control over which projects have Linear

**When to use:**
- You only use Linear in some projects
- You want to avoid context bloat
- You want clean separation

---

## Comparison Table

| Aspect | Global Config | Project-Specific Config |
|--------|---------------|-------------------------|
| **NPM Installation** | Global (once) | Global (once) |
| **Config Location** | `~/.claude/mcp_config.json` | `project/.claude/mcp_config.json` |
| **Available In** | All projects | Only that project |
| **Context Bloat** | Yes, in all projects | No, only where needed ✅ |
| **Setup Effort** | Once, for all projects | Once per project |
| **Control** | All or nothing | Granular per-project ✅ |
| **Recommended For You** | ❌ | ✅ |

---

## What I Recommend for You

### **Use Project-Specific Configuration**

**Why:**
- ✅ No context bloat in projects without Linear
- ✅ Clean separation
- ✅ Full control
- ✅ Other projects remain unaffected

**How:**

1. **Install the npm package globally** (just once, for all projects):
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

2. **Configure ONLY in projects that need Linear:**
   ```bash
   # Navigate to your project
   cd C:\path\to\project-with-linear

   # Copy config to PROJECT .claude directory
   cp LINEAR-MCP-CONFIG.json .claude\mcp_config.json
   ```

3. **Other projects:**
   - Don't add `mcp_config.json`
   - Linear MCP won't be available
   - No context bloat ✅

---

## Updated Setup Instructions

### **For Project-Specific Setup (Recommended):**

**Use this script:** `setup-linear-project.bat`

```bash
# 1. Navigate to your project (where you already copied .claude folder)
cd C:\path\to\your-project

# 2. Copy the workflow package (if not already done)
cp -r C:\PolarCode\MultiAgentSetup\claude-workflow-windows\.claude .

# 3. Run the project-specific setup
C:\PolarCode\MultiAgentSetup\claude-workflow-windows\setup-linear-project.bat

# 4. Restart VS Code

# 5. Test (only works in THIS project)
mcp__linear__list_teams
```

**Result:**
- Linear MCP works in this project ✅
- Other projects: No Linear, no bloat ✅

---

## What About Other Projects?

### **Scenario 1: Project with Linear**
```
my-project-with-linear/
├── .claude/
│   ├── mcp_config.json          ← Linear MCP enabled
│   ├── agents/
│   └── commands/
└── src/
```
**Result:** `/linear` command works, Linear tools available

### **Scenario 2: Project without Linear**
```
my-other-project/
├── .claude/                      ← No mcp_config.json
│   ├── agents/
│   └── commands/
└── src/
```
**Result:** No Linear tools, no context bloat ✅

### **Scenario 3: Project without .claude**
```
my-basic-project/
└── src/
```
**Result:** No Claude workflow system at all

---

## Technical Details

### **How Claude Code Loads MCP Servers:**

1. Opens a project
2. Checks for MCP configuration:
   - First: `project/.claude/mcp_config.json` (project-specific)
   - Then: `~/.claude/mcp_config.json` (global)
3. Only starts MCP servers listed in the config
4. Adds MCP tools to context **only if configured**

**If no config:** No MCP servers loaded, no context bloat ✅

---

## Context Impact

### **Without Linear MCP:**
```
Available tools:
- Read
- Write
- Bash
- Grep
- Glob
- Task
- etc.
```
**Token usage:** ~2,000 tokens for tool descriptions

### **With Linear MCP:**
```
Available tools:
- Read, Write, Bash, etc. (same as above)
- mcp__linear__list_teams
- mcp__linear__list_projects
- mcp__linear__create_issue
- mcp__linear__update_issue
- ... (15+ Linear tools)
```
**Token usage:** ~3,500 tokens for tool descriptions

**Difference:** ~1,500 tokens per conversation

**Impact:**
- **With project-specific config:** Only pay tokens in projects using Linear
- **With global config:** Pay extra tokens in ALL projects

---

## Migration Path

### **If You Already Used Global Config:**

You can migrate to project-specific:

1. **Remove global config:**
   ```bash
   rm C:\Users\sagas\.claude\mcp_config.json
   ```

2. **Add to specific projects:**
   ```bash
   cd C:\path\to\project-needing-linear
   cp LINEAR-MCP-CONFIG.json .claude\mcp_config.json
   ```

3. **Restart VS Code**

---

## Recommendations Summary

✅ **DO:**
- Install npm package globally: `npm install -g @modelcontextprotocol/server-linear`
- Use project-specific config: `project/.claude/mcp_config.json`
- Use `setup-linear-project.bat` script

❌ **DON'T:**
- Use global config (`~/.claude/mcp_config.json`) unless you use Linear everywhere
- Commit `mcp_config.json` to git (protected by .gitignore)

---

## Scripts Available

| Script | Purpose | Config Location |
|--------|---------|-----------------|
| `setup-linear.bat` | Global setup | `~/.claude/mcp_config.json` |
| `setup-linear-project.bat` | **Project-specific** ✅ | `project/.claude/mcp_config.json` |

**For you:** Use `setup-linear-project.bat`

---

## Quick Setup (Project-Specific)

```bash
# 1. Navigate to your project
cd C:\path\to\your-project

# 2. Copy .claude folder (if not already done)
cp -r C:\PolarCode\MultiAgentSetup\claude-workflow-windows\.claude .

# 3. Run project-specific setup
cd C:\PolarCode\MultiAgentSetup\claude-workflow-windows
setup-linear-project.bat

# 4. Go back to your project
cd C:\path\to\your-project

# 5. Restart VS Code

# 6. Test (only works in this project!)
mcp__linear__list_teams
```

---

## Summary

**Your concern about context bloat is valid!**

**Solution:** Use **project-specific configuration**
- npm package installed globally (just the code)
- Config file in project `.claude/mcp_config.json` (enables it)
- Other projects unaffected ✅
- No context bloat ✅

**Use:** `setup-linear-project.bat` instead of `setup-linear.bat`
