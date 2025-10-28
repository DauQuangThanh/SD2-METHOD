---
description: Generate or update project-context.md with essential project information for AI agent consistency.
scripts:
  sh: scripts/bash/setup-summarize.sh --json
  ps: scripts/powershell/setup-summarize.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse JSON for REPO_ROOT, PROJECT_CONTEXT, and TEMPLATE paths. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load existing context**: If PROJECT_CONTEXT exists, read it to understand what information is already filled. If it's new, read the TEMPLATE to understand the required structure.

3. **Analyze the project** to gather information for each section:
   - Read `/memory/constitution.md`.
   - Read spec.md, data-model.md, quickstart.md, research.md, or any relevant files that are available in `specs` folder to gather necessary information for each section in the template file.

4. **Generate/Update project-context.md**: Fill in the template with actual project information:
   - Replace all `[EXAMPLE: ...]` placeholders with real data from the project
   - Keep the structure from the template but customize content
   - If information is not available or unclear, mark it as `[TO BE DETERMINED]` or provide best-guess based on common patterns
   - Preserve any manual additions if updating an existing file
   - Update the "Last Updated" section at the bottom

5. **Validation**: Ensure all major sections are filled:
   - Project Goal (one or two clear sentences)
   - Tech Stack with versions
   - Coding conventions
   - Architectural description
   - Error and logging rules & patterns

6. **Report**: Output a summary:
   - Path to project-context.md
   - List of sections updated
   - Any sections that need manual review (marked as [TO BE DETERMINED]) and ask the user to provide them
   - Remind the user to review and adjust as needed

## Key Rules

- Use absolute paths for all file references
- Be thorough in analyzing the docs & codebase to extract accurate information
- Don't invent information - if unsure, mark as [TO BE DETERMINED]
- Preserve existing manual customizations when updating
- Focus on information that helps AI agents implement tasks consistently
- The file should be concise but complete - aim for clarity over verbosity

## Output Format

After completing the analysis and update, provide:

```
✓ Project context updated: /absolute/path/to/memory/project-context.md

Summary of updates:
  ✓ Project Goal: [Brief summary]
  ✓ Tech Stack: [Key technologies found]
  ✓ Coding Style: [Style guide sources]
  ✓ Architecture: [Architecture type]
  ✓ Error Handling: [Strategy identified]
  ⚠ Needs Review: [Any sections marked TO BE DETERMINED]

Next steps:
  1. Review memory/project-context.md for accuracy
  2. Fill in any [TO BE DETERMINED] sections
  3. Adjust based on project-specific requirements
  4. This file will be referenced by AI agents for consistency
```

## Important Notes

- This command should be run BEFORE the /implement command to ensure AI agents have proper context
- The project-context.md file should be updated whenever major architectural decisions change
- Keep this file in sync with the actual codebase - it's a living document
- Share this file with all team members so everyone has the same understanding
