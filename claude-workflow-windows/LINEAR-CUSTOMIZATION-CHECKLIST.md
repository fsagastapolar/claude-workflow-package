# Linear Customization Checklist

Use this checklist when customizing `.claude\commands\linear.md` for your Linear workspace.

## Prerequisites Completed

- [ ] Linear MCP server installed: `npm install -g @modelcontextprotocol/server-linear`
- [ ] Linear API key obtained from https://linear.app/settings/api
- [ ] Claude Code MCP configured with Linear server and API key
- [ ] Can successfully run `mcp__linear__list_teams` in Claude Code

---

## Step 1: Gather All IDs

### Team ID
Run in Claude Code:
```
mcp__linear__list_teams
```
Copy your team UUID: `____________________________________`

### Project IDs (if using)
Run in Claude Code:
```
mcp__linear__list_projects
```
Copy your default project UUID: `____________________________________`

### Workflow State IDs
Run in Claude Code:
```
mcp__linear__list_workflow_states
```
Copy UUIDs for each state you use:

- Backlog: `____________________________________`
- Todo: `____________________________________`
- In Progress: `____________________________________`
- In Review: `____________________________________`
- Done: `____________________________________`
- Canceled: `____________________________________`
- Custom State 1: `____________________________________`
- Custom State 2: `____________________________________`

### Label IDs
Run in Claude Code:
```
mcp__linear__list_labels
```
Copy UUIDs for labels you use:

- bug: `____________________________________`
- feature: `____________________________________`
- enhancement: `____________________________________`
- frontend: `____________________________________`
- backend: `____________________________________`
- docs: `____________________________________`
- Custom Label 1: `____________________________________`
- Custom Label 2: `____________________________________`

### User IDs
Run in Claude Code:
```
mcp__linear__list_users
```
Copy UUIDs for team members:

- Your name: `____________________________________`
- Teammate 1: `____________________________________`
- Teammate 2: `____________________________________`
- Teammate 3: `____________________________________`

---

## Step 2: Update linear.md

Open `.claude\commands\linear.md` in your editor.

### Update Line ~59: GitHub URLs
Find:
```markdown
### URL Mapping for Documents (CUSTOMIZE THIS)
When referencing documentation, always provide GitHub links using the `links` parameter:
- `docs/...` → `https://github.com/YOUR_ORG/YOUR_REPO/blob/main/docs/...`
```

Replace:
- [ ] `YOUR_ORG` with your GitHub organization
- [ ] `YOUR_REPO` with your repository name

### Update Lines ~40-46: Workflow Description
Find:
```markdown
Example workflow (customize based on your Linear workspace):

1. **Backlog** → Tickets waiting to be prioritized
2. **Todo** → Ready to be worked on
3. **In Progress** → Active development
4. **In Review** → PR submitted for review
5. **Done** → Completed
```

- [ ] Update to match YOUR actual workflow
- [ ] Add any custom states
- [ ] Update descriptions to match your process

### Update Line ~362: Team ID
Find:
```markdown
### Your Team
- **Team ID**: `YOUR_TEAM_ID_HERE`
```

- [ ] Replace `YOUR_TEAM_ID_HERE` with the UUID from Step 1

### Update Lines ~365-368: Label IDs
Find:
```markdown
### Your Labels (customize based on your project)
- **bug**: `YOUR_BUG_LABEL_ID`
- **feature**: `YOUR_FEATURE_LABEL_ID`
- **enhancement**: `YOUR_ENHANCEMENT_LABEL_ID`
```

- [ ] Replace `YOUR_BUG_LABEL_ID` with the UUID from Step 1
- [ ] Replace `YOUR_FEATURE_LABEL_ID` with the UUID from Step 1
- [ ] Replace `YOUR_ENHANCEMENT_LABEL_ID` with the UUID from Step 1
- [ ] Add any additional labels your team uses

### Update Lines ~373-378: Workflow State IDs
Find:
```markdown
- **Backlog**: `YOUR_BACKLOG_STATE_ID` (type: backlog)
- **Todo**: `YOUR_TODO_STATE_ID` (type: unstarted)
- **In Progress**: `YOUR_IN_PROGRESS_STATE_ID` (type: started)
- **In Review**: `YOUR_IN_REVIEW_STATE_ID` (type: started)
- **Done**: `YOUR_DONE_STATE_ID` (type: completed)
- **Canceled**: `YOUR_CANCELED_STATE_ID` (type: canceled)
```

- [ ] Replace each state ID with the UUID from Step 1
- [ ] Verify state types match (backlog, unstarted, started, completed, canceled)
- [ ] Add any custom workflow states your team uses

### Update Lines ~383-385: User IDs
Find:
```markdown
### Your Linear User IDs
- your_name: YOUR_USER_ID_HERE
- teammate1: TEAMMATE1_ID_HERE
- teammate2: TEAMMATE2_ID_HERE
```

- [ ] Replace `your_name` with your actual name
- [ ] Replace `YOUR_USER_ID_HERE` with your UUID from Step 1
- [ ] Add all teammates with their UUIDs
- [ ] Remove example teammates you don't have

### Update Lines ~294-309: Status Progression Logic
Find:
```markdown
2. **Suggest next status:**
   - Triage → Spec Needed (lacks detail/problem statement)
   ...
