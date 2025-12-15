# Troubleshooting Guide

This guide helps diagnose and fix common issues with the Claude Workflow package.

## Quick Diagnostics

Run these commands to check your environment:

```bash
# Check Git
git --version

# Check GitHub CLI
gh --version
gh auth status

# Check thoughts directory
dir thoughts\shared\pr_description.md

# Check Node.js (for Linear MCP)
node --version
```

## Common Issues

### Issue: "gh: command not found"

**Symptoms:**
- Commands fail with `/usr/bin/bash: line 1: gh: command not found`
- `/describe_pr`, `/ci_describe_pr`, `/describe_pr_nt` don't work

**Affected Commands:**
- `/ci_describe_pr`
- `/describe_pr`
- `/describe_pr_nt`
- `/founder_mode`
- `/local_review`
- `/oneshot`

**Solution:**
1. Re-run setup: `cd claude-workflow-windows && interactive-setup.bat`
2. Or install manually:
   ```bash
   winget install --id GitHub.cli
   gh auth login
   ```

**Verification:**
```bash
gh --version      # Should show version
gh auth status    # Should show "Logged in to github.com"
```

---

### Issue: "thoughts/shared/pr_description.md not found"

**Symptoms:**
- Commands fail with `Error: thoughts/shared/pr_description.md not found`
- `/create_plan`, `/describe_pr`, `/create_handoff` don't work

**Affected Commands:**
- `/create_plan`
- `/create_plan_generic`
- `/ci_describe_pr`
- `/describe_pr`
- `/implement_plan`
- `/iterate_plan`
- `/create_handoff`
- `/resume_handoff`
- All `/ralph_*` commands

**Solution:**
1. Re-run setup: `cd claude-workflow-windows && interactive-setup.bat`
2. Or create manually:
   ```bash
   xcopy /E /I claude-workflow-windows\thoughts-template thoughts
   ```

**Verification:**
```bash
dir thoughts\shared\pr_description.md
dir thoughts\shared\plans
dir thoughts\shared\prs
```

---

### Issue: Line ending changes in Git

**Symptoms:**
- Git shows changes to files you didn't modify
- Changes like `LF` ↔ `CRLF` conversions

**Solution:**
1. Create `.gitattributes` (automatically done by setup):
   ```
   * text=auto
   *.md text eol=lf
   *.json text eol=lf
   *.bat text eol=crlf
   ```

2. Normalize existing files:
   ```bash
   git add --renormalize .
   git commit -m "Normalize line endings"
   ```

---

### Issue: Linear MCP not working

**Symptoms:**
- `/linear` command doesn't work
- `mcp__linear__*` functions not available

**Solution:**
1. Install Node.js:
   ```bash
   winget install --id OpenJS.NodeJS.LTS
   ```

2. Install Linear MCP server:
   ```bash
   npm install -g @modelcontextprotocol/server-linear
   ```

3. Configure Linear:
   ```bash
   cd claude-workflow-windows
   setup-linear.bat
   ```

4. Get your Linear API key from: https://linear.app/settings/api

5. Restart VS Code

**Verification:**
- Open Claude Code
- Run: `mcp__linear__list_teams`
- Should return your Linear teams

---

### Issue: Setup script fails

**Symptoms:**
- `interactive-setup.bat` exits with errors
- Validation tests fail

**Diagnostic Steps:**

1. **Check permissions:**
   - Run terminal as Administrator
   - Ensure write access to project directory

2. **Check prerequisites:**
   - Git installed: `git --version`
   - Winget available: `winget --version`
   - Network connectivity for downloads

3. **Review error messages:**
   - Look for specific error codes
   - Check which step failed

4. **Manual recovery:**
   ```bash
   # Install GitHub CLI manually
   winget install --id GitHub.cli

   # Copy thoughts template
   xcopy /E /I claude-workflow-windows\thoughts-template thoughts

   # Create .gitattributes
   copy claude-workflow-windows\.gitattributes .
   ```

---

## Command Dependency Matrix

| Command | Requires `gh` | Requires `thoughts/` | Requires Linear MCP |
|---------|--------------|---------------------|-------------------|
| `/ci_describe_pr` | ✅ Yes | ✅ Yes | ❌ No |
| `/describe_pr` | ✅ Yes | ✅ Yes | ❌ No |
| `/describe_pr_nt` | ✅ Yes | ❌ No | ❌ No |
| `/create_plan` | ❌ No | ✅ Yes | ❌ No |
| `/create_plan_nt` | ❌ No | ✅ Yes | ❌ No |
| `/implement_plan` | ❌ No | ✅ Yes | ❌ No |
| `/commit` | ❌ No | ❌ No | ❌ No |
| `/ci_commit` | ❌ No | ❌ No | ❌ No |
| `/debug` | ❌ No | ❌ No | ❌ No |
| `/linear` | ❌ No | ✅ Yes | ✅ Yes |
| `/founder_mode` | ✅ Yes | ✅ Yes | ❌ No |
| `/ralph_*` | ❌ No | ✅ Yes | ✅ Yes |
| `/create_handoff` | ❌ No | ✅ Yes | ❌ No |
| `/resume_handoff` | ❌ No | ✅ Yes | ❌ No |

---

## Getting Help

### For AI Agents

When troubleshooting:
1. Read this file completely
2. Check [DEBUG-REPORT-PR-CREATION.md](DEBUG-REPORT-PR-CREATION.md) for detailed error analysis
3. Run diagnostic commands listed above
4. Report specific error messages, not just "it doesn't work"

### For Users

1. **Check existing issues:** [GitHub Issues](https://github.com/fsagastapolar/claude-workflow-package/issues)
2. **Review documentation:**
   - [GETTING-STARTED.md](claude-workflow-windows/GETTING-STARTED.md)
   - [README.md](claude-workflow-windows/README.md)
   - [COMMANDS.md](claude-workflow-windows/COMMANDS.md)
3. **Run diagnostics:** Execute commands in "Quick Diagnostics" section above
4. **Re-run setup:** Often fixes configuration issues

---

## Advanced Topics

### Cloning to New Repository

When cloning this workflow to a new repository:

1. **Run setup script:**
   ```bash
   cd claude-workflow-windows
   interactive-setup.bat
   ```

2. **Configure for your repository:**
   - Update GitHub org/repo in settings
   - Update Linear workspace IDs (if using)
   - Review and customize slash commands

3. **Validate environment:**
   - All 8 validation tests should pass
   - Run optional PR creation test

4. **Protect sensitive files:**
   - Verify `.gitignore` includes `.claude/mcp_config.json`
   - Never commit API keys
   - Use `.claude/settings.local.json` for local overrides

### Worktree Support

If using git worktrees:

1. **Thoughts directory sync:**
   - Main repo has primary `thoughts/` directory
   - Worktrees reference same directory
   - Changes sync automatically

2. **Setup in worktree:**
   - No need to re-run full setup
   - `.claude/` config is shared
   - MCP servers work across all worktrees

---

## Reference Files

- [DEBUG-REPORT-PR-CREATION.md](DEBUG-REPORT-PR-CREATION.md) - Detailed PR creation error analysis
- [interactive-setup.bat](claude-workflow-windows/interactive-setup.bat) - Main setup script
- [.claude/commands/](.claude/commands/) - Slash command definitions
- [thoughts-template/](claude-workflow-windows/thoughts-template/) - Thoughts directory structure
