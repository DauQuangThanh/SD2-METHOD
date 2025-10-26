# E‑Commerce Platform Constitution

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

### 2. Production Baseline & Controlled Experimentation
The default expectation is Production-grade quality. Experiments MUST be explicitly
scoped (time‑boxed, tagged `experimental`, isolated to /internal/exp or similar) and MUST
NOT transitively affect production packages. Elevation of an experiment requires: (a)
coverage compliance (Principle 4), (b) threat & performance review notes, (c) removal of
temporary feature flags, (d) contract stabilization (Principle 3). Unmaintained experiments
older than 30 days MUST be archived or deleted.

Rationale: Shifts mindset from permissive PoC shortcuts to disciplined production evolution.

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
Minimum automated coverage (enforced via CI): Domain ≥ 85%, Adapters ≥ 70%, Critical
path packages (checkout, payment, inventory) ≥ 90%. Every feature MUST ship with:
structured logging (request / correlation id), metrics (latency, throughput, error ratio), an
explicit SLO statement (availability and latency), and at least one health / readiness /
diagnostic endpoint or probe. Critical paths REQUIRE: idempotency, chaos/failure injection
test(s), latency budget allocation. No merge if newly added or modified code decreases
coverage below thresholds unless an explicit, time‑bounded waiver (<14 days) is recorded.

Rationale: Ensures operational predictability and rapid incident diagnostics.

### 5. Secure & Compliant Data Stewardship
PostgreSQL schemas MUST declare ownership (bounded context) and migration provenance.
PII and regulated data fields MUST be minimized, classified, and (where applicable)
encrypted at rest + masked in non‑prod environments. Secrets NEVER committed—managed
via vault/secret manager; rotation automated or documented. Input validation enforced at
boundary; domain invariants internally. All writes pass through audited migration or service
layer (no ad hoc SQL). Security review (dependency scan, vulnerability triage, schema
change impact) REQUIRED before release of any data-affecting feature.

Rationale: Preserves integrity and compliance while enabling safe iteration.

### 6. Zero Trust & Least Privilege Enforcement
Every request—internal or external—MUST be authenticated & authorized (no implicit trust
based on network location). Service-to-service calls REQUIRE strong identity (mTLS,
token-based identity, or workload attestation). Database roles follow least privilege and are
scoped per service context (read vs write separation where feasible). No shared long-lived
superuser credentials. Access decisions centralized or policy-driven (OPA or equivalent)
and observable (decision logs). Secrets and tokens MUST have rotation cadence ≤ 90 days.
Denied or anomalous access attempts MUST emit structured security events.

Rationale: Reduces lateral movement risk, enforces containment, and provides forensic
visibility.

## Suggested Project Source Code Structure

This production-grade structure adheres to hexagonal architecture with Go conventions,
emphasizing security, observability, and zero-trust principles.

