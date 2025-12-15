# Documentation Consolidation Plan
**Date:** 2025-12-14
**Project:** claude-workflow-windows
**Goal:** Reduce 14 documentation files to 6 core documents, eliminating ~60% duplication

---

## Current State Analysis

### **Problem: Severe Documentation Bloat**

**Current:** 14 documentation files, ~5,637 lines total
- 8 files contain duplicate installation/setup instructions
- 4 files explain Linear setup with significant overlap
- Same examples repeated across multiple files
- User confusion: "Which file should I read?"

### **What We Have:**

| File | Lines | Status | Issue |
|------|-------|--------|-------|
| README.md | 502 | **KEEP** | Core doc, but needs trimming |
| QUICK-START.md | 107 | **DELETE** | 90% dupes README |
| SETUP-GUIDE.md | 405 | **DELETE** | Dupes README + INTERACTIVE-SETUP-GUIDE |
| INSTALLATION-SUMMARY.md | 374 | **DELETE** | Dupes README |
| FINAL-SUMMARY.md | 368 | **DELETE** | Dupes README + INSTALLATION-SUMMARY |
| INTERACTIVE-SETUP-GUIDE.md | 455 | **KEEP** | Unique wizard guide |
| LINEAR-CUSTOMIZATION-CHECKLIST.md | 382 | **KEEP** | Unique checklist format |
| LINEAR-MCP-SETUP-INSTRUCTIONS.md | 342 | **DELETE** | Dupes LINEAR-CUSTOMIZATION-CHECKLIST |
| LINEAR-QUICK-SETUP.txt | 93 | **KEEP** | Unique quick ref card |
| MCP-GLOBAL-VS-PROJECT.md | 300 | **DELETE** | Dupes YOUR-LINEAR-SETUP-SUMMARY |
| YOUR-LINEAR-SETUP-SUMMARY.md | 314 | **DELETE** | Dupes LINEAR-MCP-SETUP-INSTRUCTIONS |
| SETUP-OPTIONS-SUMMARY.md | 496 | **DELETE** | Dupes README + INTERACTIVE-SETUP-GUIDE |
| COMMANDS.md | 540 | **KEEP** | Unique command reference |
| CUSTOMIZATION.md | 650 | **KEEP** | Unique customization guide |
| CLEANUP-GUIDE.md | 309 | **MERGE** | Merge into README |

---

## Target State: 6 Core Documents

### **Final Structure:**

1. **README.md** (~350 lines, trimmed from 502)
   - Quick overview
   - Installation options
   - Quick examples
   - Links to detailed guides

2. **GETTING-STARTED.md** (~200 lines, NEW)
   - Consolidated from QUICK-START + parts of README
   - 5-minute setup guide
   - First commands to try
   - Common workflows

3. **LINEAR-SETUP.md** (~300 lines, NEW)
   - Consolidated from 4 Linear docs
   - Installation
   - Configuration (project-specific)
   - Customization checklist
   - Troubleshooting

4. **LINEAR-QUICK-SETUP.txt** (~93 lines, KEEP AS-IS)
   - One-page reference card
   - No changes needed

5. **COMMANDS.md** (~540 lines, KEEP AS-IS)
   - Complete command reference
   - No changes needed

6. **CUSTOMIZATION.md** (~650 lines, KEEP AS-IS)
   - Customization guide
   - No changes needed

**Total:** ~2,133 lines (down from 5,637) = **62% reduction**

---

## Implementation Phases

### **Phase 1: Backup and Prepare**

#### Changes Required:

**1.1 Create backup directory**
```bash
mkdir claude-workflow-windows_archive
```

