---
description: Create or update the project context from docs and.or codebase analysis, ensuring AI agents have consistent implementation standards
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

You are updating the project context at `/memory/project-context.md`. This file is a TEMPLATE containing example placeholders in the form `[EXAMPLE: description]`. Your job is to (a) analyze the codebase and documentation, (b) derive concrete values, (c) replace examples with actual project data, and (d) preserve any manual customizations.

Follow this execution flow:

1. **Load the existing project context** at `/memory/project-context.md`.
   - Identify every placeholder of the form `[EXAMPLE: ...]`.
   - **IMPORTANT**: Preserve any sections that have been manually customized (no longer contain `[EXAMPLE:` markers).

2. **Collect and derive values** by:
   - Read `/memory/constitution.md` if available.
   - Read spec.md, plan.md, data-model.md from `specs/` folder if available.
   - Analyze the codebase thoroughly to extract accurate information if available.
   - **Last Updated**: Use today's date in ISO format (YYYY-MM-DD).

3. **Draft the updated project context**:
   - Replace every `[EXAMPLE: ...]` placeholder with concrete project data.
   - Remove the `[EXAMPLE:` prefix and replace the description with actual values.
   - If information is genuinely unavailable, replace with `[TO BE DETERMINED: reason]` and note in report.
   - Preserve all manual content (sections without `[EXAMPLE:` markers).
   - Ensure each section is specific to this project, not generic examples.
   - Keep the same heading hierarchy and structure as the template.

4. **Validation before writing**:
   - No remaining unexplained `[EXAMPLE:` markers (except those intentionally deferred as `[TO BE DETERMINED:`).
   - Project Goal is project-specific (not a generic example).
   - Tech stack with specific versions.
   - Coding conventions.
   - Architecture description and project structure.
   - Date is in ISO format YYYY-MM-DD.

5. **Write the completed context** back to `/memory/project-context.md` (overwrite).

6. **Output a final summary** to the user with:
   - Confirmation of update with file path.
   - List of sections updated (Project Goal, Tech Stack, Coding Style, Architecture, Error Handling, Other Rules).
   - Any `[TO BE DETERMINED]` items requiring manual input with explanation.
   - Reminder that this file should be reviewed and kept in sync with codebase evolution.

## Formatting & Style Requirements

- Use Markdown headings exactly as in the template (do not demote/promote levels).
- Keep structure consistent with template.
- Use concise, clear language focused on actual project specifics.
- Avoid generic or vague descriptions.
- Single blank line between sections.
- No trailing whitespace.

## Key Rules

- **NEVER invent or guess information** - if unsure, mark as `[TO BE DETERMINED: reason]`.
- **ALWAYS preserve manual customizations** - only replace sections still marked with `[EXAMPLE:]`.
- Use absolute paths for all file references in the report.
- Be thorough in analyzing the codebase to extract accurate information.
- Focus on information that helps AI agents implement tasks consistently.
- The file should be concise but complete - aim for clarity over verbosity.

## Output Format

After completing the analysis and update, provide:

```
✓ Project context updated: /absolute/path/to/memory/project-context.md

Summary of updates:
  ✓ Project Goal: [Brief summary of what was found/updated]
  ✓ Product Development Stage: [Stage identified]
  ✓ Tech Stack: [Key technologies and versions found]
  ✓ Coding Style: [Conventions detected from codebase or generated]
  ✓ Architecture: [Architecture pattern identified]
  ✓ Error & Log Handling: [Patterns found in code or generated]
  ✓ Security Guidelines: [Patterns identified]
  ✓ Environment Management: [Configuration approach]
  ⚠ Needs Manual Review: [Any sections marked TO BE DETERMINED with reasons]

Last Updated: [YYYY-MM-DD]

Next steps:
  1. Review /memory/project-context.md for accuracy
  2. Fill in any [TO BE DETERMINED] sections with project-specific information
  3. Add any project-specific rules not captured by automated analysis
  4. Keep this file updated as the project evolves
  5. This file will be automatically loaded by /implement commands
```

## Important Notes

- This command should be run BEFORE `/implement` command to ensure AI agents have proper context.
- Run this command again when:
  - Major architectural changes occur
  - Coding standards are updated
  - New frameworks or libraries are adopted
  - Project moves to a different development stage (PoC → MVP → Production)
- The project-context.md file is a living document - keep it synchronized with the actual codebase.
- This file is automatically read by `/implement` commands for consistency.

Do not create a new template; always operate on the existing `/memory/project-context.md` file.
