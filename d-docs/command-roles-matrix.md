# Command-to-Role Matrix

**GitHub Spec Kit - Who Should Use Which Commands and Why**

**Date**: 2025-11-04
**Version**: 1.1

---

## Executive Summary

GitHub Spec Kit provides **10 commands** that support different stages of spec-driven development. This document maps each command to specific roles (actors) and explains the purposes, timing, and use cases for each role.

**Key Principle**: Commands are designed to support a complete workflow from specification to implementation, with clear ownership and collaboration points.

---

## Table of Contents

1. [Command Overview](#command-overview)
2. [Role-Based Command Matrix](#role-based-command-matrix)
3. [Detailed Role Mappings](#detailed-role-mappings)
4. [Workflow Sequences](#workflow-sequences)
5. [Collaboration Patterns](#collaboration-patterns)
6. [Use Case Scenarios](#use-case-scenarios)

---

## Command Overview

### Available Commands

| Command | Purpose | Stage | Output |
|---------|---------|-------|--------|
| `/speckit.specify` | Create feature specification from natural language | 1. Specification | spec.md, requirements.md checklist |
| `/speckit.clarify` | Interactive Q&A to reduce specification ambiguity | 2. Clarification | Updated spec.md with clarifications |
| `/speckit.checklist` | Generate quality validation checklists ("unit tests for requirements") | 2-3. Quality | Domain-specific checklist (ux.md, api.md, security.md) |
| `/speckit.constitution` | Create/update project governance principles | 0. Governance | constitution.md |
| `/speckit.architect` | Create/update project architecture design document | 3. Architecture Design | architecture.md with views, decisions, and constraints |
| `/speckit.plan` | Technical planning and architecture design | 4. Design | plan.md, data-model.md, contracts/, research.md |
| `/speckit.contextualize` | Generate/update project context for AI agent consistency | 5. Pre-Implementation Setup | project-context.md with coding standards and architecture |
| `/speckit.tasks` | Generate executable task breakdown by user story | 5. Task Planning | tasks.md with dependency graph |
| `/speckit.analyze` | Cross-artifact consistency analysis | 6. Pre-Implementation Validation | Analysis report with coverage metrics |
| `/speckit.implement` | Execute implementation following task plan | 7. Implementation | Working code implementation |

### Command Flow

```
            ┌────────────────────────┐
            │ /speckit.constitution  │ (Optional, run once per project)
            └──────────┬─────────────┘
                       │
                       ▼
            ┌────────────────────────────┐
            │  /speckit.contextualize    │ (Recommended, run before /tasks)
            │ (Generate project          │ ◄─── Solution Architect, Tech Lead
            │  context for AI)           │
            └──────────┬─────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │      /speckit.specify              │ ◄─── Product Owner, Business Analyst
        │  (Feature description → spec.md)   │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │      /speckit.architect            │ ◄─── Solution Architect (Optional)
        │  (Create architecture design       │      (After requirements, before plan)
        │   document with views/decisions)   │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │      /speckit.clarify              │ ◄─── Product Owner, Developer
        │  (Q&A to reduce ambiguity)         │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │    /speckit.checklist              │ ◄─── QA Engineer, Business Analyst, Architect
        │  (Generate quality checklists)     │      (Generate domain-specific checklists)
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │       /speckit.plan                │ ◄─── Solution Architect, Tech Lead
        │  (Technical design artifacts)      │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │       /speckit.tasks               │ ◄─── Tech Lead, Scrum Master
        │  (Executable task breakdown)       │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │      /speckit.analyze              │ ◄─── QA Engineer, Tech Lead
        │  (Consistency check before coding) │
        └──────────────┬─────────────────────┘
                       │
                       ▼
        ┌────────────────────────────────────┐
        │     /speckit.implement             │ ◄─── Developer (with AI assistance)
        │  (Code generation & execution)     │
        └────────────────────────────────────┘
```

---

## Role-Based Command Matrix

### Quick Reference Table

| Role | Primary Commands | Secondary Commands | Read-Only Commands |
|------|------------------|--------------------|--------------------|
| **Product Owner** | specify, clarify | checklist (UX/business) | analyze, tasks, contextualize, architect |
| **Product Manager** | specify, clarify | checklist (business) | plan, tasks, analyze, contextualize, architect |
| **Business Analyst** | specify, clarify, checklist | - | plan, tasks, analyze, contextualize, architect |
| **Solution Architect** | plan, architect, checklist (architecture), contextualize | constitution | specify, clarify, tasks, analyze |
| **Technical Lead** | tasks, analyze, contextualize | plan, checklist (all), constitution, architect | specify, clarify |
| **Software Engineer** | implement, clarify | tasks, checklist (technical) | specify, plan, analyze, contextualize, architect |
| **QA Engineer** | checklist (testing), analyze | - | specify, plan, tasks, contextualize, architect |
| **Scrum Master** | tasks | checklist (process) | specify, plan, analyze, contextualize, architect |
| **Security Engineer** | checklist (security), analyze | constitution | specify, plan, tasks, contextualize, architect |
| **DevOps Engineer** | checklist (deployment), plan | tasks, constitution | specify, analyze, contextualize, architect |
| **Engineering Manager** | constitution, analyze, architect | contextualize | All commands (for oversight) |

---

## Detailed Role Mappings

### 1. Product Owner / Product Manager

**Primary Responsibilities**: Define what needs to be built and why

#### Commands They Should Use

##### `/speckit.specify` ⭐ PRIMARY

**Purpose**: Transform feature ideas into formal specifications

**When to use**:
- Starting a new feature
- Responding to user feedback
- Implementing business requirements
- Creating MVP specifications

**Example scenarios**:
```bash
# User request from customer
/speckit.specify Add user authentication with OAuth2

# Business requirement
/speckit.specify Implement subscription payment flow with Stripe

# Feature enhancement
/speckit.specify Add analytics dashboard for user engagement metrics
```

**Output**:
- `spec.md` with functional requirements
- `requirements.md` checklist for validation

**Why this role**: Product Owners understand business value and user needs better than anyone

---

##### `/speckit.clarify` ⭐ PRIMARY

**Purpose**: Answer clarifying questions to reduce specification ambiguity

**When to use**:
- After `/speckit.specify` generates questions
- When specs have [NEEDS CLARIFICATION] markers
- Before technical planning begins

**Example flow**:
1. Run `/speckit.specify`
2. AI asks: "Should authentication support social login?"
3. Product Owner provides: "Yes - Google, GitHub, Microsoft"
4. Spec updated with clarification

**Why this role**: Product Owners make product decisions about scope, priorities, and user experience

---

##### `/speckit.checklist` (Business Focus) - SECONDARY

**Purpose**: Validate requirements completeness from business perspective

**When to use**:
- After specification is complete
- Before handoff to engineering
- For UX and business logic validation

**Example**:
```bash
# Generate UX requirements checklist
/speckit.checklist Generate a UX checklist focusing on user flows and accessibility

# Generate business logic checklist
/speckit.checklist Create checklist for subscription business rules and edge cases
```

**Why this role**: Product Owners ensure business requirements are complete before engineering starts

---

#### Commands They Should Read (Not Execute)

- `/speckit.plan` - Understand technical approach
- `/speckit.tasks` - Review work breakdown and estimates
- `/speckit.analyze` - Verify requirements are properly addressed

---

### 2. Solution Architect / Technical Architect

**Primary Responsibilities**: Design technical solutions and system architecture

#### Commands They Should Use

##### `/speckit.plan` ⭐ PRIMARY

**Purpose**: Create technical design and architecture artifacts

**When to use**:
- After specification is clarified
- Before implementation begins
- When architectural decisions are needed

**What it does**:
1. Reads spec.md
2. Creates research.md (technical decisions)
3. Creates data-model.md (entities and relationships)
4. Creates contracts/ (API specifications)
5. Creates plan.md (technical implementation plan)
6. Updates agent context files

**Example flow**:
```bash
# After spec.md is ready
/speckit.plan

# AI researches:
# - Best practices for chosen tech stack
# - Integration patterns
# - Security considerations
# - Performance requirements

# Outputs:
# - research.md: "Use JWT for auth, Redis for sessions, PostgreSQL for data"
# - data-model.md: User, Subscription, Payment entities
# - contracts/: OpenAPI specs for all endpoints
# - plan.md: Full technical implementation plan
```

**Why this role**: Architects make technical stack and architecture decisions

---

##### `/speckit.contextualize` ⭐ PRIMARY

**Purpose**: Generate or update project context to ensure AI agent consistency

**When to use**:
- After technical design is complete (after `/speckit.plan`)
- Before task breakdown (before `/speckit.tasks`)
- When major architectural changes occur
- When coding standards evolve

**What it does**:
1. Analyzes project structure and existing artifacts
2. Extracts tech stack, versions, and dependencies
3. Identifies coding conventions and standards
4. Documents architectural patterns and structure
5. Records error handling and logging strategies
6. Creates/updates memory/project-context.md

**Example flow**:
```bash
# After completing technical design with /speckit.plan
/speckit.contextualize

# AI analyzes:
# - plan.md for tech stack decisions
# - data-model.md for data structures
# - contracts/ for API patterns
# - README.md, package.json, requirements.txt for dependencies
# - Source code for naming conventions and patterns
# - Linter configs for style guides
# - Existing architecture for patterns

# Outputs:
# - memory/project-context.md with:
#   - Project goal (one sentence mission)
#   - Tech stack & versions (Python 3.12, React 18, PostgreSQL 16)
#   - Coding style guide (snake_case, PascalCase, etc.)
#   - Architectural overview (system components, directory structure)
#   - Error & log handling strategy (HTTP codes, logging patterns)
```

**Why this role**: Architects establish and document project-wide standards after design is complete

---

##### `/speckit.architect` ⭐ PRIMARY

**Purpose**: Create or update formal architecture design document

**When to use**:
- After specification is complete (after `/speckit.specify`)
- Before technical planning (before `/speckit.plan`)
- When major architectural changes occur
- For formal architecture documentation needs

**What it does**:
1. Creates or updates memory/architecture.md
2. Documents architectural views (Logical, Process, Deployment, Data)
3. Records architectural decisions with rationale
4. Defines quality attributes and constraints
5. Establishes system-wide policies and patterns
6. Maps stakeholder concerns to architectural views

**Example flow**:
```bash
# Create architecture design document
/speckit.architect Design a microservices architecture with REST APIs. Include logical view showing service boundaries, deployment view for Kubernetes, and key decisions around API design and data persistence.

# AI creates architecture.md with:
# - Introduction (purpose, scope, stakeholder concerns)
# - Architectural views (logical, process, deployment, data)
# - Goals and constraints (business goals, quality attributes)
# - Architectural decisions (key decisions with rationale)
# - Policies and patterns (system-wide standards)
```

**Why this role**: Architects create formal architecture documentation for complex systems

---

##### `/speckit.checklist` (Architecture Focus) - SECONDARY

**Purpose**: Validate architectural quality and technical completeness

**When to use**:
- After creating technical plan
- Before task breakdown
- For architecture review

**Example**:
```bash
# Architecture validation
/speckit.checklist Generate architecture checklist covering scalability, security, and maintainability

# API design validation
/speckit.checklist Create API checklist for REST endpoint design and consistency
```

**Why this role**: Architects ensure technical design meets quality standards

---

##### `/speckit.constitution` - SECONDARY

**Purpose**: Define or update project governance principles

**When to use**:
- At project inception
- When adding new architectural principles
- When updating technical standards

**Example**:
```bash
# Create project constitution
/speckit.constitution

# AI asks for principles like:
# - Testing requirements (e.g., "80% coverage minimum")
# - Architecture constraints (e.g., "Microservices, event-driven")
# - Security standards (e.g., "OWASP Top 10 compliance")
# - Code quality gates (e.g., "No critical SonarQube issues")
```

**Why this role**: Architects define non-negotiable technical principles

---

#### Commands They Should Read

- `/speckit.specify` - Understand business requirements
- `/speckit.clarify` - See product decisions
- `/speckit.tasks` - Review implementation plan
- `/speckit.analyze` - Verify technical consistency
- `/speckit.architect` - Reference formal architecture design

---

### 3. Technical Lead / Engineering Lead

**Primary Responsibilities**: Bridge architecture and implementation, guide development team

#### Commands They Should Use

##### `/speckit.tasks` ⭐ PRIMARY

**Purpose**: Generate executable task breakdown with dependencies

**When to use**:
- After technical planning is complete
- Before sprint planning
- When estimating effort

**What it does**:
1. Reads spec.md (user stories with priorities)
2. Reads plan.md (tech stack, structure)
3. Reads data-model.md, contracts/, research.md
4. Generates tasks.md organized by user story
5. Creates dependency graph
6. Identifies parallel work opportunities

**Example output structure**:
```markdown
# Phase 1: Setup
- [ ] T001 Create project structure
- [ ] T002 [P] Install dependencies

# Phase 2: Foundational
- [ ] T003 Setup database connection
- [ ] T004 [P] Create authentication middleware

# Phase 3: User Story 1 - User Registration
- [ ] T005 [P] [US1] Create User model in src/models/user.py
- [ ] T006 [P] [US1] Create user registration endpoint in src/routes/auth.py
- [ ] T007 [US1] Implement UserService in src/services/user_service.py

# Phase 4: User Story 2 - User Login
- [ ] T008 [P] [US2] Create login endpoint
...
```

**Why this role**: Tech Leads break down work for the team and manage dependencies

---

##### `/speckit.analyze` ⭐ PRIMARY

**Purpose**: Pre-implementation quality gate - check consistency across all artifacts

**When to use**:
- After tasks.md is generated
- Before starting implementation
- As final validation before coding

**What it checks**:
- Spec/plan/tasks consistency
- Constitution compliance
- Requirement coverage (every requirement has tasks)
- Task coverage (every task maps to requirements)
- Ambiguities and conflicts
- Missing edge cases

**Example output**:
```
## Specification Analysis Report

| ID  | Category     | Severity | Location       | Summary                      | Recommendation              |
|-----|--------------|----------|----------------|------------------------------|----------------------------|
| A1  | Duplication  | HIGH     | spec.md:L120   | Two similar auth requirements| Merge into single requirement|
| C1  | Coverage     | CRITICAL | spec.md:FR-5   | No tasks for password reset  | Add tasks for FR-5         |
| I1  | Inconsistency| MEDIUM   | plan.md:L45    | Spec says REST, plan says GraphQL| Align on REST          |

**Coverage Summary:**
- Total Requirements: 15
- Total Tasks: 42
- Coverage: 93% (14/15 requirements have tasks)
- Critical Issues: 1
- Recommendation: Resolve critical issue before /speckit.implement
```

**Why this role**: Tech Leads are responsible for quality and completeness before implementation

---

##### `/speckit.contextualize` ⭐ PRIMARY

**Purpose**: Ensure project context is current before task generation and implementation

**When to use**:
- After technical design is complete (after `/speckit.plan`)
- Before task breakdown (before `/speckit.tasks`)
- When team coding standards are updated
- After significant architectural changes

**What Tech Leads ensure**:
- Project standards are documented accurately from design artifacts
- Coding conventions match actual codebase
- Error handling patterns are current
- Testing requirements are specified
- AI agents have complete context for consistent task generation and implementation

**Example use**:
```bash
# After completing technical design
/speckit.plan

# Update project context based on design
/speckit.contextualize

# Verifies project-context.md is current with:
# - Latest tech stack from plan.md
# - Coding standards from constitution.md
# - Architectural patterns from plan.md
# - API patterns from contracts/

# Then proceed with tasks
/speckit.tasks
```

**Why this role**: Tech Leads ensure team consistency and AI agent alignment after design is complete

---

##### `/speckit.plan` - SECONDARY

**Purpose**: Collaborate with architects or create plans for smaller features

**When to use**:
- For smaller features without dedicated architect
- To review/modify architectural decisions
- When architect is unavailable

**Why this role**: Tech Leads have architectural knowledge for smaller features

---

##### `/speckit.checklist` (All Types) - SECONDARY

**Purpose**: Create comprehensive quality checklists across all domains

**When to use**:
- Before code review
- As pre-implementation validation
- For team quality standards

**Example**:
```bash
# Comprehensive review checklist
/speckit.checklist Generate a comprehensive pre-implementation checklist covering architecture, testing, security, and UX

# Code review checklist
/speckit.checklist Create code review checklist for this feature
```

**Why this role**: Tech Leads ensure holistic quality across technical and functional domains

---

#### Commands They Should Read

- `/speckit.specify` - Understand requirements
- `/speckit.clarify` - See product decisions
- `/speckit.implement` - Monitor implementation progress
- `/speckit.architect` - Reference formal architecture design

---

### 4. Software Engineer / Developer

**Primary Responsibilities**: Implement features according to specifications and plans

#### Commands They Should Use

##### `/speckit.implement` ⭐ PRIMARY

**Purpose**: Execute implementation following the task plan

**When to use**:
- After all artifacts are ready (spec, plan, tasks)
- After analyze command passes
- During development sprints

**What it does**:
1. Checks checklist completion (blocks if incomplete)
2. Loads all context (spec, plan, tasks, data-model, contracts, research)
3. Creates/verifies ignore files (.gitignore, .dockerignore, etc.)
4. Executes tasks phase-by-phase
5. Respects dependencies and parallel markers
6. Marks tasks complete as they finish
7. Validates implementation against specs

**Example flow**:
```bash
# Start implementation
/speckit.implement

# AI checks checklists:
# ✓ requirements.md - Complete
# ✓ ux.md - Complete
# ✗ security.md - 3 items incomplete

# AI asks: "Security checklist incomplete. Proceed anyway?"
# Developer: "yes"

# AI executes:
# Phase 1: Setup
# - Creating project structure
# - Installing dependencies
# Phase 2: Foundational
# - Setting up database
# - Creating auth middleware
# Phase 3: User Story 1
# - Creating User model
# - Implementing registration endpoint
# ...

# Marks tasks complete: [X] in tasks.md
```

**Why this role**: Developers write the actual code

---

##### `/speckit.clarify` - SECONDARY

**Purpose**: Ask clarifying questions when requirements are unclear

**When to use**:
- During implementation when ambiguity is discovered
- Before starting complex features
- When specifications have gaps

**Example**:
```bash
# Developer finds unclear requirement during implementation
/speckit.clarify What should happen when a user tries to register with an already-used email?

# AI asks clarifying questions
# Developer or Product Owner answers
# Spec.md updated with clarification
```

**Why this role**: Developers discover ambiguities during implementation

---

##### `/speckit.tasks` - SECONDARY

**Purpose**: Re-generate or modify task breakdown

**When to use**:
- When tasks need adjustment during development
- After scope changes
- For effort estimation

**Why this role**: Developers may need to adjust tasks based on implementation realities

---

##### `/speckit.checklist` (Technical Focus) - SECONDARY

**Purpose**: Create implementation-specific checklists

**When to use**:
- Before starting complex implementations
- For self-review before code review
- For technical validation

**Example**:
```bash
# Implementation checklist
/speckit.checklist Create technical implementation checklist for error handling and logging

# Performance checklist
/speckit.checklist Generate performance checklist for database queries and caching
```

**Why this role**: Developers ensure technical quality during implementation

---

#### Commands They Should Read

- `/speckit.specify` - Understand requirements
- `/speckit.plan` - Understand architecture
- `/speckit.analyze` - See quality issues
- `/speckit.architect` - Reference formal architecture design

---

### 5. QA Engineer / Test Engineer

**Primary Responsibilities**: Ensure quality through testing and validation

#### Commands They Should Use

##### `/speckit.checklist` (Testing Focus) ⭐ PRIMARY

**Purpose**: Create comprehensive test validation checklists

**When to use**:
- After specification is complete
- Before implementation starts
- For test planning

**Important**: These are NOT test cases, but requirement quality checks

**Example**:
```bash
# Test requirements quality checklist
/speckit.checklist Generate testing requirements checklist focusing on testability, acceptance criteria, and edge cases

# Example checklist items (testing requirements quality, NOT test cases):
# ✅ "Are acceptance criteria defined for all user stories? [Completeness]"
# ✅ "Can success criteria be objectively measured? [Measurability]"
# ✅ "Are error scenarios defined for all failure modes? [Coverage]"
# ✅ "Are edge cases documented with expected behavior? [Completeness]"
```

**Why this role**: QA Engineers validate that requirements are testable before implementation

---

##### `/speckit.analyze` ⭐ PRIMARY

**Purpose**: Validate quality and completeness before implementation

**When to use**:
- After tasks are generated
- As part of quality gate
- Before test planning

**What QA looks for**:
- Every requirement has acceptance criteria
- Edge cases are specified
- Error handling is defined
- Non-functional requirements are measurable
- Test coverage gaps

**Why this role**: QA Engineers are gatekeepers for quality

---

#### Commands They Should Read

- `/speckit.specify` - Understand requirements
- `/speckit.clarify` - See requirement clarifications
- `/speckit.plan` - Understand technical approach
- `/speckit.tasks` - Review test task allocation

---

### 6. Scrum Master / Project Manager

**Primary Responsibilities**: Facilitate process, track progress, remove blockers

#### Commands They Should Use

##### `/speckit.tasks` ⭐ PRIMARY

**Purpose**: Break down work for sprint planning and tracking

**When to use**:
- During sprint planning
- For effort estimation
- To identify dependencies and blockers

**What Scrum Masters care about**:
- Task breakdown by user story
- Dependency graph (what blocks what)
- Parallel work opportunities (maximize throughput)
- Clear acceptance criteria per phase
- Incremental delivery strategy

**Example use**:
```bash
# Generate tasks for sprint planning
/speckit.tasks

# Review output:
# - "User Story 1 has 8 tasks, 5 can be parallelized"
# - "User Story 2 depends on User Story 1 (database schema)"
# - "User Story 3 is independent, can start immediately"

# Use for:
# - Sprint capacity planning
# - Developer assignment (parallel tasks to different devs)
# - Risk identification (critical path dependencies)
```

**Why this role**: Scrum Masters facilitate planning and track progress

---

##### `/speckit.checklist` (Process Focus) - SECONDARY

**Purpose**: Ensure process compliance and readiness

**When to use**:
- Before sprint starts (readiness check)
- For definition of done validation
- For release readiness

**Example**:
```bash
# Sprint readiness checklist
/speckit.checklist Generate sprint readiness checklist covering requirements clarity, team capacity, and dependency resolution

# Release readiness checklist
/speckit.checklist Create release readiness checklist for deployment, documentation, and stakeholder communication
```

**Why this role**: Scrum Masters ensure process quality

---

#### Commands They Should Read

- `/speckit.specify` - Understand feature scope
- `/speckit.plan` - Understand technical complexity
- `/speckit.analyze` - Identify risks and blockers before sprint
- `/speckit.implement` - Track implementation progress

---

### 7. Security Engineer

**Primary Responsibilities**: Ensure security requirements and compliance

#### Commands They Should Use

##### `/speckit.checklist` (Security Focus) ⭐ PRIMARY

**Purpose**: Validate security requirements quality

**When to use**:
- After specification is complete
- Before technical planning
- For security review

**Example**:
```bash
# Security requirements checklist
/speckit.checklist Generate security requirements checklist covering authentication, authorization, data protection, and threat modeling

# Example checklist items (security requirements quality):
# ✅ "Are authentication requirements specified for all protected resources? [Coverage]"
# ✅ "Are data encryption requirements defined for sensitive information? [Completeness]"
# ✅ "Is the threat model documented and requirements aligned to it? [Traceability]"
# ✅ "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
```

**Why this role**: Security Engineers ensure security is specified before implementation

---

##### `/speckit.analyze` - PRIMARY

**Purpose**: Validate security requirements coverage and compliance

**When to use**:
- Before implementation
- As security gate
- For compliance validation

**What Security Engineers look for**:
- Security requirements coverage
- Constitution compliance (security principles)
- Missing threat scenarios
- Authentication/authorization gaps

**Why this role**: Security Engineers prevent security issues through early validation

---

##### `/speckit.constitution` - SECONDARY

**Purpose**: Define or update security principles and standards

**When to use**:
- At project inception
- When adding security standards
- After security incidents

**Example principles**:
- "All APIs must require authentication"
- "Passwords must be hashed with bcrypt (cost factor ≥12)"
- "All user input must be validated and sanitized"
- "OWASP Top 10 compliance is mandatory"

**Why this role**: Security Engineers define non-negotiable security principles

---

#### Commands They Should Read

- `/speckit.specify` - Review security requirements
- `/speckit.plan` - Review security architecture
- `/speckit.tasks` - Ensure security tasks are included

---

### 8. DevOps Engineer

**Primary Responsibilities**: Infrastructure, deployment, and operational concerns

#### Commands They Should Use

##### `/speckit.checklist` (Deployment Focus) ⭐ PRIMARY

**Purpose**: Validate operational readiness requirements

**When to use**:
- During technical planning
- Before deployment
- For operational review

**Example**:
```bash
# Deployment requirements checklist
/speckit.checklist Generate deployment checklist covering infrastructure, monitoring, logging, and disaster recovery

# Example checklist items (operational requirements quality):
# ✅ "Are deployment environment requirements specified? [Completeness]"
# ✅ "Are observability requirements defined (logs, metrics, traces)? [Coverage]"
# ✅ "Are backup and recovery requirements documented? [Completeness]"
# ✅ "Are scaling requirements quantified with specific thresholds? [Clarity]"
```

**Why this role**: DevOps Engineers ensure operational concerns are specified

---

##### `/speckit.plan` - SECONDARY

**Purpose**: Review or contribute to infrastructure design

**When to use**:
- To review infrastructure requirements
- To add operational constraints
- For deployment architecture

**Why this role**: DevOps Engineers ensure plans are deployable

---

##### `/speckit.tasks` - SECONDARY

**Purpose**: Review deployment and infrastructure tasks

**When to use**:
- For deployment planning
- To ensure infrastructure tasks are included
- For effort estimation

**Why this role**: DevOps Engineers execute infrastructure tasks

---

##### `/speckit.constitution` - SECONDARY

**Purpose**: Define operational principles and standards

**When to use**:
- At project inception
- When defining SLAs/SLOs
- For operational standards

**Example principles**:
- "All services must expose health check endpoints"
- "99.9% uptime SLA for production"
- "All deployments must be zero-downtime"
- "Logs must be centralized and retained for 90 days"

**Why this role**: DevOps Engineers define operational standards

---

#### Commands They Should Read

- `/speckit.specify` - Understand operational requirements
- `/speckit.analyze` - Check for operational gaps

---

### 9. Business Analyst

**Primary Responsibilities**: Requirements gathering, validation, and documentation

#### Commands They Should Use

##### `/speckit.specify` ⭐ PRIMARY

**Purpose**: Create formal specifications from business requirements

**When to use**:
- After stakeholder interviews
- When documenting requirements
- For requirements engineering

**Why this role**: Business Analysts translate business needs into specifications

---

##### `/speckit.clarify` ⭐ PRIMARY

**Purpose**: Interactive requirements clarification

**When to use**:
- After initial specification
- To resolve ambiguities
- Before handoff to engineering

**Why this role**: Business Analysts clarify requirements with stakeholders

---

##### `/speckit.checklist` (Business/Requirements Focus) ⭐ PRIMARY

**Purpose**: Validate requirements quality

**When to use**:
- After specification is complete
- For requirements review
- Before technical planning

**Example**:
```bash
# Requirements quality checklist
/speckit.checklist Generate requirements checklist focusing on completeness, clarity, consistency, and measurability

# Business logic checklist
/speckit.checklist Create business logic checklist for edge cases and business rules
```

**Why this role**: Business Analysts ensure requirements are complete and clear

---

#### Commands They Should Read

- `/speckit.plan` - Understand technical implications
- `/speckit.tasks` - Review work breakdown
- `/speckit.analyze` - Validate requirements coverage

---

### 10. Engineering Manager

**Primary Responsibilities**: Team oversight, governance, and strategic planning

#### Commands They Should Use

##### `/speckit.constitution` ⭐ PRIMARY

**Purpose**: Define project governance and engineering principles

**When to use**:
- At project inception
- When establishing team standards
- After process retrospectives

**Example principles**:
- **Quality Gates**: "80% test coverage minimum", "No critical security vulnerabilities"
- **Architecture**: "Microservices pattern", "Event-driven communication"
- **Process**: "All changes require code review", "TDD for core business logic"
- **Documentation**: "All APIs must have OpenAPI specs", "Architecture decisions recorded as ADRs"

**Why this role**: Engineering Managers set team standards and governance

---

##### `/speckit.architect` ⭐ PRIMARY

**Purpose**: Oversee formal architecture design and governance

**When to use**:
- At project inception
- For architecture reviews
- When approving major architectural changes
- For enterprise architecture alignment

**Example principles and architecture alignment**:
- **Constitution**: Defines WHAT principles must be followed ("All services must be independently deployable")
- **Architecture**: Defines HOW the system achieves those principles (microservices with containers, event-driven communication)

**Why this role**: Engineering Managers ensure architecture aligns with organizational standards and governance

---

##### `/speckit.analyze` - SECONDARY

**Purpose**: Quality oversight and risk management

**When to use**:
- For governance validation
- As quality gate
- For risk assessment

**Why this role**: Engineering Managers ensure standards are followed

---

#### Commands They Should Read (All)

Engineering Managers should have read access to all commands for:
- Team oversight
- Process improvement
- Risk identification
- Resource planning

---

## Workflow Sequences

### Typical Feature Development Flow

```
┌─────────────────────────────────────────────────────────────────┐
│ Stage 0: Governance & Project Setup (Engineering Manager + Architect) │
└─────────────────────────────────────────────────────────────────┘
    0a. Engineering Manager: /speckit.constitution
        → Output: constitution.md with project principles

    0b. Solution Architect: /speckit.contextualize
        → Output: project-context.md with coding standards

┌─────────────────────────────────────────────────────────────────┐
│ Stage 1: Specification (Product Owner)                          │
└─────────────────────────────────────────────────────────────────┘
    1. Product Owner: /speckit.specify "Add user authentication"
       → Output: spec.md, requirements.md checklist

    2. Product Owner: /speckit.clarify
       → AI asks questions, Product Owner answers
       → Output: Updated spec.md with clarifications

    3. Product Owner: /speckit.checklist (UX focus)
       → Output: ux.md checklist

    4. Business Analyst: Reviews spec.md, runs /speckit.checklist (requirements focus)
       → Output: requirements-quality.md checklist

┌─────────────────────────────────────────────────────────────────┐
│ Stage 2: Quality Validation (Multi-Role)                        │
└─────────────────────────────────────────────────────────────────┘
    5. QA Engineer: /speckit.checklist (testing focus)
       → Output: testing.md checklist

    6. Security Engineer: /speckit.checklist (security focus)
       → Output: security.md checklist

    7. Team: Reviews and completes all checklists
       → All checklists must be complete before proceeding

┌─────────────────────────────────────────────────────────────────┐
│ Stage 3: Architecture & Technical Planning (Solution Architect) │
└─────────────────────────────────────────────────────────────────┘
    8. Solution Architect: /speckit.architect (optional, for complex systems)
       → Output: architecture.md with architectural views and decisions

    9. Solution Architect: /speckit.plan
       → Output: plan.md, data-model.md, contracts/, research.md

    10. Solution Architect: /speckit.checklist (architecture focus)
        → Output: architecture.md checklist

┌─────────────────────────────────────────────────────────────────┐
│ Stage 4: Task Planning (Tech Lead + Scrum Master)               │
└─────────────────────────────────────────────────────────────────┘
    11. Tech Lead: /speckit.tasks
        → Output: tasks.md with dependency graph

    12. Scrum Master: Reviews tasks.md for sprint planning
        → Identifies parallel work, dependencies, effort estimates

┌─────────────────────────────────────────────────────────────────┐
│ Stage 5: Pre-Implementation Validation (Tech Lead + QA)         │
└─────────────────────────────────────────────────────────────────┘
    13. Tech Lead: /speckit.analyze
        → Output: Analysis report with issues/gaps

    14. Team: Resolves critical issues found by analyze
        → May require re-running /speckit.specify or /speckit.plan

┌─────────────────────────────────────────────────────────────────┐
│ Stage 6: Implementation (Developer)                             │
└─────────────────────────────────────────────────────────────────┘
    15. Developer: /speckit.implement
        → Checks checklist completion
        → Executes tasks phase-by-phase
        → Marks tasks complete
        → Output: Working code implementation

┌─────────────────────────────────────────────────────────────────┐
│ Stage 7: Review & Deploy (Multi-Role)                           │
└─────────────────────────────────────────────────────────────────┘
    16. DevOps Engineer: Reviews deployment tasks, deploys
    17. QA Engineer: Tests against acceptance criteria
    18. Product Owner: Validates against business requirements
```

---

## Collaboration Patterns

### Pattern 1: Product Owner → Developer (Direct)

**For small features without dedicated architect**

```
Product Owner:
  /speckit.specify → /speckit.clarify → /speckit.checklist (UX)

Developer:
  /speckit.plan → /speckit.tasks → /speckit.analyze → /speckit.implement
```

---

### Pattern 2: Full Team Workflow (Complex Features)

**For large features with multiple stakeholders**

```
Product Owner:      /speckit.specify → /speckit.clarify
                           ↓
Business Analyst:   /speckit.checklist (requirements)
                           ↓
QA Engineer:        /speckit.checklist (testing)
Security Engineer:  /speckit.checklist (security)
                           ↓
Solution Architect: /speckit.plan
                           ↓
Tech Lead:          /speckit.tasks → /speckit.analyze
                           ↓
Scrum Master:       Sprint Planning (uses tasks.md)
                           ↓
Developer:          /speckit.implement
                           ↓
DevOps:             Deploy
```

---

### Pattern 3: Iterative Refinement

**When requirements evolve during development**

```
Developer discovers ambiguity:
  /speckit.clarify (with Product Owner)
     ↓
  spec.md updated
     ↓
  /speckit.tasks (regenerate affected tasks)
     ↓
  /speckit.implement (continue)
```

---

### Pattern 4: Quality-First Approach

**When quality gates are critical (regulated industries)**

```
Product Owner:      /speckit.specify
                           ↓
Multi-Role Review:  /speckit.checklist (multiple domains)
                    - UX checklist
                    - Security checklist
                    - Compliance checklist
                    - Performance checklist
                           ↓
GATE: All checklists must be 100% complete
                           ↓
Solution Architect: /speckit.plan
                           ↓
Tech Lead:          /speckit.tasks → /speckit.analyze
                           ↓
GATE: /speckit.analyze must show 0 critical issues
                           ↓
Developer:          /speckit.implement
                           ↓
GATE: All tests pass, security scan clean
                           ↓
DevOps:             Deploy
```

---

## Use Case Scenarios

### Scenario 1: New Feature - OAuth Integration

**Roles involved**: Product Owner, Solution Architect, Security Engineer, Developer

```
Day 1 - Requirements:
  Product Owner: /speckit.specify "Add OAuth2 authentication with Google, GitHub, Microsoft"
  Product Owner: /speckit.clarify (answers: session timeout, refresh token strategy)
  Product Owner: /speckit.checklist "Generate UX checklist for authentication flows"

Day 2 - Security Review:
  Security Engineer: /speckit.checklist "Generate security checklist for OAuth implementation"
  Security Engineer: Reviews spec.md, adds security requirements to checklist

Day 3 - Technical Design:
  Solution Architect: /speckit.plan
  → Creates:
    - research.md (OAuth2 libraries, session management)
    - data-model.md (User, OAuthToken, Session entities)
    - contracts/ (auth endpoints OpenAPI specs)
    - plan.md (technical approach)

Day 4 - Task Planning:
  Tech Lead: /speckit.tasks
  → Creates tasks organized by user story:
    - Setup: OAuth client configuration
    - US1: Google OAuth integration
    - US2: GitHub OAuth integration
    - US3: Microsoft OAuth integration

Day 5 - Validation:
  Tech Lead: /speckit.analyze
  → Reports: All good, 100% coverage

Day 6-10 - Implementation:
  Developer: /speckit.implement
  → Executes tasks, marks complete
```

---

### Scenario 2: Bug Fix - Payment Processing Issue

**Roles involved**: Product Owner, Developer

```
Bug Report: "Payment processing fails for amounts over $1000"

Product Owner: /speckit.specify "Fix payment processing to support transactions up to $10,000"
  → Output: spec.md with bug fix requirements

Developer: /speckit.plan (quick technical assessment)
  → Identifies: Need to update Stripe API integration

Developer: /speckit.tasks
  → Creates tasks:
    - Update Stripe API version
    - Increase transaction limit
    - Add high-value transaction tests

Developer: /speckit.implement
  → Fixes bug, tests pass
```

---

### Scenario 3: MVP Development - Analytics Dashboard

**Roles involved**: Product Owner, Solution Architect, Scrum Master, 3 Developers

```
Week 1 - Planning:
  Product Owner: /speckit.specify "Create analytics dashboard with user engagement metrics"
  Product Owner: /speckit.clarify (defines metrics, time ranges, filters)
  Solution Architect: /speckit.plan (designs data pipeline, visualization tech)

  Tech Lead: /speckit.tasks
  → Output: 45 tasks across 5 user stories
    - US1 (P1): Basic dashboard layout
    - US2 (P1): User count metrics
    - US3 (P2): Engagement metrics
    - US4 (P2): Time-based filters
    - US5 (P3): Export functionality

  Scrum Master: Sprint planning using tasks.md
  → Sprint 1: US1 + US2 (MVP - 15 tasks, 3 parallel workstreams)
    - Developer A: Frontend layout (5 tasks)
    - Developer B: Data pipeline (4 tasks, parallel)
    - Developer C: API endpoints (6 tasks, parallel)

Week 2 - Sprint 1 Implementation:
  Tech Lead: /speckit.analyze (validates US1+US2 only)
  Developers: /speckit.implement
  → Marks US1, US2 tasks complete

Week 3 - Sprint 2:
  → Sprint 2: US3 + US4 (14 tasks)
  Developers: /speckit.implement
  → Marks US3, US4 tasks complete

Week 4 - Sprint 3:
  → Sprint 3: US5 (Polish phase - 8 tasks)
  Developers: /speckit.implement
  → Full feature complete
```

---

### Scenario 4: Compliance Review - HIPAA Requirements

**Roles involved**: Product Owner, Security Engineer, Compliance Officer, Solution Architect

```
Phase 1 - Specification:
  Product Owner: /speckit.specify "Add patient health record management system"
  Product Owner: /speckit.clarify (scope, access controls, audit requirements)

Phase 2 - Multi-Domain Checklists:
  Security Engineer: /speckit.checklist "Generate HIPAA security checklist"
  → Validates:
    - Encryption requirements specified
    - Access control requirements defined
    - Audit logging requirements documented

  Compliance Officer: /speckit.checklist "Generate HIPAA compliance checklist"
  → Validates:
    - PHI handling requirements
    - Patient consent requirements
    - Data breach notification requirements

Phase 3 - Technical Design with Compliance:
  Solution Architect: /speckit.plan
  → Creates:
    - research.md (HIPAA-compliant tech stack)
    - data-model.md (Patient, HealthRecord, AuditLog)
    - contracts/ (secure API specs)

Phase 4 - Validation:
  Tech Lead: /speckit.analyze
  → Constitution Check:
    ✓ All PHI fields encrypted
    ✓ Audit logging on all access
    ✓ Role-based access control
    ✗ Missing: Data retention policy

  → Resolves issues, re-runs analyze

Phase 5 - Implementation:
  Developer: /speckit.implement
  → Implements with compliance focus
```

---

### Scenario 5: Architecture Evolution - Microservices Migration

**Roles involved**: Engineering Manager, Solution Architect, Tech Lead

```
Phase 0 - Governance:
  Engineering Manager: /speckit.constitution
  → Defines principles:
    - "All services must be independently deployable"
    - "Services communicate via events (async)"
    - "Each service has its own database"
    - "OpenAPI specs for all service contracts"

Phase 1 - First Service:
  Product Owner: /speckit.specify "Extract user authentication into separate service"
  Solution Architect: /speckit.plan
  → research.md documents:
    - Service boundaries
    - Communication patterns
    - Data migration strategy

  Tech Lead: /speckit.analyze
  → Constitution Check:
    ✓ Independent deployment planned
    ✓ Event-based communication designed
    ✓ Separate database created
    ✓ OpenAPI specs included

Phase 2 - Implementation:
  Developer: /speckit.implement
  → Creates auth microservice

Phase 3 - Repeat for other services:
  → Each service follows same workflow
  → Constitution ensures consistency
```

---

## Best Practices by Role

### For Product Owners

1. **Start with `/speckit.specify`**: Don't write specs manually, let AI help
2. **Always run `/speckit.clarify`**: Answer questions to reduce downstream rework
3. **Use checklists early**: Catch issues before engineering starts
4. **Be specific**: Provide concrete examples in your feature descriptions
5. **Prioritize user stories**: P1, P2, P3 in spec.md drives task generation

---

### For Solution Architects

1. **Review spec before `/speckit.plan`**: Ensure requirements are clear
2. **Document decisions in research.md**: Explain why, not just what
3. **Use contracts/ for API-first**: Define interfaces before implementation
4. **Update constitution proactively**: Add principles as patterns emerge
5. **Validate with `/speckit.analyze`**: Ensure designs meet constitution

---

### For Tech Leads

1. **Run `/speckit.analyze` always**: Never skip pre-implementation validation
2. **Review dependency graph in tasks.md**: Identify critical path early
3. **Identify parallel work**: Maximize team throughput
4. **Use checklists for reviews**: Standardize quality expectations
5. **Track progress in tasks.md**: Mark tasks complete to show progress

---

### For Developers

1. **Read all artifacts before `/speckit.implement`**: Understand full context
2. **Trust the task order**: Dependencies are calculated automatically
3. **Mark tasks complete**: Update tasks.md as you finish work
4. **Use `/speckit.clarify` when stuck**: Don't guess, ask
5. **Follow the plan**: Resist urge to deviate from architecture

---

### For QA Engineers

1. **Create checklists early**: Before implementation starts
2. **Focus on testability in checklists**: Ensure requirements can be tested
3. **Use `/speckit.analyze`**: Validate coverage before testing
4. **Review acceptance criteria**: Every user story should have clear success metrics
5. **Participate in clarification**: Help Product Owners define testable requirements

---

### For Scrum Masters

1. **Use tasks.md for sprint planning**: Pre-broken down, dependency-aware
2. **Identify parallel streams**: Assign to different developers
3. **Track by user story**: Each story is an independent increment
4. **Monitor dependencies**: Use dependency graph to unblock team
5. **Measure by story completion**: Not individual tasks

---

## Summary Matrix

### Command Ownership

| Command | Primary Owner | Secondary Users | When to Use |
|---------|---------------|-----------------|-------------|
| **specify** | Product Owner | Business Analyst | Start of feature, requirements definition |
| **clarify** | Product Owner | Developer | After specify, when ambiguities exist |
| **checklist** | Multi-Role | All | After specification, before planning, before implementation |
| **contextualize** | Solution Architect | Tech Lead, Engineering Manager | Project inception, before tasks, when standards change |
| **plan** | Solution Architect | Tech Lead | After specification, before tasks |
| **tasks** | Tech Lead | Scrum Master | After planning (and contextualize), before implementation |
| **analyze** | Tech Lead | QA Engineer | After tasks, before implementation |
| **implement** | Developer | - | After analyze passes, during development |
| **constitution** | Engineering Manager | Architect | Project inception, principle updates |

---

### Role Participation by Stage

| Stage | Primary Role | Supporting Roles | Commands Used |
|-------|--------------|------------------|---------------|
| **Governance** | Engineering Manager | Solution Architect | constitution |
| **Project Context Setup** | Solution Architect | Tech Lead, Engineering Manager | contextualize |
| **Specification** | Product Owner | Business Analyst | specify, clarify |
| **Quality Validation** | Multi-Role | QA, Security, DevOps | checklist (domain-specific) |
| **Architecture Design** | Solution Architect | Engineering Manager | architect (after specify, before plan) |
| **Technical Planning** | Solution Architect | Tech Lead | plan, checklist (architecture), contextualize (if needed) |
| **Task Planning** | Tech Lead | Scrum Master | tasks (after contextualize) |
| **Pre-Implementation** | Tech Lead | QA Engineer | analyze |
| **Implementation** | Developer | - | implement |

---

## Conclusion

GitHub Spec Kit provides a complete workflow from specification to implementation, with clear role assignments:

1. **Engineering Managers** own governance (constitution) and architecture oversight
2. **Architects** own formal architecture design (architect, after requirements) and technical design (plan, constitution)
3. **Product Owners** own requirements (specify, clarify)
4. **Tech Leads** own quality and execution (tasks, analyze)
5. **Developers** own implementation (implement)
6. **QA/Security/DevOps** own domain-specific validation (checklist)
7. **Scrum Masters** own process facilitation (tasks, planning)

**Key Principle**: Each role uses commands at the appropriate stage to ensure quality, consistency, and efficiency in the development process.

---

**Version**: 1.1
**Last Updated**: 2025-11-04
