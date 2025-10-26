# E‑Commerce Platform PoC Constitution

## Core Principles

### 1. Hexagonal Architecture Integrity (NON‑NEGOTIABLE)
All backend domain logic MUST reside in inner domain packages with no outbound framework
or transport dependencies. Adapters (Go net/http handlers, DB repositories, message/pub-sub
adapters, external API clients) depend inward only through well-defined interfaces. The Vue
frontend consumes stable versioned HTTP/JSON contracts—never internal Go structs unless
explicitly defined in exported contract packages. Cross-adapter calls are PROHIBITED; data
flows through application/service (use-case) interfaces. Shortcuts (e.g., handler directly
invoking SQL without repository interface) MUST be rejected unless accompanied by a
temporary waiver plus migration plan preserving isolation.

Rationale: Ensures testability, replaceability (swap transport, persistence, or framework), and
predictable evolution from PoC to production.

### 2. Evolutionary Path: PoC → Production
All code MUST follow a maturation path: PoC (exploratory) → Hardened MVP → Production-ready.
Each package or module MUST declare its maturity level in a leading package comment or
README fragment. Promotion requires: (a) tests at required coverage (see Principle 4), (b)
removal of experimental flags / feature toggles, (c) performance & security review notes.
Throwaway prototypes live under clearly marked experimental namespaces and MUST NOT be
imported by production-bound packages.

Rationale: Prevents PoC entropy while enabling rapid validation of product hypotheses.

### 3. Contract-First Interfaces & Backward Compatibility
All externally consumed interfaces (HTTP APIs, DB schemas, domain service ports, frontend
API clients) MUST be defined via versioned contracts (OpenAPI/JSON Schema, SQL migration
manifest, or interface definition) before implementation. Breaking changes REQUIRE either a
versioned endpoint/contract with deprecation window or an approved migration plan.
Database migrations MUST be forward-applicable and reversible (down migration or rollback
procedure). Frontend integration MUST consume generated or typed client stubs when
available.

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

This structure adheres to hexagonal architecture principles with Go-specific conventions,
ensuring clear separation between domain logic, application use cases, and adapters.

```
project-root/
├── cmd/
│   └── api/
│       └── main.go                    # Application entry point
│
├── internal/                          # Private application code
│   ├── domain/                        # Pure business logic (framework-agnostic)
│   │   ├── entities/                  # Domain entities & value objects
│   │   ├── repositories/              # Repository interfaces (ports)
│   │   └── services/                  # Domain services
│   │
│   ├── application/                   # Use cases & application services
│   │   ├── usecases/                  # Application use cases
│   │   ├── ports/                     # Application-level ports
│   │   └── dtos/                      # Data transfer objects
│   │
│   ├── adapters/                      # External dependencies
│   │   ├── http/                      # HTTP handlers (primary adapter)
│   │   │   ├── handlers/              # Request handlers
│   │   │   ├── middleware/            # HTTP middleware
│   │   │   ├── contracts/             # Request/response contracts
│   │   │   └── router.go              # Route definitions
│   │   ├── persistence/               # Database adapters (secondary adapter)
│   │   │   ├── postgres/              # PostgreSQL implementation
│   │   │   │   ├── repositories/      # Repository implementations
│   │   │   │   └── models/            # Database models
│   │   │   └── migrations/            # SQL migration files
│   │   └── external/                  # External API clients
│   │
│   ├── infrastructure/                # Cross-cutting concerns
│   │   ├── config/                    # Configuration management
│   │   ├── logger/                    # Structured logging
│   │   └── di/                        # Dependency injection setup
│   │
│   └── types.go                       # Shared types & interfaces
│
├── pkg/                               # Public, reusable packages
│   └── contracts/                     # Exported API contracts (if needed)
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
├── tests/                             # Integration & E2E tests
│   ├── integration/
│   └── e2e/
│
├── docs/                              # Project documentation
├── docker-compose.yml                 # Local development setup
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

**Key Structural Principles:**

- **Domain Isolation**: The `internal/domain/` layer has zero dependencies on net/http,
  database/sql, or any framework. Contains only pure Go business logic with interfaces.
- **Adapter Independence**: HTTP handlers (`adapters/http/`) and database repositories
  (`adapters/persistence/`) depend inward through interfaces defined in `domain/` and
  `application/` layers.
- **Internal Package**: Following Go conventions, `internal/` ensures private application
  code cannot be imported by external projects.
- **Contract-First Frontend**: `frontend/src/contracts/` contains TypeScript types
  mirroring backend JSON contracts for type-safe API consumption.
- **Maturity Markers**: Each package declares its maturity level (PoC/MVP/Production) in
  package comments as per Principle 2.
- **Migration Control**: All database schema changes flow through
  `internal/adapters/persistence/migrations/` with forward/backward compatibility.

## Architecture & Technical Constraints

Stack: Frontend (Vue 3 + TypeScript + Vite + TailwindCSS). Backend (Go 1.24+, standard
library net/http + minimal routing layer if needed, PostgreSQL 15+ via database/sql with
lightweight migration tool). Domain logic MUST remain framework-agnostic (pure Go
packages). Dependency inversion via interfaces at service boundaries. Concurrency uses
context-aware goroutines with cancellation. No global mutable singletons except a settings
provider or DI container. Performance Targets (PoC → Prod): p95 API latency < 400ms (PoC),
< 250ms (Prod); Checkout critical path success rate ≥ 99.5% PoC, ≥ 99.9% Prod. Frontend
build MUST remain tree-shakeable; shared UI primitives consolidated to avoid duplication.

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

**Version**: 1.1.0 | **Ratified**: 2025-10-26 | **Last Amended**: 2025-10-26