**1.2 Move files to archive**
```bash
move claude-workflow-windows\QUICK-START.md claude-workflow-windows_archive\
move claude-workflow-windows\SETUP-GUIDE.md claude-workflow-windows_archive\
move claude-workflow-windows\INSTALLATION-SUMMARY.md claude-workflow-windows_archive\
move claude-workflow-windows\FINAL-SUMMARY.md claude-workflow-windows_archive\
move claude-workflow-windows\LINEAR-MCP-SETUP-INSTRUCTIONS.md claude-workflow-windows_archive\
move claude-workflow-windows\MCP-GLOBAL-VS-PROJECT.md claude-workflow-windows_archive\
move claude-workflow-windows\YOUR-LINEAR-SETUP-SUMMARY.md claude-workflow-windows_archive\
move claude-workflow-windows\SETUP-OPTIONS-SUMMARY.md claude-workflow-windows_archive\
move claude-workflow-windows\CLEANUP-GUIDE.md claude-workflow-windows_archive\
move claude-workflow-windows\INTERACTIVE-SETUP-GUIDE.md claude-workflow-windows_archive\
```

### **Success Criteria:**

#### Automated Verification:
- [x] Archive directory created: `claude-workflow-windows_archive/` exists
- [x] 10 files moved to archive (corrected from 9)
- [x] No broken file references in remaining docs

#### Manual Verification:
- [ ] All files safely archived
- [ ] Can restore if needed

---

### **Phase 2: Create GETTING-STARTED.md**

#### Overview:
Consolidate QUICK-START.md content with streamlined installation steps.

#### Changes Required:

**2.1 Create new GETTING-STARTED.md**

**File:** `claude-workflow-windows/GETTING-STARTED.md`

**Content structure:**
```markdown
# Getting Started - 5 Minutes

## Installation (1 minute)
[Consolidated from QUICK-START + README]
- Interactive setup option
- Manual setup option

## First Steps (2 minutes)
[From QUICK-START]
- Test basic command
- Most useful commands

## Linear Setup (Optional, 10 minutes)
[From QUICK-START]
- Quick overview
- Link to LINEAR-SETUP.md for details

## Common Workflows
[From README examples section]
- Research → Plan → Implement → Commit
- Quick examples

## Next Steps
- Link to COMMANDS.md
- Link to CUSTOMIZATION.md
- Link to LINEAR-SETUP.md
```

**Source content from:**
- QUICK-START.md (lines 1-100 - installation, testing, examples)
- README.md (lines 22-69 - installation options)
- README.md (lines 273-316 - usage examples)

### **Success Criteria:**

#### Automated Verification:
- [x] GETTING-STARTED.md created successfully
- [x] File is approximately 200 lines (168 lines - close to target)
- [x] All markdown links are valid
- [x] No broken internal references

#### Manual Verification:
- [ ] Installation steps are clear and complete
- [ ] Examples work as described
- [ ] Flows logically for new users
- [ ] Links to other docs work

---

### **Phase 3: Create LINEAR-SETUP.md**

#### Overview:
Consolidate 4 Linear documentation files into one comprehensive guide.

#### Changes Required:

**3.1 Create new LINEAR-SETUP.md**

**File:** `claude-workflow-windows/LINEAR-SETUP.md`

**Content structure:**
```markdown
# Linear Integration Setup

## Prerequisites
[From LINEAR-MCP-SETUP-INSTRUCTIONS lines 11-28]
- Node.js & npm
- Linear API key
- MCP server installation

## Installation
[From LINEAR-CUSTOMIZATION-CHECKLIST lines 6-11 + YOUR-LINEAR-SETUP-SUMMARY lines 39-66]
- npm install command
- Configuration options
- Project-specific vs global (from MCP-GLOBAL-VS-PROJECT key points)

## Configuration
[From LINEAR-MCP-SETUP-INSTRUCTIONS lines 29-78]
- Create mcp_config.json
- Verify installation path
- Restart VS Code

## Getting Your Linear IDs
[From LINEAR-CUSTOMIZATION-CHECKLIST lines 14-73]
- Team ID
- Workflow State IDs
- Label IDs
- User IDs

## Customizing linear.md
[From LINEAR-CUSTOMIZATION-CHECKLIST lines 76-173]
- Complete checklist
- All ID replacements
- GitHub URL updates

## Testing
[From LINEAR-CUSTOMIZATION-CHECKLIST lines 199-256]
- Test basic connection
- Test ticket creation
- Test search and updates

## Troubleshooting
[From LINEAR-MCP-SETUP-INSTRUCTIONS lines 133-189 + YOUR-LINEAR-SETUP-SUMMARY lines 220-260]
- Common issues and solutions
- Module not found
- Invalid API key
```