```

- [ ] Update to match your workflow states
- [ ] Update progression logic
- [ ] Remove states you don't use
- [ ] Add custom state transitions

---

## Step 3: Verify Changes

### Check All Placeholders Replaced
Search for these in linear.md - none should exist:

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

### Check Format
- [ ] All UUIDs are 36 characters (8-4-4-4-12 format)
- [ ] All UUIDs are lowercase
- [ ] All UUIDs are wrapped in backticks
- [ ] Workflow description matches your process

---

## Step 4: Test Integration

### Test Basic Connection
In Claude Code:
```
/linear
```

Expected response:
```
I can help you with Linear tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

- [ ] Command responds correctly
- [ ] No error about MCP tools

### Test Ticket Creation
```
/linear
Select: Create a new ticket
Provide: "Test ticket - verifying Linear integration works"
```

- [ ] Ticket created successfully
- [ ] Ticket appears in your Linear workspace
- [ ] Ticket has correct default project (if set)
- [ ] Ticket has correct default status

### Test Ticket Search
```
/linear
Select: Search for tickets
Search: "test"
```

- [ ] Search returns results
- [ ] Results include the test ticket you just created
- [ ] Results show correct status and project

### Test Ticket Update
```
/linear
Select: Update ticket status
Ticket: [the test ticket]
New status: In Progress
```

- [ ] Status updated successfully
- [ ] Status change visible in Linear workspace

---

## Step 5: Cleanup

After successful testing:

- [ ] Delete test ticket from Linear
- [ ] Save customized linear.md
- [ ] Commit `.claude/commands/linear.md` to git
- [ ] Document your customizations in project README

---

## Optional: Advanced Customization

### Custom Labels for Auto-Assignment
Edit line ~73-77 to customize automatic label assignment:

```markdown
### Automatic Label Assignment (CUSTOMIZE THIS)
Automatically apply labels based on the ticket content:
- Customize these based on your project's components/areas
```

Add rules like:
```markdown
- **frontend**: For tickets mentioning UI, components, or frontend/
- **backend**: For tickets mentioning API, database, or backend/
- **infrastructure**: For tickets mentioning deployment, CI/CD, or infrastructure/
```

- [ ] Added custom auto-labeling rules (optional)

### Custom Default Project
Edit line ~64-65 to set your default project:

```markdown
### Default Values (CUSTOMIZE THESE)
- **Status**: Always create new tickets in "Triage" status (update the state ID below)
- **Project**: For new tickets, ask the user which project or use your default project
  - To find your project ID, use: `mcp__linear__list_projects`
```

If you have a default project, add:
```markdown
- **Project**: For new tickets, default to "PROJECT_NAME" (ID: project-uuid-here)
```

- [ ] Set default project (optional)

### Custom Workflow Names
If your workflow uses different names (e.g., "Doing" instead of "In Progress"):

1. Find all references to state names in linear.md
2. Replace with your actual state names
3. Update the status progression logic

- [ ] Updated workflow state names to match yours (optional)

---

## Troubleshooting

### Issue: "MCP tools not found"
**Solution:**
1. Verify MCP server installed: `npm list -g @modelcontextprotocol/server-linear`
2. Check Claude Code MCP configuration
3. Verify API key is correct
4. Restart Claude Code

### Issue: "Invalid team ID"
**Solution:**
1. Re-run `mcp__linear__list_teams`
2. Copy the exact UUID (including dashes)
3. Ensure it's wrapped in backticks
4. Ensure it's lowercase

### Issue: "State not found"
**Solution:**
1. Re-run `mcp__linear__list_workflow_states`
2. Verify you copied the state ID, not the state name
3. Check spelling in linear.md

### Issue: Tickets created with wrong status
**Solution:**
1. Check the default "Triage" state ID is correct
2. Verify the state ID in line ~373 matches your workspace
3. Update the status progression logic

---

## Success Criteria

After completing this checklist:

✅ All placeholder IDs replaced with real UUIDs
✅ Workflow description matches your process
✅ Can invoke `/linear` successfully
✅ Can create a test ticket
✅ Can search for tickets
✅ Can update ticket status
✅ Test ticket deleted
✅ Changes committed to git

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

**Customization Complete!** ✅

Your Linear integration is now fully configured for your workspace!
