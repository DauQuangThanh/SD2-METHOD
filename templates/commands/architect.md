---
description: Create or update the project architecture from interactive or provided inputs, ensuring all dependent templates stay in sync
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

You are updating the project architecture at `/memory/architecture.md`. This file is a TEMPLATE containing placeholder tokens in square brackets (e.g. `[PROJECT_NAME]`, `[System Name]`). Your job is to (a) collect/derive concrete values, (b) fill the template precisely, and (c) propagate any amendments across dependent artifacts.

Follow this execution flow:

1. Load the existing architecture template at `/memory/architecture.md`.
   - Identify every placeholder token of the form `[ALL_CAPS_IDENTIFIER]` or `[Descriptive Name]`.
   **IMPORTANT**: The user might require more or fewer sections/views than the template provides. Adapt the structure as needed while maintaining the formal architecture documentation style.

2. Collect/derive values for placeholders:
   - If user input (conversation) supplies a value, use it.
   - Otherwise infer from existing repo context (README, docs, prior architecture versions if embedded).
   - For governance dates: `RATIFICATION_DATE` is the original adoption date (if unknown ask or mark TODO), `LAST_AMENDED_DATE` is today if changes are made, otherwise keep previous.
   - `ARCHITECTURE_VERSION` must increment according to semantic versioning rules:
     - MAJOR: Fundamental architectural style change, removal of major components/views, incompatible structural changes.
     - MINOR: New architectural view added, new major component/decision, materially expanded section.
     - PATCH: Clarifications, wording, typo fixes, non-semantic refinements.
   - If version bump type ambiguous, propose reasoning before finalizing.

3. Draft the updated architecture content:
   - Replace every placeholder with concrete text (no bracketed tokens left except intentionally retained template slots that the project has chosen not to define yet—explicitly justify any left).
   - Preserve heading hierarchy and comments can be removed once replaced unless they still add clarifying guidance.
   - Ensure each major section is properly populated:
     - **Introduction**: Clear purpose, scope, definitions, and references
     - **Architectural Representation**: Stakeholder concerns mapped to architectural views
     - **Goals and Constraints**: Business goals, quality attributes, design constraints
     - **Architectural Views**: Detailed views (Logical, Process, Deployment, Data, etc.) with diagrams and explanations
     - **Architectural Decisions**: Key decisions with rationale and trade-offs
     - **Policies and Patterns**: System-wide policies and applied design patterns

4. Consistency propagation checklist (convert prior checklist into active validations):
   - Read `/templates/plan-template.md` and ensure any "Architecture Check" or architectural alignment rules are consistent.
   - Read `/templates/spec-template.md` for scope/requirements alignment—update if architecture adds/removes mandatory sections, quality attributes, or technical constraints.
   - Read `/templates/tasks-template.md` and ensure task categorization reflects architectural decisions (e.g., deployment strategy, component interactions, technology choices).
   - Read each command file in `/templates/commands/*.md` (including this one) to verify no outdated references remain when generic guidance is required.
   - Read any runtime guidance docs (e.g., `README.md`, `docs/quickstart.md`, or agent-specific guidance files if present). Update references to architectural components, views, or decisions that changed.

5. Produce a Sync Impact Report (prepend as an HTML comment at top of the architecture file after update):
   - Version change: old → new
   - List of modified sections (e.g., "Added Data View", "Updated Deployment View", "New architectural decision on API gateway")
   - Added views or components
   - Removed views or components
   - Templates requiring updates (✅ updated / ⚠ pending) with file paths
   - Follow-up TODOs if any placeholders intentionally deferred.

6. Validation before final output:
   - No remaining unexplained bracket tokens.
   - Version line matches report.
   - Dates ISO format YYYY-MM-DD.
   - All architectural views properly documented with stakeholder concerns addressed.
   - Decisions include clear rationale and trade-off analysis.
   - Quality attributes are measurable and testable where possible.

7. Write the completed architecture back to `/memory/architecture.md` (overwrite).

8. Output a final summary to the user with:
   - New version and bump rationale.
   - Any files flagged for manual follow-up.
   - Suggested commit message (e.g., `docs: update architecture to vX.Y.Z (deployment view + microservices decision)`).

Formatting & Style Requirements:

- Use Markdown headings exactly as in the template (do not demote/promote levels).
- Wrap long rationale lines to keep readability (<100 chars ideally) but do not hard enforce with awkward breaks.
- Keep a single blank line between sections.
- Avoid trailing whitespace.
- Maintain formal architecture documentation tone consistent with IEEE 42010 style.

If the user supplies partial updates (e.g., only deployment view revision), still perform validation and version decision steps.

If critical info missing (e.g., ratification date truly unknown, stakeholder concerns unclear), insert `TODO(<FIELD_NAME>): explanation` and include in the Sync Impact Report under deferred items.

Do not create a new template; always operate on the existing `/memory/architecture.md` file.