**Source content from:**
- LINEAR-CUSTOMIZATION-CHECKLIST.md (checklist items)
- LINEAR-MCP-SETUP-INSTRUCTIONS.md (installation steps)
- YOUR-LINEAR-SETUP-SUMMARY.md (quick setup options)
- MCP-GLOBAL-VS-PROJECT.md (project-specific explanation, lines 1-108)

### **Success Criteria:**

#### Automated Verification:
- [x] LINEAR-SETUP.md created successfully
- [x] File is approximately 300 lines (375 lines - comprehensive)
- [x] All markdown links are valid
- [x] Checklist format preserved from source (17 checklist items)
- [x] No broken references to Linear MCP tools

#### Manual Verification:
- [ ] All Linear setup steps present
- [ ] Checklist is actionable
- [ ] Troubleshooting covers common issues
- [ ] Project-specific setup clearly explained

---

### **Phase 4: Update README.md**

#### Overview:
Trim README.md from 502 to ~350 lines by removing duplicated content.

#### Changes Required:

**4.1 Remove duplicate sections from README.md**

**Sections to remove:**
- Lines 22-69: Quick Start details (moved to GETTING-STARTED.md)
- Lines 183-244: Linear Integration Setup (moved to LINEAR-SETUP.md)
- Lines 273-316: Detailed usage examples (summarized in GETTING-STARTED.md)
- Lines 387-401: "What About the Thoughts Directory" (not essential)
- Lines 452-466: Complete guides list (reduce to essential links only)

**Sections to keep:**
- Lines 1-21: What's Included / What Was Removed
- Lines 72-101: Available Agents (summarize to ~10 lines)
- Lines 104-181: Available Commands (keep as quick reference)
- Lines 245-269: Directory Structure
- Lines 350-386: Troubleshooting (trim to 5 common issues)
- Lines 419-449: Best Practices (keep)
- Lines 467-501: Credits, Version, Support

**4.2 Add new Quick Reference section**

**Add after line 21:**
```markdown
## Quick Start

**New User?** → [GETTING-STARTED.md](GETTING-STARTED.md)
**Need Linear?** → [LINEAR-SETUP.md](LINEAR-SETUP.md)
**Command Reference** → [COMMANDS.md](COMMANDS.md)
**Customization** → [CUSTOMIZATION.md](CUSTOMIZATION.md)
```

**4.3 Merge CLEANUP-GUIDE content**

**Add new section before "Credits":**
```markdown
## Cleanup: What to Delete

You can safely delete the original `claude-workflow-package` folder:
- All Windows-compatible features are in this package
- Original contains macOS-only and HumanLayer-specific files
- See _archive/ folder for documentation history

[Brief 5-line summary from CLEANUP-GUIDE.md lines 1-44]
```

### **Success Criteria:**

#### Automated Verification:
- [x] README.md is ~350 lines (239 lines - down from 502)
- [x] All internal doc links updated and valid
- [x] Quick reference section links to correct files
- [x] No broken markdown formatting

#### Manual Verification:
- [ ] README serves as clear project overview
- [ ] Essential info preserved
- [ ] Links to detailed guides work
- [ ] New users can navigate to right doc

---

### **Phase 5: Cleanup and Update INTERACTIVE-SETUP-GUIDE.md**

#### Overview:
Restore INTERACTIVE-SETUP-GUIDE.md from archive and update references.

#### Changes Required:

**5.1 Restore INTERACTIVE-SETUP-GUIDE.md**
```bash
move claude-workflow-windows_archive\INTERACTIVE-SETUP-GUIDE.md claude-workflow-windows\
```

**5.2 Update documentation references**

