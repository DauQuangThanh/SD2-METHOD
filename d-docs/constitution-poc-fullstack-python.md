<!--
Sync Impact Report
Version: (initial) -> 1.0.0
Modified Principles: (initial adoption)
Added Sections: Core Principles; Architecture & Technical Constraints; Delivery Workflow & Quality Gates; Governance
Removed Sections: None
Templates Requiring Updates:
	.specify/templates/plan-template.md ✅ (added Constitution Gate list)
	.specify/templates/spec-template.md ✅ (aligns already; no change needed)
	.specify/templates/tasks-template.md ⚠ (optional future enhancement: add explicit tasks for Observability & Security per Principles 4 & 5)
	.specify/templates/agent-file-template.md ⚠ (will auto-populate once plans exist)
	.specify/templates/checklist-template.md ✅ (generic; no conflicting references)
Deferred TODOs: None
-->

# E‑Commerce Platform PoC Constitution

## Core Principles

### 1. Hexagonal Architecture Integrity (NON‑NEGOTIABLE)
All backend domain logic MUST reside in inner domain modules with no outbound framework
dependencies. Adapters (FastAPI endpoints, DB repositories, message brokers, external
APIs) MUST depend inward only. Vue frontend consumes stable HTTP/JSON or typed contract
schemas—never internal Python objects. Direct coupling across adapter layers is
PROHIBITED; communication crosses the boundary only via explicit use-case/service
interfaces. Any proposed shortcut (e.g., calling ORM models from route handlers) MUST be
rejected unless accompanied by a migration plan preserving isolation.

Rationale: Guarantees testability, replaceability (e.g., swap FastAPI or persistence), and
gradual evolution from PoC to production.

### 2. Evolutionary Path: PoC → Production
All code MUST be written with an explicit maturation path: PoC (exploratory) → Hardened
MVP → Production-ready. Each module MUST declare its maturity level in a top-of-file
docstring or README fragment. Promotion requires: (a) tests at required coverage (see
Principle 4), (b) removed experimental flags, (c) performance & security review notes.
Throwaway prototypes MUST live under clearly marked experimental namespaces and MUST
NOT be imported by production-bound modules.

Rationale: Prevents PoC entropy while enabling rapid validation of product hypotheses.

### 3. Contract-First Interfaces & Backward Compatibility
All externally consumed interfaces (API endpoints, DB schemas, domain service ports,
frontend API clients) MUST be defined via versioned contracts (OpenAPI spec, Pydantic
schema, or SQL migration layer) before implementation. Breaking changes REQUIRE either
version bump with dual-run deprecation window or explicit migration plan approved in
review. Database migrations MUST be forward-applicable and reversible (down migration or
documented rollback procedure). Frontend integration MUST consume generated or typed
client stubs when available.

Rationale: Stabilizes integration velocity and reduces regression risk as the platform scales.

### 4. Quality & Observability as Gate Criteria
Minimum automated test coverage: 70% domain layer, 50% adapters during PoC, increasing
to 85% / 70% at Production readiness. Every feature MUST ship with: structured logging
(correlated by request / job id), basic metrics (latency, error rate), and at least one
actionable health check. Critical paths (checkout, payment orchestration, inventory
adjustments) REQUIRE idempotency protections plus integration tests exercising failure
scenarios (DB conflict, downstream timeout, malformed input). No feature is DONE until
its observability signals are documented in the plan's Constitution Check section.

Rationale: Prevents invisible failures and enables safe iterative delivery.

### 5. Secure & Compliant Data Stewardship
PostgreSQL schemas MUST follow explicit ownership (module or bounded context). PII fields
MUST be isolated in dedicated tables or encrypted columns where applicable. Secrets MUST
NOT appear in source—managed via environment or secret manager abstraction. Input
validation occurs at boundary (API layer) and domain invariants enforced internally. Data
changes traverse migrations—never ad hoc SQL. Security review (static dependency scan +
vulnerability triage) REQUIRED before promoting a module beyond PoC maturity.

Rationale: Reduces breach surface and ensures predictable data evolution.

## Suggested Project Source Code Structure

This structure adheres to hexagonal architecture principles, ensuring clear separation
between domain logic, application use cases, and adapters.

