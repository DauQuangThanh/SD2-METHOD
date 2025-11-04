# Command Modification Guidelines

**GitHub Spec Kit - Minimal Impact Change Guide**

**Date**: 2025-10-26
**Version**: 1.0
**Codebase**: OnSpecKit

---

## Executive Summary

GitHub Spec Kit is a toolkit for Spec-Driven Development that supports **14 AI agents/assistants**. The architecture is **config-driven** with a single source of truth, making agent modifications straightforward with minimal impact.

**Key Principle**: To adjust agents, you primarily modify one configuration dictionary and 3 support scripts (~30 lines total).

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Agent Architecture](#agent-architecture)
3. [Primary Modification Points](#primary-modification-points)
4. [Step-by-Step Modification Guide](#step-by-step-modification-guide)
5. [Critical Design Rules](#critical-design-rules)
6. [Safe vs. High-Impact Changes](#safe-vs-high-impact-changes)
7. [Testing Checklist](#testing-checklist)
8. [Common Scenarios](#common-scenarios)
9. [File Reference](#file-reference)

---

## Project Overview

### What is GitHub Spec Kit?

A toolkit that enables AI coding assistants to generate implementations from specifications using a spec-driven development approach.

### Supported Agents (14 Total)

1. Claude Code (claude)
2. Gemini Code (gemini)
3. GitHub Copilot (github)
4. Cursor (cursor)
5. Qwen (qwen)
6. opencode
7. Codex (codex)
8. Windsurf (windsurf)
9. Kilo Code (kilo)
10. Auggie (auggie)
11. Roo Code (roo)
12. CodeBuddy (codebuddy)
13. Amp (amp)
14. Amazon Q (amazonq)

### Current Architecture Pattern

```
User: specify init
    ↓
Select agent from AGENT_CONFIG
    ↓
Download agent-specific ZIP from GitHub releases
    ↓
Extract to agent folder (.claude/, .gemini/, .cursor/, etc.)
    ↓
Agent reads commands from their folder at runtime
    ↓
Context files maintained via update scripts
```

---

## Agent Architecture

### Single Source of Truth

**File**: `src/specify_cli/__init__.py`
**Lines**: 68-153
**Object**: `AGENT_CONFIG` dictionary

This dictionary contains all agent definitions with metadata:
- `name`: Display name
- `folder`: Directory name for agent-specific files
- `install_url`: Installation instructions URL
- `requires_cli`: Whether agent needs CLI installation

### Agent Configuration Structure

```python
AGENT_CONFIG = {
    "agent-key": {
        "name": "Display Name",
        "folder": ".foldername",
        "install_url": "https://...",
        "requires_cli": True/False
    },
    # ... more agents
}
```

### How Agents Work

1. **Initialization**: User runs `specify init` and selects an agent
2. **Template Download**: Agent-specific ZIP downloaded from GitHub releases
3. **Project Setup**: Command files extracted to dedicated directories
4. **Runtime Execution**: Agent reads commands from their folder
5. **Context Management**: Runtime context files are updated dynamically

---

## Primary Modification Points

### 1. Agent Configuration (REQUIRED)

**File**: `src/specify_cli/__init__.py`
**Lines**: 68-153
**Impact**: ~8 lines per agent
**Risk**: Low

**What to modify**:
- Add new agent entry to `AGENT_CONFIG`
- Update agent metadata (name, folder, URLs)
- Change agent flags (requires_cli)

**Example**:
```python
"newtool": {
    "name": "New Tool",
    "folder": ".newtool",
    "install_url": "https://newtool.ai/install",
    "requires_cli": True
},
```

### 2. Release Package Script (REQUIRED for new agents)

**File**: `.github/workflows/scripts/create-release-packages.sh`
**Lines**: 140-189 (case statement), 195 (loop list)
**Impact**: ~10 lines
**Risk**: Low

**What to modify**:
- Add case statement for new agent in template processing
- Add agent key to the release loop

**Example**:
```bash
# In the case statement (around line 150)
newtool)
  AGENT_NAME="newtool"
  COMMANDS_DIR=".newtool/commands"
  ;;

# In the loop list (around line 195)
for agent in claude gemini github cursor qwen opencode codex windsurf kilo auggie roo codebuddy amp amazonq newtool; do
```

### 3. Bash Context Update Script (REQUIRED for runtime)

**File**: `scripts/bash/update-agent-context.sh`
**Lines**: 61-74
**Impact**: ~3 lines
**Risk**: Low

**What to modify**:
- Add context file path mapping
- Add file existence check

**Example**:
```bash
"newtool")
  CONTEXT_FILE=".newtool/NEWTOOL.md"
  ;;
```

### 4. PowerShell Context Update Script (REQUIRED for runtime)

**File**: `scripts/powershell/update-agent-context.ps1`
**Lines**: 46-59 (switch), 371-384 (elseif)
**Impact**: ~5 lines
**Risk**: Low

**What to modify**:
- Add context file path in switch statement
- Add existence check in elseif block

**Example**:
```powershell
# In switch statement (line 55)
"newtool" { $contextFile = ".newtool/NEWTOOL.md" }

# In elseif block (line 379)
elseif (Test-Path ".newtool/NEWTOOL.md") {
    $agentType = "newtool"
    $contextFile = ".newtool/NEWTOOL.md"
}
```

### 5. Documentation (RECOMMENDED)

**Files**: `README.md`, `AGENTS.md`
**Impact**: ~10 lines total
**Risk**: None

**What to modify**:
- Add agent to supported agents list
- Update agent count in descriptions
- Add installation instructions if needed

---

## Step-by-Step Modification Guide

### Adding a New Agent

**Total Time**: ~15 minutes
**Files Modified**: 4-5
**Lines Changed**: ~30

#### Step 1: Update AGENT_CONFIG

1. Open `src/specify_cli/__init__.py`
2. Navigate to line 68 (AGENT_CONFIG dictionary)
3. Add new agent entry following the pattern:

```python
"newagent": {
    "name": "New Agent Name",
    "folder": ".newagent",
    "install_url": "https://installation-url.com",
    "requires_cli": True  # or False
},
```

4. **Critical**: Ensure the key matches the actual CLI tool name

#### Step 2: Update Release Script

1. Open `.github/workflows/scripts/create-release-packages.sh`
2. Add case statement around line 150:

```bash
newagent)
  AGENT_NAME="newagent"
  COMMANDS_DIR=".newagent/commands"
  ;;
```

3. Add to agent loop around line 195:

```bash
for agent in claude gemini github cursor qwen opencode codex windsurf kilo auggie roo codebuddy amp amazonq newagent; do
```

#### Step 3: Update Bash Context Script

1. Open `scripts/bash/update-agent-context.sh`
2. Add case around line 65:

```bash
"newagent")
  CONTEXT_FILE=".newagent/NEWAGENT.md"
  ;;
```

#### Step 4: Update PowerShell Context Script

1. Open `scripts/powershell/update-agent-context.ps1`
2. Add switch case around line 55:

```powershell
"newagent" { $contextFile = ".newagent/NEWAGENT.md" }
```

3. Add elseif around line 379:

```powershell
elseif (Test-Path ".newagent/NEWAGENT.md") {
    $agentType = "newagent"
    $contextFile = ".newagent/NEWAGENT.md"
}
```

#### Step 5: Update Documentation

1. Open `README.md` and `AGENTS.md`
2. Add agent to supported agents list
3. Update count (14 → 15 agents)
4. Add any specific installation notes

#### Step 6: Test

Run through the [Testing Checklist](#testing-checklist) below.

---

## Critical Design Rules

### Rule 1: CLI Tool Name Matching

**CRITICAL**: Agent dictionary keys MUST match the actual CLI tool executable name.

✅ **Correct**:
```python
"cursor-agent": {  # If the tool is called 'cursor-agent'
    "name": "Cursor",
    "folder": ".cursor",
    ...
}
```

❌ **Wrong**:
```python
"cursor": {  # If the tool is actually called 'cursor-agent'
    "name": "Cursor",
    "folder": ".cursor",
    ...
}
```

**Why**: The system uses the dictionary key to check if the CLI tool is installed and executable.

### Rule 2: Folder Naming Convention

- Always start with a dot: `.agentname`
- Use lowercase
- Use hyphens for multi-word names: `.my-agent`
- Keep it short and descriptive

### Rule 3: Context File Naming

- Format: `AGENTNAME.md` (uppercase)
- Placed in agent folder: `.agentname/AGENTNAME.md`
- Example: `.claude/CLAUDE.md`, `.gemini/GEMINI.md`

### Rule 4: Template Processing

- Master templates in `/templates/commands/` apply to ALL agents
- Templates are processed at release time to create agent-specific versions
- Do NOT create agent-specific templates unless absolutely necessary

### Rule 5: Backward Compatibility

- Never remove agents from AGENT_CONFIG without deprecation notice
- Never change existing agent keys
- Folder structure changes require migration script

---

## Safe vs. High-Impact Changes

### Minimal Impact (Safe to Change)

These changes affect only new functionality or isolated components:

✅ **Adding new agents** to AGENT_CONFIG
✅ **Modifying agent metadata** (name, URLs, flags)
✅ **Updating command templates** in `/templates/commands/`
✅ **Changing context file formats** (CLAUDE.md, etc.)
✅ **Adding new commands** to templates
✅ **Documentation updates**

**Risk Level**: Low
**Testing Required**: Basic functionality test
**Rollback**: Easy (revert commit)

### Medium Impact (Use Caution)

These changes affect existing agent behavior:

⚠️ **Changing folder naming conventions**
⚠️ **Modifying template processing logic**
⚠️ **Updating context update scripts behavior**
⚠️ **Changing init() command flow**
⚠️ **Modifying check() command logic**

**Risk Level**: Medium
**Testing Required**: Full regression testing
**Rollback**: Moderate (may need data migration)

### High Impact (Dangerous)

These changes affect core architecture:

🚫 **Changing AGENT_CONFIG structure**
🚫 **Modifying agent initialization flow** (lines 865-1162)
🚫 **Changing release package generation**
🚫 **Altering folder structure conventions**
🚫 **Removing existing agents**

**Risk Level**: High
**Testing Required**: Comprehensive testing + beta period
**Rollback**: Difficult (breaking change)

---

## Testing Checklist

### After Adding/Modifying an Agent

Use this checklist to verify your changes:

#### 1. Configuration Testing

- [ ] Agent appears in `specify init` selection menu
- [ ] Agent metadata displays correctly (name, folder)
- [ ] Installation URL is correct and accessible
- [ ] CLI requirement flag is accurate

#### 2. Initialization Testing

- [ ] `specify init` completes without errors
- [ ] Agent folder is created (e.g., `.newagent/`)
- [ ] Command files are extracted correctly
- [ ] Context file is created (e.g., `.newagent/NEWAGENT.md`)

#### 3. Command Testing

- [ ] All commands are executable
- [ ] Commands read from correct folder
- [ ] No path resolution errors

#### 4. Context Update Testing

```bash
# Bash testing
./scripts/bash/update-agent-context.sh newagent

# PowerShell testing
.\scripts\powershell\update-agent-context.ps1 -agent newagent
```

- [ ] Context file is found
- [ ] Context updates successfully
- [ ] No script errors

#### 5. Cross-Platform Testing

- [ ] Works on macOS
- [ ] Works on Linux
- [ ] Works on Windows (PowerShell)

#### 6. Release Testing

- [ ] Release package script runs without errors
- [ ] Agent-specific ZIP file is generated
- [ ] ZIP contains all required files
- [ ] ZIP structure matches other agents

#### 7. Documentation Testing

- [ ] README lists new agent
- [ ] AGENTS.md includes agent details
- [ ] Installation instructions are accurate
- [ ] Links are valid

---

## Common Scenarios

### Scenario 1: Adding a New Agent

**Situation**: You want to add support for "SuperCoder" agent.

**Steps**:
1. Add to AGENT_CONFIG: `"supercoder": {...}`
2. Update release script: Add case for "supercoder"
3. Update context scripts: Add "supercoder" handling
4. Update documentation: Add to agent list
5. Test: Run through testing checklist

**Files Modified**: 5
**Time**: 15-20 minutes

### Scenario 2: Changing Agent Display Name

**Situation**: Rename "GitHub Copilot" to "GitHub Copilot Assistant"

**Steps**:
1. Update `name` field in AGENT_CONFIG
2. Update documentation references
3. No other changes needed

**Files Modified**: 2-3
**Time**: 5 minutes
**Risk**: Very low

### Scenario 3: Moving Agent to Different Folder

**Situation**: Change `.claude/` to `.claude-ai/`

**Steps**:
1. Update `folder` field in AGENT_CONFIG
2. Update release script case statement
3. Update both context scripts
4. Create migration script for existing users
5. Update documentation

**Files Modified**: 6+
**Time**: 30-45 minutes
**Risk**: Medium (requires migration)

### Scenario 4: Adding New Command Template

**Situation**: Add a new `/review` command for all agents

**Steps**:
1. Create master template in `/templates/commands/review.md`
2. Release script automatically processes for all agents
3. No per-agent changes needed
4. Update documentation

**Files Modified**: 2
**Time**: 20-30 minutes
**Risk**: Low

### Scenario 5: Deprecating an Agent

**Situation**: Remove support for an obsolete agent

**Steps**:
1. Add deprecation notice to documentation (1 release cycle)
2. Mark agent as deprecated in AGENT_CONFIG (add flag)
3. Show warning during `specify init`
4. After deprecation period: Remove from all locations
5. Add migration guide

**Files Modified**: 5-7
**Time**: 45-60 minutes
**Risk**: Medium (user impact)

---

## File Reference

### Primary Files

| File | Lines | Purpose | Modification Frequency |
|------|-------|---------|----------------------|
| `src/specify_cli/__init__.py` | 68-153 | Agent configuration (AGENT_CONFIG) | High |
| `src/specify_cli/__init__.py` | 865-1162 | Initialization logic (init command) | Low |
| `src/specify_cli/__init__.py` | 1163-1203 | Health check logic (check command) | Low |
| `.github/workflows/scripts/create-release-packages.sh` | 140-189, 195 | Release package generation | Medium |
| `scripts/bash/update-agent-context.sh` | 61-74 | Bash context updates | Medium |
| `scripts/powershell/update-agent-context.ps1` | 46-59, 371-384 | PowerShell context updates | Medium |

### Template Files

| Directory | Purpose | Modification Frequency |
|-----------|---------|----------------------|
| `/templates/commands/` | Master command templates (9 commands) | Medium |
| `/templates/context/` | Master context templates | Low |

### Documentation Files

| File | Purpose | Modification Frequency |
|------|---------|----------------------|
| `README.md` | Main documentation | High |
| `AGENTS.md` | Agent-specific documentation | Medium |
| `CONTRIBUTING.md` | Contribution guidelines | Low |

---

## Architecture Decision Records

### ADR-001: Config-Driven Agent System

**Status**: Accepted
**Date**: 2024-2025

**Context**: Need extensible system to support multiple AI agents.

**Decision**: Use single AGENT_CONFIG dictionary as source of truth.

**Consequences**:
- ✅ Easy to add new agents (~30 lines)
- ✅ Single place to modify agent metadata
- ✅ Consistent behavior across agents
- ⚠️ Changes to structure affect all agents

### ADR-002: Template-Based Command Generation

**Status**: Accepted
**Date**: 2024-2025

**Context**: Need to maintain commands for 14+ agents efficiently.

**Decision**: Master templates auto-generate agent-specific commands at release time.

**Consequences**:
- ✅ Single source for command logic
- ✅ Easy to add features to all agents
- ✅ Consistent command behavior
- ⚠️ Agent-specific customization requires workarounds

### ADR-003: Agent Key Naming Convention

**Status**: Accepted
**Date**: 2024-2025

**Context**: Need to identify which CLI tool is being used.

**Decision**: Agent dictionary keys must match actual CLI tool executable names.

**Consequences**:
- ✅ Direct CLI tool detection
- ✅ No additional mapping layer needed
- ⚠️ Keys may not be user-friendly (e.g., "cursor-agent" vs "cursor")

---

## Best Practices

### When Adding Agents

1. **Research first**: Verify CLI tool name, installation method, folder conventions
2. **Follow patterns**: Look at existing agents for guidance
3. **Test thoroughly**: Don't skip the testing checklist
4. **Document well**: Update all relevant documentation
5. **Consider users**: Think about migration and backward compatibility

### When Modifying Agents

1. **Minimal change**: Change only what's necessary
2. **Preserve keys**: Never change existing agent keys
3. **Version carefully**: Use semantic versioning for breaking changes
4. **Test existing**: Ensure existing agents still work
5. **Communicate**: Update changelog and migration guide

### When Deprecating Agents

1. **Announce early**: Give users at least one release cycle
2. **Provide alternatives**: Suggest replacement agents
3. **Migrate gracefully**: Provide migration scripts/guides
4. **Keep data**: Don't delete user's agent-specific files automatically

---

## Troubleshooting

### Common Issues

#### Agent Not Appearing in Menu

**Cause**: Not added to AGENT_CONFIG
**Solution**: Add entry to `src/specify_cli/__init__.py:68-153`

#### Agent Folder Not Created

**Cause**: Folder name mismatch in configuration
**Solution**: Verify `folder` field in AGENT_CONFIG matches release script

#### Context File Not Found

**Cause**: Context scripts not updated
**Solution**: Add agent to both Bash and PowerShell context scripts

#### CLI Tool Not Detected

**Cause**: Agent key doesn't match actual CLI tool name
**Solution**: Change agent key to match executable name exactly

#### Release Package Missing Files

**Cause**: Release script case statement missing
**Solution**: Add agent case to `.github/workflows/scripts/create-release-packages.sh`

---

## Appendix

### Agent Configuration Template

Use this template when adding a new agent:

```python
# In src/specify_cli/__init__.py (around line 150)
"newagent": {
    "name": "New Agent Display Name",
    "folder": ".newagent",
    "install_url": "https://installation-instructions-url.com",
    "requires_cli": True  # Set to False if no CLI installation needed
},
```

### Release Script Template

```bash
# In .github/workflows/scripts/create-release-packages.sh (around line 180)
newagent)
  AGENT_NAME="newagent"
  COMMANDS_DIR=".newagent/commands"
  ;;
```

### Context Script Templates

**Bash** (`scripts/bash/update-agent-context.sh`):
```bash
"newagent")
  CONTEXT_FILE=".newagent/NEWAGENT.md"
  ;;
```

**PowerShell** (`scripts/powershell/update-agent-context.ps1`):
```powershell
# In switch statement
"newagent" { $contextFile = ".newagent/NEWAGENT.md" }

# In elseif block
elseif (Test-Path ".newagent/NEWAGENT.md") {
    $agentType = "newagent"
    $contextFile = ".newagent/NEWAGENT.md"
}
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-10-26 | Initial guidelines document |

---

## Contact & Support

For questions about modifying agents:
1. Review this guide thoroughly
2. Check existing agent implementations for examples
3. Test changes in isolated environment first
4. Consult with team before making breaking changes

---

**End of Guidelines**