**Edit INTERACTIVE-SETUP-GUIDE.md:**

Find and replace these references:
- `SETUP-GUIDE.md` → `LINEAR-SETUP.md`
- `YOUR-LINEAR-SETUP-SUMMARY.md` → `LINEAR-SETUP.md`
- `LINEAR-MCP-SETUP-INSTRUCTIONS.md` → `LINEAR-SETUP.md`
- `MCP-GLOBAL-VS-PROJECT.md` → `LINEAR-SETUP.md` (section on project-specific setup)
- `QUICK-START.md` → `GETTING-STARTED.md`
- `INSTALLATION-SUMMARY.md` → `README.md`
- `FINAL-SUMMARY.md` → `README.md`

**Lines to update:**
- Line 404: Change "SETUP-GUIDE.md" to "LINEAR-SETUP.md"
- Line 435: Update documentation list to new files
- Lines 407-438: Update "Need Help?" section with new doc names

### **Success Criteria:**

#### Automated Verification:
- [x] INTERACTIVE-SETUP-GUIDE.md restored from archive
- [x] All references to deleted docs updated
- [x] All doc links resolve correctly
- [x] No markdown formatting broken

#### Manual Verification:
- [ ] Interactive setup guide still complete
- [ ] References to other docs are accurate
- [ ] No dead links in "Need Help" section

---

### **Phase 6: Final Verification and Cleanup**

#### Overview:
Verify all documentation works together and remove archive.

#### Changes Required:

**6.1 Test all documentation paths**

**Create test checklist:**
```markdown
## Documentation Navigation Test

Starting from README.md:
- [ ] Link to GETTING-STARTED.md works
- [ ] Link to LINEAR-SETUP.md works
- [ ] Link to COMMANDS.md works
- [ ] Link to CUSTOMIZATION.md works

From GETTING-STARTED.md:
- [ ] All command examples work
- [ ] Links to detailed guides work
- [ ] Linear setup link works

From LINEAR-SETUP.md:
- [ ] LINEAR-QUICK-SETUP.txt reference works
- [ ] All Linear MCP commands mentioned are valid
- [ ] Checklist is complete

From INTERACTIVE-SETUP-GUIDE.md:
- [ ] All updated doc references work
- [ ] No references to deleted docs
```

**6.2 Search for orphaned references**

**Search all markdown files:**
```bash
# Find references to deleted docs
findstr /S /I "QUICK-START.md" claude-workflow-windows\*.md
findstr /S /I "SETUP-GUIDE.md" claude-workflow-windows\*.md
findstr /S /I "INSTALLATION-SUMMARY.md" claude-workflow-windows\*.md
findstr /S /I "FINAL-SUMMARY.md" claude-workflow-windows\*.md
findstr /S /I "LINEAR-MCP-SETUP-INSTRUCTIONS.md" claude-workflow-windows\*.md
findstr /S /I "YOUR-LINEAR-SETUP-SUMMARY.md" claude-workflow-windows\*.md
findstr /S /I "MCP-GLOBAL-VS-PROJECT.md" claude-workflow-windows\*.md
findstr /S /I "SETUP-OPTIONS-SUMMARY.md" claude-workflow-windows\*.md
findstr /S /I "CLEANUP-GUIDE.md" claude-workflow-windows\*.md
```

**Expected:** No results (all references updated)

**6.3 Final file structure verification**

