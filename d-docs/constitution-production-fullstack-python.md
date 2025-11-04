# E‑Commerce Platform Constitution

## Core Principles

### 1. Hexagonal Architecture Integrity (NON‑NEGOTIABLE)
All backend domain logic MUST reside in inner domain modules (pure Python) with no outbound
framework (FastAPI), transport, OR ORM coupling. Adapters (FastAPI routers, async DB
repositories, message broker consumers, external API clients) depend inward only via
explicit service/use-case interfaces. The Vue frontend consumes stable versioned HTTP/JSON
contracts—never internal Python domain objects unless exposed via Pydantic contract models.
Cross-adapter calls are PROHIBITED; data flows through application services. Shortcuts (e.g.,
route handler issuing raw SQL or manipulating ORM session directly) MUST be rejected unless
accompanied by a time‑boxed waiver + migration plan.

Rationale: Preserves testability, hot-swappability (transport/ORM), and controlled evolution.

### 2. Production Baseline & Controlled Experimentation
The default expectation is production-grade quality. Experiments MUST be explicitly scoped
(time‑boxed, tagged `experimental`, isolated under `experimental/` or module suffix) and MUST
NOT transitively affect production modules. Promotion requires: (a) coverage compliance
(Principle 4), (b) threat & performance review notes, (c) removal of feature flags, (d)
contract stabilization (Principle 3). Experiments >30 days old without promotion MUST be
archived or deleted.

Rationale: Maintains production posture while enabling bounded innovation.

### 3. Contract-First Interfaces & Backward Compatibility
All externally consumed interfaces (HTTP APIs, DB schemas, domain service ports, frontend
clients) MUST be defined via versioned contracts (OpenAPI spec, Pydantic v2 models,
Alembic/SQL migration manifest, or abstract Python protocol) before implementation. Breaking
changes REQUIRE either a versioned endpoint/contract with deprecation window or an
approved migration plan. Database migrations MUST be forward-applicable & reversible.
Frontend integration MUST consume generated or typed client stubs.

Rationale: Protects integrators and enables safe iterative change.

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

