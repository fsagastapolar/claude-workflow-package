# Thoughts Directory Structure

This directory provides a structured way to organize project documentation, tickets, plans, and research.

## Directory Structure

```
thoughts/
├── shared/          # Team-wide shared documentation
│   ├── tickets/     # Ticket research and analysis
│   ├── plans/       # Implementation plans
│   ├── research/    # Research documents
│   ├── prs/         # PR descriptions
│   ├── handoffs/    # Work handoff documents
│   └── pr_description.md  # PR template
├── personal/        # Your personal workspace
│   └── tickets/     # Personal ticket notes
└── global/          # Organization-wide documentation
```

## Usage

### For Planning Workflows
Plans created by `/create_plan` are stored in `shared/plans/` with the format:
```
YYYY-MM-DD-TICKET-ID-brief-description.md
```

### For Ticket Research
Ticket analysis and notes go in:
- `shared/tickets/` - Team-visible ticket research
- `personal/tickets/` - Your private ticket notes

### For PR Descriptions
The `/describe_pr` command uses `shared/pr_description.md` as a template.

Generated PR descriptions are stored in `shared/prs/` as:
```
{pr_number}_description.md
```

### For Handoffs
Work handoff documents created by `/create_handoff` go in `shared/handoffs/TICKET-ID/`

## Setting Up (Optional)

You can initialize this as a git repository to track your team's documentation:

```bash
cd thoughts
git init
git add .
git commit -m "Initial thoughts structure"
```

## Integration with HumanLayer Commands

If using the full HumanLayer workflow system:

1. Run `humanlayer thoughts init` to set up the thoughts system
2. Run `humanlayer thoughts sync` to create searchable indexes
3. Thoughts will sync between your main repo and git worktrees

## Customization

Feel free to:
- Add your own subdirectories
- Modify the PR template
- Create personal namespaces (replace `personal/` with your name)
- Add team-specific categories