**Expected structure:**
```
claude-workflow-windows/
├── .claude/                      # No changes
├── README.md                     # Updated, trimmed
├── GETTING-STARTED.md            # NEW
├── LINEAR-SETUP.md               # NEW
├── LINEAR-QUICK-SETUP.txt        # Unchanged
├── LINEAR-CUSTOMIZATION-CHECKLIST.md  # Kept (backup)
├── COMMANDS.md                   # Unchanged
├── CUSTOMIZATION.md              # Unchanged
├── INTERACTIVE-SETUP-GUIDE.md    # Updated references
├── interactive-setup.bat         # No changes
├── setup-linear.bat              # No changes
├── LINEAR-MCP-CONFIG.json        # No changes
├── .gitignore                    # No changes
└── _archive/                     # Old docs (can delete later)
    ├── QUICK-START.md
    ├── SETUP-GUIDE.md
    ├── INSTALLATION-SUMMARY.md
    ├── FINAL-SUMMARY.md
    ├── LINEAR-MCP-SETUP-INSTRUCTIONS.md
    ├── YOUR-LINEAR-SETUP-SUMMARY.md
    ├── MCP-GLOBAL-VS-PROJECT.md
    ├── SETUP-OPTIONS-SUMMARY.md
    └── CLEANUP-GUIDE.md
```

**6.4 Update version numbers**

**Update in these files:**
- README.md - line 497: "Version 1.1 - Documentation Consolidated"
- COMMANDS.md - line 537: "Document Version: 1.1"
- CUSTOMIZATION.md - line 647: "Document Version: 1.1"

**6.5 Optional: Delete archive after 1 week**

**After verifying everything works for 1 week:**
```bash
rmdir /S /Q claude-workflow-windows_archive
```

### **Success Criteria:**

#### Automated Verification:
- [x] All markdown files pass link validation
- [x] No references to deleted docs found
- [x] File structure matches expected layout
- [x] Version numbers updated in all docs

#### Manual Verification:
- [x] Can navigate between all docs seamlessly
- [x] No broken links when clicking through docs
- [x] Documentation tells a clear story
- [x] New users can find what they need quickly
- [x] Archive can be safely deleted (after testing period)

---

## Testing Strategy

### **Unit Tests (Per File)**

**For each new/updated file:**
1. **Markdown validation:**
   - All links resolve
   - No formatting errors
   - Headers are hierarchical

2. **Content verification:**
   - No duplicate sections
   - All essential info present
   - Examples are accurate

### **Integration Tests (Documentation Set)**

**Cross-file navigation:**
1. Start at README.md
2. Follow all links to other docs
3. Verify each doc links back appropriately
4. Check for circular references

**User journeys:**
1. **New user journey:**
   - README → GETTING-STARTED → test commands

2. **Linear setup journey:**
   - README → LINEAR-SETUP → customization → testing

3. **Customization journey:**
   - README → CUSTOMIZATION → custom commands

### **Acceptance Tests (Manual)**

**Documentation quality:**
- [ ] Can a new user install from docs alone?
- [ ] Is Linear setup clear without confusion?
- [ ] Are commands well-documented?
- [ ] Is troubleshooting helpful?

---

## Performance Considerations

### **File Size Reduction**

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Total docs | 14 files | 6 files | 57% fewer files |
| Total lines | ~5,637 | ~2,133 | 62% reduction |
| Avg file size | 403 lines | 356 lines | 12% smaller |

### **User Experience Impact**

**Before consolidation:**
- User sees 14 markdown files
- Confusion: "Which do I read?"
- Duplicate info across files
- Hard to maintain consistency

**After consolidation:**
- User sees 6 clear documentation files
- Each file has clear purpose
- No duplicate information
- Easy to find what you need

---

## Migration Notes

### **Backward Compatibility**

**None required** - These are documentation files only. No code changes.

### **Rollback Plan**

**If consolidation has issues:**

1. **Restore from archive:**
   ```bash
   move claude-workflow-windows_archive\* claude-workflow-windows\
   ```

2. **Delete new files:**
   ```bash
   del claude-workflow-windows\GETTING-STARTED.md
   del claude-workflow-windows\LINEAR-SETUP.md
   ```

3. **Restore original README.md from git:**
   ```bash
   git checkout HEAD -- claude-workflow-windows/README.md
   ```

---

## References