```
project-root/
├── cmd/
│   ├── api/
│   │   └── main.go                    # API service entry point
│   ├── worker/                        # Background workers (if needed)
│   │   └── main.go
│   └── migrator/                      # Migration runner
│       └── main.go
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
│   │   ├── dtos/                      # Data transfer objects
│   │   └── policies/                  # Authorization policies
│   │
│   ├── adapters/                      # External dependencies
│   │   ├── http/                      # HTTP handlers (primary adapter)
│   │   │   ├── handlers/              # Request handlers
│   │   │   ├── middleware/            # Auth, logging, tracing middleware
│   │   │   ├── contracts/             # Versioned API contracts (v1/, v2/)
│   │   │   └── router.go              # Route definitions with auth
│   │   ├── persistence/               # Database adapters (secondary adapter)
│   │   │   ├── postgres/
│   │   │   │   ├── repositories/      # Repository implementations
│   │   │   │   ├── models/            # Database models
│   │   │   │   └── connection.go      # DB connection with least-privilege roles
│   │   │   └── migrations/            # Versioned SQL migrations
│   │   ├── external/                  # External API clients
│   │   │   └── (with circuit breakers & retries)
│   │   └── events/                    # Message broker adapters (if needed)
│   │
│   ├── infrastructure/                # Cross-cutting concerns
│   │   ├── config/                    # Configuration with secret management
│   │   ├── logger/                    # Structured JSON logging with correlation IDs
│   │   ├── metrics/                   # Prometheus/OpenTelemetry metrics
│   │   ├── tracing/                   # Distributed tracing setup
│   │   ├── auth/                      # Authentication & authorization
│   │   │   ├── jwt/                   # Token validation
│   │   │   ├── mtls/                  # Mutual TLS setup
│   │   │   └── policies/              # Policy engine (OPA if used)
│   │   ├── health/                    # Health check endpoints
│   │   └── di/                        # Dependency injection setup
│   │
│   └── types.go                       # Shared types & interfaces
│
├── pkg/                               # Public, reusable packages
│   ├── contracts/                     # Exported API contracts
│   └── errors/                        # Standardized error types
│
├── frontend/
│   ├── src/
│   │   ├── components/                # Vue 3 components
│   │   │   ├── base/                  # Reusable UI primitives
│   │   │   └── features/              # Feature-specific components
│   │   ├── composables/               # Vue composables
│   │   ├── contracts/                 # Versioned API contract types
│   │   ├── services/                  # API client services with auth
│   │   ├── stores/                    # Pinia state management
│   │   ├── router/                    # Vue Router with route guards
│   │   ├── assets/                    # Static assets
│   │   └── main.ts                    # Application entry point
│   │
│   ├── tests/
│   │   ├── unit/
│   │   ├── integration/
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
│   │   ├── auth_test.go               # Authentication flows
│   │   └── critical_paths_test.go     # Critical business paths
│   ├── e2e/
│   └── chaos/                         # Chaos/failure injection tests
│
├── deployments/                       # Deployment configurations
│   ├── kubernetes/                    # K8s manifests with RBAC
│   └── terraform/                     # Infrastructure as code
│
├── scripts/                           # Operational scripts
│   ├── db-backup.sh
│   └── rotate-secrets.sh
│
├── docs/                              # Project documentation
│   ├── architecture/                  # Architecture decision records
│   ├── slos/                          # SLO definitions & error budgets
│   └── runbooks/                      # Operational runbooks
│
├── .github/
│   └── workflows/                     # CI/CD with security scans
│       ├── ci.yml
│       └── security-scan.yml
│
├── docker-compose.yml
├── Dockerfile
├── go.mod
├── go.sum
├── Makefile
└── README.md
```

**Key Production-Grade Structural Principles:**

- **Zero Trust Infrastructure**: `internal/infrastructure/auth/` centralizes authentication
  and authorization with mTLS or token-based identity. All service-to-service calls
  authenticated.
- **Observability First**: Dedicated `infrastructure/logger/`, `metrics/`, `tracing/`, and
  `health/` packages ensure structured logs, metrics, and traces are available for all
  critical paths.
- **Security by Design**: Secrets managed via `infrastructure/config/` with external vault
  integration. Database connections use least-privilege roles. Security events logged.
- **Versioned Contracts**: API contracts versioned under `adapters/http/contracts/v1/`,
  `v2/`, etc., with deprecation windows for breaking changes.
- **Chaos Engineering**: `tests/chaos/` contains failure injection tests for critical
  paths (timeouts, DB failures, circuit breakers).
- **Migration Control**: All schema changes via `adapters/persistence/migrations/` with
  forward/backward compatibility and rollback procedures.
- **Documentation & SLOs**: `docs/slos/` tracks SLO definitions, error budgets, and
  operational procedures. Architecture decisions recorded in ADRs.

## Architecture & Technical Constraints

Stack: Frontend (Vue 3, TypeScript, Vite, TailwindCSS). Backend (Go 1.24+, stdlib net/http,
lightweight router, PostgreSQL 15+ via database/sql + migrations). Domain layer: pure Go
packages (no HTTP, DB, or framework imports). Interfaces define ports; adapters implement
them. Observability: structured JSON logs, metrics exporter, trace context propagation.
Security: mTLS or signed token identity for internal calls; secrets via manager; policy engine
for authZ if complexity justifies. Performance Targets (Production): p95 API latency < 250ms;
Critical checkout workflow success rate ≥ 99.9%; Startup time < 5s; Error budget tracked per
SLO. Frontend: core bundle size budget documented; shared primitives consolidated.
## Zero Trust Security Controls

Controls Inventory: Identity (mTLS / token), Policy Enforcement, Secrets Management, Data
Classification, Audit & Event Logging, Least Privilege RBAC, Dependency Scanning.

Mandatory Baseline:
- Unique service identity and auth on every call (no anonymous internal endpoints).
- Principle of least privilege for DB roles & cloud resources.
- Enforcement of authZ policies at service boundary or centralized gateway.
- All security-relevant events (auth failures, privilege escalations, denied policies) logged.
- Continuous dependency & container scan in CI; critical CVEs block release.
- Disaster recovery: documented RPO/RTO targets for core data sets.

Enhancement Roadmap (tracked separately): runtime anomaly detection, automated secret
rotation workflow, signed artifact provenance (SLSA level target), periodic access reviews.

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

**Version**: 1.2.0 | **Ratified**: 2025-10-26 | **Last Amended**: 2025-10-26