This production-grade structure adheres to hexagonal architecture principles with Python
conventions, emphasizing security, observability, and zero-trust principles.

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
│   │   │   ├── dtos/                  # Data transfer objects
│   │   │   └── policies/              # Authorization policies
│   │   │
│   │   ├── adapters/                  # External dependencies
│   │   │   ├── __init__.py
│   │   │   ├── api/                   # FastAPI endpoints (primary adapter)
│   │   │   │   ├── routers/
│   │   │   │   │   ├── v1/            # Versioned API routes
│   │   │   │   │   └── v2/
│   │   │   │   ├── dependencies/      # Auth, DB session injection
│   │   │   │   ├── middleware/        # Logging, tracing, auth middleware
│   │   │   │   └── schemas/           # Versioned Pydantic models
│   │   │   │       ├── v1/
│   │   │   │       └── v2/
│   │   │   ├── persistence/           # Database adapters (secondary adapter)
│   │   │   │   ├── repositories/      # Repository implementations
│   │   │   │   ├── models/            # SQLAlchemy ORM models
│   │   │   │   └── connection.py      # DB connection with least-privilege
│   │   │   ├── external/              # External API clients
│   │   │   │   └── (with circuit breakers & retries)
│   │   │   └── events/                # Message broker adapters (if needed)
│   │   │
│   │   ├── infrastructure/            # Cross-cutting concerns
│   │   │   ├── config/                # Config with secret manager integration
│   │   │   ├── logging/               # Structured JSON logging
│   │   │   ├── metrics/               # Prometheus/OpenTelemetry metrics
│   │   │   ├── tracing/               # Distributed tracing (OTel)
│   │   │   ├── auth/                  # Authentication & authorization
│   │   │   │   ├── jwt.py             # JWT token validation
│   │   │   │   ├── mtls.py            # Mutual TLS setup
│   │   │   │   └── policies.py        # Policy engine (OPA if used)
│   │   │   ├── health/                # Health check endpoints
│   │   │   └── di/                    # Dependency injection container
│   │   │
│   │   └── main.py                    # Application entry point
│   │
│   ├── tests/
│   │   ├── unit/                      # Domain & application tests
│   │   ├── integration/               # Adapter integration tests
│   │   │   ├── test_auth_flows.py     # Authentication flows
│   │   │   └── test_critical_paths.py # Critical business paths
│   │   ├── e2e/                       # End-to-end tests
│   │   └── chaos/                     # Chaos/failure injection tests
│   │
│   ├── migrations/                    # Alembic versioned migrations
│   ├── scripts/                       # Operational scripts
│   │   ├── db_backup.py
│   │   └── rotate_secrets.py
│   │
│   ├── pyproject.toml
│   ├── poetry.lock  # or requirements.txt
│   ├── Dockerfile
│   └── README.md
│
├── frontend/
│   ├── src/
│   │   ├── components/                # Vue 3 components
│   │   │   ├── base/                  # Reusable UI primitives
│   │   │   └── features/              # Feature-specific components
│   │   ├── composables/               # Vue composables
│   │   ├── contracts/                 # Versioned API contract types
│   │   │   ├── v1/
│   │   │   └── v2/
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
│   ├── Dockerfile
│   └── README.md
│
├── deployments/                       # Deployment configurations
│   ├── kubernetes/                    # K8s manifests with RBAC
│   └── terraform/                     # Infrastructure as code
│
├── docs/                              # Project documentation
│   ├── architecture/                  # Architecture decision records (ADRs)
│   ├── slos/                          # SLO definitions & error budgets
│   └── runbooks/                      # Operational runbooks
│
├── .github/
│   └── workflows/                     # CI/CD with security scans
│       ├── ci.yml
│       └── security-scan.yml
│
├── docker-compose.yml
└── README.md
```

**Key Production-Grade Structural Principles:**

- **Domain Isolation**: The `domain/` layer has zero dependencies on FastAPI, ORM,
  or async libraries. Contains only pure Python business logic.
- **Zero Trust Infrastructure**: `infrastructure/auth/` centralizes authentication
  and authorization with JWT or mTLS. All service-to-service calls authenticated.
- **Observability First**: Dedicated `infrastructure/logging/`, `metrics/`, `tracing/`,
  and `health/` modules ensure structured logs, metrics, and traces are available for
  all critical paths with correlation IDs via contextvars.
- **Security by Design**: Secrets managed via `infrastructure/config/` with external
  vault integration. Database connections use least-privilege roles. Security events
  logged with structured context.
- **Versioned Contracts**: API routes and Pydantic schemas versioned under `v1/`, `v2/`,
  etc., with deprecation windows for breaking changes.
- **Chaos Engineering**: `tests/chaos/` contains async failure injection tests for
  critical paths (timeouts, DB failures, circuit breakers).
- **Migration Control**: All schema changes via `migrations/` (Alembic) with
  forward/backward compatibility and documented rollback procedures.
- **Documentation & SLOs**: `docs/slos/` tracks SLO definitions, error budgets, and
  operational procedures. Architecture decisions recorded in ADRs.

## Architecture & Technical Constraints

Stack: Frontend (Vue 3 + TypeScript + Vite + TailwindCSS). Backend (Python 3.12+, FastAPI,
async SQLAlchemy or Psycopg + Alembic migrations, Pydantic v2 models, uvicorn/gunicorn).
Domain layer: pure Python modules (no FastAPI, ORM session, or transport imports). Adapters:
HTTP routers, repository implementations, broker consumers, external API clients. Concurrency:
asyncio tasks with cancellation & contextvars for correlation IDs. Observability: structured JSON
logging, metrics (Prometheus/OpenTelemetry), tracing (OTel), request & background task health
probes. Security: mTLS or OIDC/JWT service identity, secret manager integration, policy engine
for complex authZ when justified. Performance Targets (Production): p95 API latency < 250ms;
critical checkout success rate ≥ 99.9%; cold start (first request) < 2s; error budget tracked per
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

**Version**: 1.3.0 | **Ratified**: 2025-10-26 | **Last Amended**: 2025-10-26
