# Change Request Workflow During Feature Development

**Handling Mid-Development Changes with Spec Kit**

**Date**: 2025-11-04
**Version**: 1.1
**Context**: GitHub Spec Kit (OnSpecKit)

---

## Executive Summary

**Scenario**: You're actively coding a feature when a change request comes in that affects the current feature.

**Key Question**: Should you accept the change now or defer it to later?

**Decision Framework**: This guide provides structured workflows for assessing, accepting, or deferring change requests while minimizing disruption and maintaining quality.

---

## Table of Contents

1. [Initial Assessment: Accept or Defer?](#initial-assessment-accept-or-defer)
2. [Change Impact Analysis](#change-impact-analysis)
3. [Workflow: Minor Changes (Accept)](#workflow-minor-changes-accept)
4. [Workflow: Major Changes (Defer or Accept)](#workflow-major-changes-defer-or-accept)
5. [Workflow: Scope Changes (Usually Defer)](#workflow-scope-changes-usually-defer)
6. [Handling Partially Completed Work](#handling-partially-completed-work)
7. [Communication Patterns](#communication-patterns)
8. [Real-World Scenarios](#real-world-scenarios)
9. [Best Practices](#best-practices)
10. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)

---

## Initial Assessment: Accept or Defer?

### Decision Tree

```
┌─────────────────────────────────────────────────────────────────────────┐
│               CHANGE REQUEST DECISION TREE                              │
└─────────────────────────────────────────────────────────────────────────┘

Change Request Received
        │
        ▼
   Is it a bug fix?
        ├─ YES → ACCEPT IMMEDIATELY (security/critical)
        │        DEFER TO NEXT SPRINT (minor)
        │
        └─ NO → Continue assessment
                │
                ▼
   Does it change core requirements?
        ├─ YES → Does it invalidate existing work?
        │        ├─ YES (>50% rework) → DEFER TO NEXT SPRINT
        │        └─ NO (<50% rework) → Continue assessment
        │
        └─ NO → Continue assessment
                │
                ▼
   What is current implementation progress?
        ├─ 0-25% complete → LIKELY ACCEPT (low sunk cost)
        ├─ 25-75% complete → ASSESS CAREFULLY (moderate sunk cost)
        └─ 75-100% complete → LIKELY DEFER (high sunk cost)
                │
                ▼
   What is the urgency?
        ├─ CRITICAL (blocks production) → ACCEPT
        ├─ HIGH (business opportunity) → ASSESS IMPACT
        ├─ MEDIUM (nice to have) → LIKELY DEFER
        └─ LOW (future enhancement) → DEFER TO BACKLOG
                │
                ▼
   What is the change size?
        ├─ MINOR (1-2 tasks, <4 hours) → ACCEPT IF <75% done
        ├─ MODERATE (3-8 tasks, 1-2 days) → ASSESS IMPACT
        └─ MAJOR (>8 tasks, >2 days) → LIKELY DEFER
                │
                ▼
   DECISION: Accept or Defer?
```

---

### Quick Assessment Matrix

| Current Progress | Change Size | Urgency | Recommendation |
|-----------------|-------------|---------|----------------|
| 0-25% | Minor | Any | **ACCEPT** - Low sunk cost |
| 0-25% | Moderate | Critical/High | **ACCEPT** - Early enough to pivot |
| 0-25% | Major | Critical | **ACCEPT** - Reassess entire approach |
| 0-25% | Major | Medium/Low | **DEFER** - Too much scope change |
| 25-75% | Minor | Any | **ACCEPT** - Manageable addition |
| 25-75% | Moderate | Critical | **ACCEPT** - Business need outweighs cost |
| 25-75% | Moderate | Medium/Low | **DEFER** - Significant disruption |
| 25-75% | Major | Any | **DEFER** - Too disruptive |
| 75-100% | Minor | Critical | **ACCEPT** - Quick addition |
| 75-100% | Minor | Medium/Low | **DEFER** - Deliver current, then add |
| 75-100% | Moderate/Major | Any | **DEFER** - Too close to completion |

---

## Change Impact Analysis

### Step 1: Run Change Impact Assessment

**Before making any decisions, assess the impact using Spec Kit artifacts.**

```bash
# 1. Review current state
cd specs/[feature-number]-[feature-name]/

# 2. Read current artifacts
cat spec.md           # Current requirements
cat plan.md           # Current technical design
cat tasks.md          # Current tasks and progress

# 3. Identify what changes
# - Which requirements in spec.md are affected?
# - Which sections of plan.md need updates?
# - Which tasks in tasks.md are affected?
# - How many tasks are [X] complete vs [ ] incomplete?
```

### Step 2: Calculate Impact Metrics

**Use this template to assess impact:**

```
CHANGE REQUEST IMPACT ASSESSMENT
════════════════════════════════════════════════════════════════════════

Feature: [Feature Name]
Change Request: [Brief description]
Requested By: [Stakeholder name]
Date: [Today's date]

CURRENT STATE:
├─ Overall Progress: [XX%] complete
├─ Tasks Complete: [N] of [M] tasks ([XX%])
├─ Development Time Invested: [N] hours
└─ Estimated Time to Completion: [N] hours remaining

CHANGE ANALYSIS:
├─ Change Type:
│  ├─ [ ] Requirement Addition (new functionality)
│  ├─ [ ] Requirement Modification (change existing)
│  ├─ [ ] Requirement Removal (delete functionality)
│  ├─ [ ] Non-Functional Change (performance, security, etc.)
│  └─ [ ] Bug Fix (fix defect in current implementation)
│
├─ Affected Artifacts:
│  ├─ spec.md: [List affected sections]
│  ├─ plan.md: [List affected sections]
│  ├─ data-model.md: [List affected entities/fields]
│  ├─ contracts/: [List affected APIs]
│  └─ tasks.md: [List affected tasks]
│
├─ Impact on Completed Work:
│  ├─ Tasks to Redo: [N] tasks ([X] hours)
│  ├─ Tasks to Modify: [N] tasks ([X] hours)
│  └─ Completed Tasks Unaffected: [N] tasks
│
├─ New Work Required:
│  ├─ New Tasks: [N] tasks ([X] hours)
│  ├─ Modified Tasks: [N] tasks ([X] hours additional)
│  └─ Total Additional Effort: [X] hours
│
└─ Total Rework Cost:
   ├─ Wasted Effort: [X] hours (completed tasks to redo)
   ├─ Additional Effort: [X] hours (new/modified tasks)
   └─ TOTAL CHANGE COST: [X] hours

CHANGE SIZE CLASSIFICATION:
└─ [ ] MINOR: <4 hours, 1-2 tasks affected
   [ ] MODERATE: 4-16 hours, 3-8 tasks affected
   [ ] MAJOR: >16 hours, >8 tasks affected, or >50% rework

RISK ASSESSMENT:
├─ Technical Risk: [Low/Medium/High]
│  └─ Reason: [Why?]
├─ Schedule Risk: [Low/Medium/High]
│  └─ Impact: [N days delay]
└─ Quality Risk: [Low/Medium/High]
   └─ Reason: [Why?]

RECOMMENDATION:
└─ [ ] ACCEPT NOW (implement immediately)
   [ ] DEFER TO NEXT SPRINT (complete current first)
   [ ] DEFER TO BACKLOG (not urgent enough)
   [ ] REJECT (out of scope / not valuable)

RATIONALE:
[Explain your recommendation]

────────────────────────────────────────────────────────────────────────
```

---

## Workflow: Minor Changes (Accept)

**Definition**: Minor change = <4 hours, 1-2 tasks, no major rework

### Scenario

```
CURRENT STATE:
├─ Feature: User Registration
├─ Progress: 60% complete (12 of 20 tasks done)
├─ Phase: Implementing email validation

CHANGE REQUEST:
└─ "Add phone number field to registration form"
   └─ Impact: 1 new field, 2 tasks (3 hours)
```

### Workflow: Accept and Integrate

```
┌─────────────────────────────────────────────────────────────────────────┐
│           MINOR CHANGE WORKFLOW (Accept Immediately)                    │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: Document the Change (10 minutes)
├─ Update spec.md with new requirement
│
├─ Command: Use /speckit.clarify for quick clarification
│  └─ Input: "Add phone number field to registration - optional or required?"
│  └─ Output: spec.md updated with clarified requirement
│
└─ Result: spec.md now includes phone number requirement

────────────────────────────────────────────────────────────────────────────

STEP 2: Assess Technical Impact (10 minutes)
├─ Review plan.md - does data model need update?
│  └─ YES: Add phone_number field to User entity in data-model.md
│
├─ Review contracts/ - do APIs need update?
│  └─ YES: Update POST /register endpoint in contracts/auth-api.yaml
│
└─ Manual Update (minor changes don't need full /speckit.plan re-run)
   └─ Edit data-model.md directly
   └─ Edit contracts/auth-api.yaml directly

────────────────────────────────────────────────────────────────────────────

STEP 3: Update Task List (10 minutes)
├─ Review tasks.md current state
│  └─ Current: T012 [X] Create registration form (complete)
│  └─ Current: T013 [ ] Implement email validation (in progress)
│
├─ Command: Re-run /speckit.tasks OR manually add tasks
│  └─ OPTION A (Automated): /speckit.tasks
│     └─ Regenerates entire tasks.md with new tasks inserted
│     └─ Preserves [X] status of completed tasks
│
│  └─ OPTION B (Manual - faster for minor changes):
│     └─ Manually insert new tasks after related existing tasks:
│
│        - [X] T012 Create registration form UI
│        - [ ] T012a [P] Add phone number field to registration form
│        - [ ] T012b [P] Add phone validation logic
│        - [ ] T013 Implement email validation (in progress)
│
└─ Result: tasks.md updated with 2 new tasks

────────────────────────────────────────────────────────────────────────────

STEP 4: Quick Validation (5 minutes)
├─ Command: /speckit.analyze (quick consistency check)
│  └─ Validates: Updated spec matches plan and tasks
│  └─ Result: Should show 0 critical issues if changes are consistent
│
└─ IF ISSUES FOUND: Fix them before continuing implementation

────────────────────────────────────────────────────────────────────────────

STEP 5: Continue Implementation (3 hours)
├─ Current task: Finish T013 (email validation)
├─ Next tasks: T012a, T012b (phone number feature)
└─ Continue: Rest of implementation as planned

────────────────────────────────────────────────────────────────────────────

STEP 6: Update Stakeholders (5 minutes)
└─ Notify: Product Owner, Scrum Master, Team
   └─ Message: "Change accepted: Added phone number field"
   └─ Impact: "+3 hours, delivery delayed by 0.5 days"
   └─ Status: "Currently 55% complete (was 60%), new estimate: +0.5 days"

────────────────────────────────────────────────────────────────────────────

TOTAL TIME OVERHEAD: ~40 minutes for change integration
TOTAL ADDITIONAL IMPLEMENTATION: 3 hours
NET IMPACT: 3.5 hours total change cost
```

---

## Workflow: Major Changes (Defer or Accept)

**Definition**: Major change = >16 hours, >8 tasks, or >50% rework

### Scenario

```
CURRENT STATE:
├─ Feature: User Registration
├─ Progress: 60% complete (12 of 20 tasks done)
├─ Phase: Implementing email validation

CHANGE REQUEST:
└─ "Change authentication from email/password to OAuth2 only"
   └─ Impact: Completely different approach, ~70% rework
```

### Decision: Defer vs. Accept

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      MAJOR CHANGE DECISION PROCESS                      │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: Impact Assessment (30 minutes)
├─ Current investment: 60% × 80 hours = 48 hours invested
├─ Completed work affected: 10 of 12 tasks need rework (38 hours wasted)
├─ New work required: OAuth2 implementation (24 hours)
├─ Total change cost: 38 + 24 = 62 hours
├─ Original remaining: 40% × 80 = 32 hours
└─ Comparison: Change costs 62 hours vs. 32 hours to finish current + add later

────────────────────────────────────────────────────────────────────────────

STEP 2: Business Justification Analysis
├─ Why is this change requested?
│  ├─ Security concern? (HIGH priority)
│  ├─ Customer demand? (MEDIUM priority)
│  ├─ Competitive pressure? (MEDIUM priority)
│  └─ Nice to have? (LOW priority)
│
├─ What is the cost of deferring?
│  ├─ Blocks other features? (HIGH cost to defer)
│  ├─ Affects launch timeline? (MEDIUM cost to defer)
│  └─ Just an optimization? (LOW cost to defer)
│
└─ DECISION MATRIX:
   ├─ HIGH priority + HIGH cost to defer → ACCEPT (painful but necessary)
   ├─ HIGH priority + LOW cost to defer → ACCEPT or DEFER (evaluate deeper)
   ├─ MEDIUM priority + HIGH cost → ACCEPT carefully
   ├─ MEDIUM priority + LOW cost → DEFER (finish current, then implement)
   └─ LOW priority → DEFER TO BACKLOG

────────────────────────────────────────────────────────────────────────────

STEP 3: Make Decision with Stakeholders (30 minutes)
└─ Meeting with: Product Owner, Tech Lead, Engineering Manager

   Present Impact Assessment showing:
   ├─ Current progress: 60% complete, 48 hours invested
   ├─ Change impact: 38 hours wasted, 62 hours total cost
   ├─ Option A (Accept): ~62 hours to implement change + 10 remaining = 72 hours
   ├─ Option B (Defer): 32 hours to finish current + 50 hours for OAuth2 later = 82 hours
   └─ Recommendation: [Accept or Defer with rationale]

   Decision: [ ] Accept Now  [ ] Defer to Next Sprint  [ ] Defer to Backlog
```

---

### If Decision = ACCEPT (Major Change)

```
┌─────────────────────────────────────────────────────────────────────────┐
│              MAJOR CHANGE WORKFLOW (Accept - Full Re-Plan)              │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: Stop Current Implementation (Immediate)
├─ Action: Commit current work to feature branch
│  └─ git add .
│  └─ git commit -m "WIP: Save progress before OAuth2 pivot"
│  └─ git push origin feature/001-user-registration
│
├─ Action: Mark current progress in tasks.md
│  └─ Add comment: "<!-- PIVOTING TO OAUTH2 - 2025-10-26 -->"
│
└─ Action: Notify team of stop
   └─ "Pausing current implementation for change assessment"

────────────────────────────────────────────────────────────────────────────

STEP 2: Re-Specify (2-4 hours)
├─ Command: Update spec.md with change
│  └─ OPTION A: Manually edit spec.md
│     └─ Update authentication sections
│     └─ Remove email/password requirements
│     └─ Add OAuth2 requirements
│
│  └─ OPTION B: Re-run /speckit.specify (if major rewrite needed)
│     └─ Creates new spec.md or updates existing
│
├─ Command: /speckit.clarify
│  └─ Resolve OAuth2 provider questions (Google, GitHub, Microsoft?)
│  └─ Resolve session management questions
│  └─ Result: spec.md fully updated with OAuth2 requirements
│
└─ Command: Update architecture if needed
   └─ If architecture.md exists: Update manually or use /speckit.architect
   └─ If major architectural shift: /speckit.architect (to document new approach after spec update)

────────────────────────────────────────────────────────────────────────────

STEP 3: Update Quality Checklists (1-2 hours)
├─ Review existing checklists for relevance
│  └─ security.md: Update authentication security checks
│  └─ testing.md: Update test scenarios for OAuth2
│
└─ Command: /speckit.checklist (if major new concerns)
   └─ Generate OAuth2-specific security checklist
   └─ Result: Updated/new checklists

────────────────────────────────────────────────────────────────────────────

STEP 4: Re-Plan Technical Approach (2-4 hours)
├─ Command: /speckit.plan
│  └─ Input: Updated spec.md with OAuth2 requirements
│  └─ Output: Updated plan.md
│     ├─ New research.md: OAuth2 library selection
│     ├─ Updated data-model.md: User, OAuthToken entities
│     ├─ Updated contracts/: New OAuth2 endpoints
│     └─ Updated plan.md: OAuth2 integration architecture
│
└─ Review: Solution Architect validates new approach

────────────────────────────────────────────────────────────────────────────

STEP 5: Update Project Context (15 minutes)
├─ Command: /speckit.contextualize
│  └─ Updates project-context.md with new approach
│  └─ Ensures AI agents understand OAuth2 patterns and standards
│
└─ Output: Updated project-context.md

────────────────────────────────────────────────────────────────────────────

STEP 6: Regenerate Tasks (1-2 hours)
├─ Command: /speckit.tasks
│  └─ Input: Updated spec.md, plan.md, data-model.md, project-context.md
│  └─ Output: NEW tasks.md
│     └─ Completely new task breakdown for OAuth2 approach
│
├─ Review New Tasks:
│  └─ Identify reusable work from old tasks
│     ├─ Example: T012 "Create registration form UI" might be reusable
│     └─ Mark salvageable tasks with comment: "<!-- REUSE FROM OLD -->"
│
└─ Estimate:
   └─ New total: [N] tasks, [X] hours
   └─ Reusable: [N] tasks, [X] hours saved

────────────────────────────────────────────────────────────────────────────

STEP 7: Validate Consistency (30 minutes)
├─ Command: /speckit.analyze
│  └─ Validates: New spec, plan, and tasks are consistent
│  └─ Must show: 0 critical issues before proceeding
│
└─ IF CRITICAL ISSUES FOUND:
   └─ Fix issues (update spec/plan/tasks)
   └─ Re-run /speckit.analyze until clean

────────────────────────────────────────────────────────────────────────────

STEP 8: Salvage Reusable Work (2-4 hours)
├─ Review old feature branch:
│  └─ git diff main...feature/001-user-registration
│
├─ Identify reusable code:
│  ├─ UI components (forms, buttons) - likely reusable
│  ├─ Database schema (User table) - might need modification
│  ├─ API structure - likely needs complete rewrite
│  └─ Tests - some reusable, many need rewrite
│
├─ Create new branch:
│  └─ git checkout -b feature/001-user-registration-oauth2
│
└─ Cherry-pick or port reusable work:
   └─ Copy/refactor reusable components
   └─ Update to match new architecture

────────────────────────────────────────────────────────────────────────────

STEP 9: Restart Implementation (N hours)
├─ Command: /speckit.implement (with new tasks.md)
│  └─ Start fresh with OAuth2 implementation
│  └─ Leverage salvaged work where applicable
│
└─ Track progress: Mark tasks complete in new tasks.md

────────────────────────────────────────────────────────────────────────────

STEP 10: Update Stakeholders (30 minutes)
└─ Communication:
   ├─ Email/Slack to: Product Owner, Team, Scrum Master
   ├─ Subject: "Feature 001 - Major Change Accepted: Email/Password → OAuth2"
   ├─ Content:
   │  ├─ Change summary: What changed and why
   │  ├─ Impact: Original 80 hours → New estimate 72 hours
   │  ├─ Timeline: Original delivery [date] → New delivery [date]
   │  ├─ Salvaged work: 10 hours saved from original effort
   │  └─ Next steps: Restarting implementation with new approach
   │
   └─ Update project tracking:
      ├─ Jira: Update story estimate
      ├─ Sprint: May need to move to next sprint if too big
      └─ Roadmap: Update delivery date

────────────────────────────────────────────────────────────────────────────

TOTAL TIME OVERHEAD: 8-14 hours for re-planning
TOTAL IMPLEMENTATION TIME: ~62 hours (new approach)
SALVAGED TIME: ~10 hours (reusable work)
NET CHANGE COST: 60-66 hours (vs. 32 hours to finish original)
```

---

### If Decision = DEFER (Major Change)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                  MAJOR CHANGE WORKFLOW (Defer)                          │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: Document Deferred Change (30 minutes)
├─ Create new feature spec for deferred change:
│  └─ mkdir specs/099-oauth2-migration
│  └─ /speckit.specify "Migrate authentication from email/password to OAuth2"
│     └─ Output: specs/099-oauth2-migration/spec.md
│
├─ Add to product backlog:
│  └─ Jira: Create new story "OAuth2 Authentication"
│  └─ Priority: [HIGH/MEDIUM/LOW]
│  └─ Sprint: [Next sprint or later]
│
└─ Link to current feature:
   └─ Add note to current spec.md:
      "Future Enhancement: OAuth2 migration planned (see specs/099-oauth2-migration)"

────────────────────────────────────────────────────────────────────────────

STEP 2: Continue Current Implementation (unchanged)
├─ No changes to current workflow
├─ Complete current feature as originally planned
└─ Deliver on original timeline

────────────────────────────────────────────────────────────────────────────

STEP 3: Plan Deferred Change for Future Sprint
├─ During next backlog refinement:
│  └─ /speckit.clarify (OAuth2 spec)
│  └─ /speckit.plan (OAuth2 technical design)
│  └─ /speckit.tasks (OAuth2 task breakdown)
│
└─ Estimate separately:
   └─ OAuth2 migration: ~50 hours as separate feature

────────────────────────────────────────────────────────────────────────────

STEP 4: Update Stakeholders (15 minutes)
└─ Communication:
   ├─ To: Product Owner, Requester of change
   ├─ Message: "Change deferred to next sprint to avoid disruption"
   ├─ Rationale:
   │  ├─ Current feature 60% complete (48 hours invested)
   │  ├─ Change would require 62 hours (38 wasted + 24 new)
   │  ├─ More efficient to: Finish current (32h) + OAuth2 later (50h) = 82h total
   │  └─ Benefit: Earlier delivery of current feature, cleaner OAuth2 implementation
   │
   └─ Next steps: OAuth2 scheduled for Sprint [N+1]

────────────────────────────────────────────────────────────────────────────

TOTAL TIME OVERHEAD: 45 minutes (document and communicate)
CURRENT FEATURE: Delivers on time (32 hours remaining)
FUTURE FEATURE: OAuth2 (50 hours, next sprint)
```

---

## Workflow: Scope Changes (Usually Defer)

**Definition**: Scope change = Adding entirely new functionality beyond original spec

### Scenario

```
CURRENT STATE:
├─ Feature: User Registration (email/password)
├─ Progress: 60% complete
├─ Original Scope: Register, login, password reset

CHANGE REQUEST:
└─ "Add social login (Google, Facebook, GitHub)"
   └─ This is NEW functionality, not modification of existing
```

### Recommended Approach: Defer as Separate Feature

```
┌─────────────────────────────────────────────────────────────────────────┐
│              SCOPE CHANGE WORKFLOW (Defer as Separate)                  │
└─────────────────────────────────────────────────────────────────────────┘

STEP 1: Assess Scope Change (15 minutes)
├─ Question: Is this truly new functionality?
│  └─ YES: Social login is separate from email/password registration
│
├─ Question: Can it be implemented independently?
│  └─ YES: Social login can be added after email/password is complete
│
└─ RECOMMENDATION: Defer as separate feature

────────────────────────────────────────────────────────────────────────────

STEP 2: Create Separate Feature Spec (30 minutes)
├─ Command: /speckit.specify
│  └─ Input: "Add social login (Google, Facebook, GitHub) to user registration"
│  └─ Output: specs/099-social-login/spec.md (NEW FEATURE)
│
├─ Note relationship:
│  └─ In new spec.md: "Depends on: Feature 001 (User Registration)"
│  └─ In current spec.md: "Future Enhancement: Social login (see specs/099-social-login)"
│
└─ Add to backlog:
   └─ Jira: Create new story "Social Login"
   └─ Priority: After Feature 001
   └─ Sprint: [Next sprint]

────────────────────────────────────────────────────────────────────────────

STEP 3: Continue Current Feature (unchanged)
└─ No disruption to current implementation
   └─ Deliver Feature 001 on time

────────────────────────────────────────────────────────────────────────────

STEP 4: Plan Separate Feature for Future
└─ In next sprint preparation:
   ├─ /speckit.clarify (social login)
   ├─ /speckit.plan (social login)
   ├─ /speckit.tasks (social login)
   └─ Implement as independent feature

────────────────────────────────────────────────────────────────────────────

TOTAL TIME OVERHEAD: 45 minutes (create new spec, communicate)
CURRENT FEATURE: No impact, delivers on time
NEW FEATURE: Planned for next sprint (independent)
```

---

## Handling Partially Completed Work

### Scenario: Change Invalidates Some Completed Work

```
CURRENT STATE:
├─ 12 of 20 tasks complete [X]
├─ Change affects 6 of the 12 completed tasks
└─ Question: How to handle completed work that needs rework?

OPTIONS:

OPTION 1: Salvage and Refactor (if >50% reusable)
├─ Identify what's salvageable from completed work
├─ Refactor to match new requirements
└─ Mark tasks as [X] if they need minor updates, [ ] if major rework

OPTION 2: Discard and Rebuild (if <50% reusable)
├─ Mark affected tasks as [ ] (uncomplete them)
├─ Update tasks with new requirements
└─ Reimplement from scratch with new approach

OPTION 3: Hybrid (common)
├─ Some completed work salvageable (UI components, database schema)
├─ Some completed work discarded (authentication logic)
└─ Mark partially reusable tasks with comment:
   "<!-- T012: [X] UI reusable, [ ] backend needs rework -->"
```

---

### Best Practice: Track Salvaged Work

```markdown
## tasks.md Example

<!-- CHANGE REQUEST ACCEPTED: 2025-10-26 -->
<!-- Changed from email/password to OAuth2 authentication -->
<!-- Salvaging reusable work from original implementation -->

### Phase 1: Setup (Original - Complete)
- [X] T001 Create project structure (REUSABLE)
- [X] T002 Setup database connection (REUSABLE)
- [X] T003 Install dependencies (NEEDS UPDATE - add OAuth2 libraries)

### Phase 2: Authentication (REWORKED FOR OAUTH2)
- [ ] T004 ~~Implement password hashing~~ (DISCARDED - not needed for OAuth2)
- [X] T005 Create User model (REUSABLE - needs phone field added)
- [ ] T006 ~~Implement email/password authentication~~ (REPLACED with T020-T022)
- [X] T007 Create registration form UI (REUSABLE - UI structure same)

### Phase 2b: OAuth2 Implementation (NEW TASKS)
- [ ] T020 Configure OAuth2 providers (Google, GitHub, Microsoft)
- [ ] T021 Implement OAuth2 callback handlers
- [ ] T022 Implement OAuth2 session management

<!-- Original tasks T008-T019 below... -->
```

---

## Communication Patterns

### Template 1: Communicating Accepted Minor Change

```
TO: Product Owner, Team, Scrum Master
SUBJECT: Change Accepted - [Feature Name] - [Brief Change Description]

Hi team,

We've accepted a change request to the current feature:

FEATURE: [Feature Name]
CHANGE: [Brief description]

IMPACT:
├─ Tasks Added: [N] tasks
├─ Time Added: [X] hours
├─ Current Progress: [XX%] → [XX%] (adjusted for new tasks)
├─ Original Delivery: [Date]
└─ New Delivery: [Date] (+[N] days)

RATIONALE:
[Why we accepted this change now vs. deferring]

NEXT STEPS:
[What we're doing next]

STATUS:
Implementation continuing with new tasks integrated.

Thanks,
[Your Name]
```

---

### Template 2: Communicating Deferred Major Change

```
TO: Product Owner, Change Requester, Team
SUBJECT: Change Deferred - [Feature Name] - [Brief Change Description]

Hi team,

We've assessed a change request and recommend deferring to next sprint:

CURRENT FEATURE: [Feature Name]
├─ Current Progress: [XX%] complete
├─ Hours Invested: [N] hours
└─ Est. Time to Complete: [N] hours

CHANGE REQUEST: [Brief description]
├─ Change Type: [Major/Moderate/Minor]
├─ Estimated Impact: [N] hours rework + [N] hours new work = [N] total
└─ Urgency: [Critical/High/Medium/Low]

RECOMMENDATION: Defer to Next Sprint

RATIONALE:
├─ Current investment: [N] hours (sunk cost)
├─ Change would waste: [N] hours of completed work
├─ More efficient approach:
│  ├─ Option A (Accept Now): [N] total hours
│  └─ Option B (Defer): [N] hours to finish current + [N] hours for change later = [N] total
│
├─ Change urgency: [Low/Medium] - not blocking
└─ Better outcome: Clean implementation of change as separate feature

NEXT STEPS:
├─ Current feature: Continue as planned, deliver [Date]
├─ Change request: New feature spec created (specs/[N]-[name])
├─ New feature: Planned for Sprint [N+1]
└─ Estimation: [N] hours as separate feature

Please confirm this approach or let's discuss if urgent.

Thanks,
[Your Name]
```

---

### Template 3: Communicating Accepted Major Change (Pivot)

```
TO: Product Owner, Engineering Manager, Team, Stakeholders
SUBJECT: MAJOR CHANGE - [Feature Name] - Implementation Pivot

Hi team,

We've accepted a major change request that requires pivoting our approach:

CURRENT FEATURE: [Feature Name]
├─ Original Approach: [Description]
├─ Current Progress: [XX%] complete ([N] hours invested)
└─ Original Estimate: [N] hours

CHANGE REQUEST: [Description]
├─ Impact: [Major change to core approach]
└─ Urgency: [Critical/High] - [Reason]

DECISION: Accept Change (Pivot Implementation)

IMPACT ANALYSIS:
├─ Wasted Effort: [N] hours (work that must be discarded)
├─ Salvageable Work: [N] hours (work we can reuse/refactor)
├─ New Work Required: [N] hours
├─ Total New Estimate: [N] hours
└─ Timeline Impact: [N] days delay

APPROACH:
├─ STEP 1: Stop current implementation ✓
├─ STEP 2: Re-specify with new requirements (ETA: [Date])
├─ STEP 3: Re-plan technical approach (ETA: [Date])
├─ STEP 4: Regenerate tasks (ETA: [Date])
├─ STEP 5: Restart implementation (ETA: [Date])
└─ STEP 6: New delivery date (ETA: [Date])

RATIONALE:
[Why accepting this change now despite cost]

DELIVERABLES UPDATED:
├─ spec.md: Updated ✓ / In Progress / Pending
├─ plan.md: Updated ✓ / In Progress / Pending
├─ tasks.md: Updated ✓ / In Progress / Pending
├─ New Estimate: [N] hours ([+/-X] from original)
└─ New Delivery: [Date] ([+/-N] days from original)

STAKEHOLDER ACTION REQUIRED:
└─ Please confirm approval for this pivot and timeline change.

Current status: [Paused/Re-planning/Restarting]

Thanks,
[Your Name]
```

---

## Real-World Scenarios

### Scenario 1: UI Requirement Change (Minor - Accept)

```
SITUATION:
├─ Feature: Product Catalog
├─ Progress: 70% complete (coding product grid)
├─ Change: "Add filter by price range"
└─ Impact: 2 new tasks, 4 hours

WORKFLOW:

1. Quick Assessment (5 min):
   └─ Minor change, late stage, but clean addition

2. Update spec.md (5 min):
   └─ Add "Price range filter" to functional requirements

3. Update plan.md (5 min):
   └─ No architecture change needed (uses existing filtering system)

4. Add tasks manually (5 min):
   └─ T023 [P] Add price range slider to UI
   └─ T024 [P] Add price range filter to backend query

5. Continue implementation (4 hours):
   └─ Current task → New tasks → Rest of feature

OUTCOME:
├─ Overhead: 20 minutes
├─ Additional work: 4 hours
├─ Delivery delay: +0.5 days
└─ Stakeholder satisfaction: High (got requested feature)
```

---

### Scenario 2: Business Logic Change (Moderate - Defer)

```
SITUATION:
├─ Feature: E-commerce Checkout
├─ Progress: 50% complete (implementing payment processing)
├─ Change: "Add support for payment plans (installments)"
└─ Impact: 8 new tasks, 16 hours, affects tax calculation

WORKFLOW:

1. Impact Assessment (30 min):
   ├─ Moderate change
   ├─ Affects completed tax calculation logic (8 hours wasted)
   ├─ Requires new payment plan logic (16 hours)
   └─ Total cost: 24 hours (vs. 20 hours to finish current)

2. Business Discussion (30 min):
   ├─ Urgency: Medium (customer request, not critical)
   ├─ Recommendation: Defer to next sprint
   └─ Decision: DEFER

3. Create New Feature Spec (30 min):
   └─ /speckit.specify "Add payment plans (installments) to checkout"
   └─ Output: specs/048-payment-plans/spec.md

4. Continue Current Feature (unchanged):
   └─ Deliver checkout with single payments on time

5. Plan Payment Plans for Next Sprint:
   └─ Scheduled for Sprint 8 (estimated 24 hours)

OUTCOME:
├─ Current feature: Delivered on time
├─ Payment plans: Clean implementation in next sprint
├─ Total effort saved: 8 hours (avoided rework)
└─ Customer: Gets payment plans 2 weeks later (acceptable trade-off)
```

---

### Scenario 3: Security Requirement (Critical - Accept Immediately)

```
SITUATION:
├─ Feature: User Profile Management
├─ Progress: 80% complete (almost done)
├─ Change: "Security audit found vulnerability - must encrypt all PII fields"
└─ Impact: 12 tasks affected, 20 hours rework

WORKFLOW:

1. Security Assessment (1 hour):
   ├─ Critical security issue
   ├─ Must be fixed before production
   └─ Decision: ACCEPT IMMEDIATELY (no choice)

2. Stop Implementation (immediate):
   └─ Halt current work, commit WIP

3. Re-plan Security Approach (2 hours):
   ├─ Update data-model.md: Add encryption specifications
   ├─ Update plan.md: Add encryption layer
   └─ Research.md: Select encryption library (AES-256)

4. Update Tasks (1 hour):
   ├─ /speckit.tasks (regenerate)
   └─ Mark affected tasks as [ ] (uncomplete)

5. Implement Encryption (20 hours):
   └─ Rework data layer with encryption

6. Extended Testing (8 hours):
   └─ Additional security testing required

OUTCOME:
├─ Feature delayed: +1 week
├─ Rework cost: 20 hours
├─ Security: Vulnerability fixed ✓
└─ Result: Correct decision (security > schedule)
```

---

### Scenario 4: Feature Creep (Low Priority - Reject)

```
SITUATION:
├─ Feature: Admin Dashboard
├─ Progress: 40% complete
├─ Change: "Add real-time chat support to dashboard"
└─ Impact: Entirely new feature, 40+ hours

WORKFLOW:

1. Scope Assessment (15 min):
   ├─ This is feature creep, not a change request
   ├─ Unrelated to current feature (admin dashboard)
   └─ Should be separate feature entirely

2. Discussion with Product Owner (15 min):
   ├─ Clarify: Is chat support required for admin dashboard?
   └─ Answer: No, nice-to-have for future

3. Decision: REJECT (or defer to backlog)
   └─ Not in scope of current feature

4. Create Backlog Item (15 min):
   └─ /speckit.specify "Add real-time chat support to platform"
   └─ Priority: P3 (Low)
   └─ Status: Backlog (not scheduled)

5. Continue Current Feature (unchanged):
   └─ No impact to current work

OUTCOME:
├─ Current feature: No disruption
├─ Chat feature: Properly scoped as separate initiative
├─ Product Owner: Understands scope boundaries
└─ Backlog: Organized with separate priorities
```

---

## Best Practices

### 1. Always Assess Before Accepting

```
❌ DON'T:
└─ Immediately start coding the change without assessment

✓ DO:
├─ Spend 15-30 minutes on impact assessment
├─ Calculate rework cost vs. defer cost
├─ Make informed decision with stakeholders
└─ Document rationale
```

---

### 2. Use Spec Kit Artifacts as Single Source of Truth

```
❌ DON'T:
└─ Accept verbal change requests without updating spec.md

✓ DO:
├─ Always update spec.md first
├─ Use /speckit.clarify to document clarifications
├─ Re-run /speckit.analyze after changes
└─ Keep artifacts in sync
```

---

### 3. Communicate Impact Clearly

```
❌ DON'T:
└─ "Sure, I can add that" (without understanding impact)

✓ DO:
├─ "Let me assess the impact first"
├─ Provide concrete numbers: hours, tasks affected, delivery delay
├─ Present options: accept now vs. defer
└─ Get explicit approval for timeline changes
```

---

### 4. Preserve Completed Work When Possible

```
❌ DON'T:
└─ Discard all completed work when change comes

✓ DO:
├─ Identify salvageable work (UI, tests, infrastructure)
├─ Refactor vs. rebuild decision
├─ Mark salvageable tasks clearly in tasks.md
└─ Maximize reuse to reduce waste
```

---

### 5. Make Defer the Default for Non-Critical Changes

```
❌ DON'T:
└─ Accept every change request to be "helpful"

✓ DO:
├─ Default to defer unless:
│  ├─ Security/critical issue
│  ├─ Blocks other work
│  └─ Very early in implementation (<25% done)
├─ Finish current feature cleanly
└─ Implement change as separate feature
```

---

### 6. Use Feature Flags for Experimental Changes

```
✓ DO (when appropriate):
├─ Implement change behind feature flag
├─ Deploy both versions
├─ Test in production with subset of users
└─ Flip flag or roll back based on results

This avoids rework if change needs to be reverted.
```

---

### 7. Track Change Request Metrics

```
✓ DO:
├─ Track: Number of change requests per feature
├─ Track: Percentage of changes accepted vs. deferred
├─ Track: Average rework cost per accepted change
├─ Track: Reasons for changes (scope creep, unclear requirements, etc.)
└─ Use in retrospectives to improve specification quality
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: "Yes to Everything"

```
❌ PROBLEM:
├─ Accepting every change request without assessment
├─ Never saying no or defer
└─ Constant rework, never finishing anything

✓ SOLUTION:
├─ Use decision tree to evaluate objectively
├─ Make defer the default for non-critical changes
└─ Get stakeholder buy-in for defer decisions
```

---

### Anti-Pattern 2: "Scope Creep Acceptance"

```
❌ PROBLEM:
├─ Feature grows from 20 tasks to 50 tasks
├─ "Just one more thing" repeated 10 times
└─ Feature never delivers

✓ SOLUTION:
├─ Clearly define scope in spec.md
├─ Distinguish changes vs. new features
├─ Move new features to separate specs
└─ Deliver incrementally (MVP first, enhancements later)
```

---

### Anti-Pattern 3: "Undocumented Verbal Changes"

```
❌ PROBLEM:
├─ "Can you change X to Y?" → "Sure!" → implements without updating spec
├─ No trace of what changed or why
└─ Confusion later about what was agreed

✓ SOLUTION:
├─ ALWAYS update spec.md for changes
├─ Use /speckit.clarify to document decisions
├─ Keep artifacts in sync with implementation
└─ Spec.md is single source of truth
```

---

### Anti-Pattern 4: "Change Without Re-Analysis"

```
❌ PROBLEM:
├─ Accept change, update spec.md, continue coding
├─ Skip /speckit.analyze
└─ Miss conflicts and inconsistencies

✓ SOLUTION:
├─ After any spec/plan/tasks change
├─ ALWAYS re-run /speckit.analyze
├─ Fix critical issues before continuing
└─ Analysis is your safety net
```

---

### Anti-Pattern 5: "Sunk Cost Fallacy"

```
❌ PROBLEM:
├─ "We've invested 40 hours, we can't change now!"
├─ Proceed with wrong approach
└─ Deliver wrong solution

✓ SOLUTION:
├─ Sunk costs are sunk (can't recover them)
├─ Make decision based on forward-looking costs
├─ Sometimes pivoting late is still right decision
└─ Compare: cost to pivot vs. cost of wrong solution in production
```

---

## Summary: Decision Framework

```
┌─────────────────────────────────────────────────────────────────────────┐
│                   CHANGE REQUEST DECISION SUMMARY                       │
└─────────────────────────────────────────────────────────────────────────┘

WHEN TO ACCEPT IMMEDIATELY:
├─ Security/critical issues (no choice)
├─ Minor changes (<4 hours, early in development)
├─ Bug fixes (fix defects in current implementation)
└─ Blocking changes (prevents other work)

WHEN TO DEFER:
├─ Major changes (>16 hours) when >50% complete
├─ Scope additions (new features, not modifications)
├─ Non-urgent changes (nice-to-have)
└─ Changes that invalidate >50% of completed work

WHEN TO REJECT:
├─ Feature creep (unrelated new features)
├─ Low-priority changes with high rework cost
└─ Changes that contradict constitution principles

WORKFLOW FOR ACCEPTED CHANGES:
1. Update spec.md (/speckit.clarify if needed)
2. Update plan.md (manually or /speckit.plan)
3. Update tasks.md (manually or /speckit.tasks)
4. Run /speckit.analyze (validate consistency)
5. Continue/restart implementation
6. Communicate impact to stakeholders

WORKFLOW FOR DEFERRED CHANGES:
1. Create new feature spec (/speckit.specify)
2. Add to backlog (future sprint)
3. Continue current feature unchanged
4. Plan deferred feature separately
5. Communicate decision and rationale

KEY METRICS TO TRACK:
├─ Change request rate per feature
├─ Accept vs. defer ratio
├─ Average rework cost
└─ Time to specification improvement
```

---

**Version**: 1.0
**Last Updated**: 2025-10-26
**Framework**: GitHub Spec Kit (OnSpecKit)