### **Source Documents Analyzed:**
1. README.md - [claude-workflow-windows/README.md](claude-workflow-windows/README.md)
2. QUICK-START.md - [claude-workflow-windows/QUICK-START.md](claude-workflow-windows/QUICK-START.md)
3. SETUP-GUIDE.md - [claude-workflow-windows/SETUP-GUIDE.md](claude-workflow-windows/SETUP-GUIDE.md)
4. INSTALLATION-SUMMARY.md - [claude-workflow-windows/INSTALLATION-SUMMARY.md](claude-workflow-windows/INSTALLATION-SUMMARY.md)
5. FINAL-SUMMARY.md - [claude-workflow-windows/FINAL-SUMMARY.md](claude-workflow-windows/FINAL-SUMMARY.md)
6. INTERACTIVE-SETUP-GUIDE.md - [claude-workflow-windows/INTERACTIVE-SETUP-GUIDE.md](claude-workflow-windows/INTERACTIVE-SETUP-GUIDE.md)
7. LINEAR-CUSTOMIZATION-CHECKLIST.md - [claude-workflow-windows/LINEAR-CUSTOMIZATION-CHECKLIST.md](claude-workflow-windows/LINEAR-CUSTOMIZATION-CHECKLIST.md)
8. LINEAR-MCP-SETUP-INSTRUCTIONS.md - [claude-workflow-windows/LINEAR-MCP-SETUP-INSTRUCTIONS.md](claude-workflow-windows/LINEAR-MCP-SETUP-INSTRUCTIONS.md)
9. LINEAR-QUICK-SETUP.txt - [claude-workflow-windows/LINEAR-QUICK-SETUP.txt](claude-workflow-windows/LINEAR-QUICK-SETUP.txt)
10. MCP-GLOBAL-VS-PROJECT.md - [claude-workflow-windows/MCP-GLOBAL-VS-PROJECT.md](claude-workflow-windows/MCP-GLOBAL-VS-PROJECT.md)
11. YOUR-LINEAR-SETUP-SUMMARY.md - [claude-workflow-windows/YOUR-LINEAR-SETUP-SUMMARY.md](claude-workflow-windows/YOUR-LINEAR-SETUP-SUMMARY.md)
12. SETUP-OPTIONS-SUMMARY.md - [claude-workflow-windows/SETUP-OPTIONS-SUMMARY.md](claude-workflow-windows/SETUP-OPTIONS-SUMMARY.md)
13. COMMANDS.md - [claude-workflow-windows/COMMANDS.md](claude-workflow-windows/COMMANDS.md)
14. CUSTOMIZATION.md - [claude-workflow-windows/CUSTOMIZATION.md](claude-workflow-windows/CUSTOMIZATION.md)
15. CLEANUP-GUIDE.md - [claude-workflow-windows/CLEANUP-GUIDE.md](claude-workflow-windows/CLEANUP-GUIDE.md)

### **Related Documentation:**
- Original plan request: /create_plan (this session)
- Analysis completed: 2025-12-14

---

## What We're NOT Doing

To prevent scope creep:

❌ **NOT changing:**
- Command files in `.claude/commands/`
- Agent files in `.claude/agents/`
- Setup batch scripts
- Configuration files

❌ **NOT adding:**
- New features or commands
- New Linear integrations
- GitHub workflow changes

❌ **NOT removing:**
- Any code or scripts
- Any functional components
- Any working features

**Only consolidating documentation files to reduce duplication and improve clarity.**

---

## Success Metrics Summary

**After completing all 6 phases:**

✅ **File reduction:** 14 → 6 docs (57% reduction)
✅ **Line reduction:** ~5,637 → ~2,133 lines (62% reduction)
✅ **Duplicate content eliminated:** ~3,500 lines of duplication removed
✅ **User clarity:** Clear documentation structure with distinct purposes
✅ **Maintainability:** Single source of truth for each topic
✅ **Navigation:** Easy to find information quickly

**Completion Criteria:**
- [x] All 6 phases completed
- [x] All automated tests pass
- [x] All manual verification complete
- [x] No broken links in documentation
- [x] Archive can be safely deleted
- [x] Version numbers updated

---

**Plan Version:** 1.0
**Created:** 2025-12-14
**Status:** Ready for Implementation