```
project-root/
├── backend/
│   ├── src/
│   │   ├── domain/                    # Pure business logic (framework-agnostic)
│   │   │   ├── __init__.py
│   │   │   ├── entities/              # Domain entities & value objects
│   │   │   ├── repositories/          # Repository interfaces (ports)
│   │   │   └── services/              # Domain services
│   │   │
│   │   ├── application/               # Use cases & application services
│   │   │   ├── __init__.py
│   │   │   ├── use_cases/             # Application use cases
│   │   │   ├── ports/                 # Application-level ports
│   │   │   └── dtos/                  # Data transfer objects
│   │   │
│   │   ├── adapters/                  # External dependencies
│   │   │   ├── __init__.py
│   │   │   ├── api/                   # FastAPI endpoints (primary adapter)
│   │   │   │   ├── routers/
│   │   │   │   ├── dependencies/
│   │   │   │   └── schemas/           # Pydantic request/response models
│   │   │   ├── persistence/           # Database adapters (secondary adapter)
│   │   │   │   ├── repositories/      # Repository implementations
│   │   │   │   └── models/            # SQLAlchemy ORM models
│   │   │   └── external/              # External API clients
│   │   │
│   │   ├── infrastructure/            # Cross-cutting concerns
│   │   │   ├── config/                # Configuration & settings
│   │   │   ├── logging/               # Logging setup
│   │   │   └── di/                    # Dependency injection container
│   │   │
│   │   └── main.py                    # Application entry point
│   │
│   ├── tests/
│   │   ├── unit/                      # Domain & application tests
│   │   ├── integration/               # Adapter integration tests
│   │   └── e2e/                       # End-to-end tests
│   │
│   ├── migrations/                    # Alembic database migrations
│   ├── pyproject.toml
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── components/                # Vue 3 components
│   │   │   ├── base/                  # Reusable UI primitives
│   │   │   └── features/              # Feature-specific components
│   │   ├── composables/               # Vue composables
│   │   ├── contracts/                 # API contract types (TypeScript)
│   │   ├── services/                  # API client services
│   │   ├── stores/                    # Pinia state management
│   │   ├── router/                    # Vue Router configuration
│   │   ├── assets/                    # Static assets
│   │   └── main.ts                    # Application entry point
│   │
│   ├── tests/
│   │   ├── unit/
│   │   └── e2e/
│   │
│   ├── public/
│   ├── package.json
│   ├── vite.config.ts
│   ├── tsconfig.json
│   └── README.md
│
├── docs/                              # Project documentation
├── docker-compose.yml                 # Local development setup
└── README.md
```

**Key Structural Principles:**

- **Domain Isolation**: The `domain/` layer has zero dependencies on frameworks, ORM,
  or FastAPI. Contains only pure Python business logic.
- **Adapter Independence**: HTTP endpoints (`adapters/api/`) and database repositories
  (`adapters/persistence/`) depend inward through interfaces defined in `domain/` and
  `application/` layers.
- **Contract-First Frontend**: `frontend/src/contracts/` contains TypeScript types
  mirroring backend Pydantic schemas for type-safe API consumption.
- **Maturity Markers**: Each module declares its maturity level (PoC/MVP/Production) in
  docstrings or README fragments as per Principle 2.
- **Migration Control**: All database schema changes flow through `migrations/` with
  forward/backward compatibility.

## Architecture & Technical Constraints

Stack: Frontend (Vue 3 + TypeScript + Vite + TailwindCSS). Backend (Python 3.12+, FastAPI
for delivery layer, Pydantic for contracts, async PostgreSQL 15+ via SQLAlchemy / Psycopg
or equivalent). Domain logic MUST remain framework-agnostic. Dependency inversion at
service boundaries. Async-first I/O. No global singletons except DI container / settings.
Performance Baseline Targets (PoC → Prod): p95 API latency < 400ms (PoC), < 250ms (Prod);
Checkout critical path success rate ≥ 99.5% PoC, ≥ 99.9% Prod. Frontend build MUST remain
tree-shakeable; shared UI primitives consolidated to avoid duplication.

Prohibited: Tight coupling of UI state management to transport layer, implicit circular
imports, schema drift (detect via migration diff checks), silent exception swallowing.

## Delivery Workflow & Quality Gates

Phases per feature: 0 Research → 1 Design (contracts & data model) → 2 Plan Constitution
Gate → 3 Implementation (story slices) → 4 Harden → 5 Promote. A feature MAY halt after
Research if invalidated. Constitution Gate MUST validate: principle alignment, contract
versioning impact, observability plan, security considerations, rollback path, and maturity
level assignment.

Pull Request Requirements:
1. Link to spec & plan sections referencing contract definitions.
2. Evidence of failing tests before implementation (where new domains introduced).
3. Added/updated migrations with rollback notes.
4. Logging & metric additions listed in description.
5. If breaking change: documented deprecation or dual-support window.

Merge is BLOCKED if any gate unmet unless explicitly waived with recorded rationale.

## Governance

Authority: This constitution supersedes ad hoc conventions. Amendments require PR with
section diff, version bump justification (Semantic: MAJOR=principle removal/incompatible
governance change; MINOR=new or materially expanded principle/section; PATCH=clarity/
non-semantic wording). Reviewers MUST verify gates remain objectively testable.

Amendment Procedure:
1. Draft proposal referencing impacted principles / sections.
2. Classify bump level per rules above.
3. Include migration or adoption steps if changing enforcement criteria.
4. Update Sync Impact Report and affected templates.
5. Secure approval from at least two maintainers (or designated governance group once
established).

Compliance:
- Quarterly (or pre-production milestone) audit: architecture boundaries, contract drift,
	test coverage thresholds, security dependency scan status.
- Violations create remediation tasks with tracked due dates.
- Emergency deviations allowed only with logged risk acceptance.

Documentation Synchronization: Plan template Constitution Gate list MUST mirror Principle
set. Tasks for Observability & Security added when moving module maturity upward.

**Version**: 1.0.0 | **Ratified**: 2025-10-26 | **Last Amended**: 2025-10-26
