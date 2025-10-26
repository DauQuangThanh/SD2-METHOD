# E‑Commerce Frontend Prototype Constitution

## Core Principles

### 1. Componentized Frontend Architecture (NON‑NEGOTIABLE)
All UI logic MUST reside in cohesive, testable Vue 3 single-file components (SFCs) or composables.
State management MUST be centralized (e.g., Pinia or minimal custom store) — no ad hoc global
mutable objects. Cross-cutting concerns (API calls, formatting, feature flags) live in dedicated
service or util modules. Styling standardization via Tailwind design tokens; no inline style drift.
Experimental code isolated under `experimental/` or feature‑flagged. Direct DOM manipulation
outside Vue reactivity system is PROHIBITED (except inside dedicated low-level adapter utilities).

Rationale: Maintains modularity, predictable rendering, and scalability as prototype evolves.

### 2. Incremental Prototype Discipline
Prototype features MUST ship in vertical slices: UI component + local state + mock/service stub.
Each slice MUST be independently demoable. Experiments time‑boxed (≤ 21 days) and tagged.
Promotion to "baseline" requires (a) minimal tests (snapshot or interaction), (b) removal of dead
branches, (c) documented assumptions or deferred risks in README or plan.

Rationale: Prevents prototype sprawl and enables early stakeholder feedback.

### 3. Interface Contracts & Mock-First API Integration
External API dependencies MUST be represented by TypeScript interfaces + mock modules
before real network integration. API response types centralized (e.g., `src/contracts/`). Breaking
changes to a contract require updating mocks + affected components in same PR. Until backend
stabilizes, versioning is implicit; once backend introduced, formal version tags MUST be added.

Rationale: Enables offline development and early UI progress without backend blockers.

### 4. Lightweight Quality & Telemetry
Minimum coverage target: 40% overall (rising to 60% before backend integration). Critical
user journeys (checkout flow drafts, authentication mock) MUST have at least one interaction
test. Console or dev-overlay logging acceptable; production-grade logging deferred. Performance
budget (initial): core bundle ≤ 250KB gzip, route transition interactive ≤ 150ms on modern laptop.
No feature merges without a visible manual demo note or screenshot.

Rationale: Balances speed with baseline safety without over‑engineering.

### 5. Accessibility & UX Feedback Loop
All new UI components MUST meet baseline accessibility: semantic HTML, focus order,
contrast ratio WCAG AA, keyboard navigation. User feedback collection (lightweight)—either
noted usability observations or a feedback issue log—MUST accompany each major slice.
Design tokens (colors/spacing/typography) centralized; ad hoc color hex values PROHIBITED.

Rationale: Prevents expensive retrofits and validates user value early.

## Suggested Project Source Code Structure

This frontend-focused structure emphasizes rapid prototyping with Vue 3 while maintaining
modularity, testability, and clear separation of concerns for future backend integration.

```
project-root/
├── src/
│   ├── components/                    # Vue 3 single-file components
│   │   ├── base/                      # Reusable UI primitives
│   │   │   ├── Button.vue
│   │   │   ├── Input.vue
│   │   │   ├── Card.vue
│   │   │   └── Modal.vue
│   │   ├── features/                  # Feature-specific components
│   │   │   ├── auth/                  # Authentication UI
│   │   │   ├── catalog/               # Product catalog
│   │   │   ├── checkout/              # Checkout flow
│   │   │   └── profile/               # User profile
│   │   └── layout/                    # Layout components
│   │       ├── Header.vue
│   │       ├── Footer.vue
│   │       └── Sidebar.vue
│   │
│   ├── composables/                   # Vue 3 composables (reusable logic)
│   │   ├── useAuth.ts                 # Authentication state & logic
│   │   ├── useCart.ts                 # Shopping cart logic
│   │   ├── useApi.ts                  # API call abstraction
│   │   └── useForm.ts                 # Form validation helpers
│   │
│   ├── stores/                        # Pinia state management
│   │   ├── auth.ts                    # Authentication store
│   │   ├── cart.ts                    # Cart store
│   │   ├── products.ts                # Product catalog store
│   │   └── ui.ts                      # UI state (modals, toasts, etc.)
│   │
│   ├── services/                      # Service layer (API & mocks)
│   │   ├── api/                       # API client services
│   │   │   ├── client.ts              # Base HTTP client
│   │   │   ├── auth.ts                # Auth API calls
│   │   │   ├── products.ts            # Product API calls
│   │   │   └── orders.ts              # Order API calls
│   │   └── mocks/                     # Mock data & services
│   │       ├── mockAuth.ts            # Mock authentication
│   │       ├── mockProducts.ts        # Mock product data
│   │       └── mockOrders.ts          # Mock order processing
│   │
│   ├── contracts/                     # TypeScript types & interfaces
│   │   ├── auth.ts                    # Auth-related types
│   │   ├── products.ts                # Product types
│   │   ├── orders.ts                  # Order types
│   │   └── api.ts                     # API request/response types
│   │
│   ├── router/                        # Vue Router configuration
│   │   ├── index.ts                   # Router setup
│   │   └── guards.ts                  # Route guards (auth, etc.)
│   │
│   ├── assets/                        # Static assets
│   │   ├── styles/                    # Global styles & Tailwind config
│   │   │   ├── main.css               # Main stylesheet
│   │   │   └── tokens.css             # Design tokens (colors, spacing)
│   │   ├── images/                    # Image assets
│   │   └── icons/                     # Icon assets
│   │
│   ├── utils/                         # Utility functions
│   │   ├── formatters.ts              # Data formatters (currency, dates)
│   │   ├── validators.ts              # Input validators
│   │   └── helpers.ts                 # General helpers
│   │
│   ├── views/                         # Page-level components
│   │   ├── Home.vue
│   │   ├── ProductList.vue
│   │   ├── ProductDetail.vue
│   │   ├── Cart.vue
│   │   ├── Checkout.vue
│   │   └── Profile.vue
│   │
│   ├── experimental/                  # Time-boxed experimental features
│   │   └── (isolated prototype features)
│   │
│   ├── App.vue                        # Root component
│   ├── main.ts                        # Application entry point
│   └── env.d.ts                       # TypeScript environment declarations
│
├── tests/                             # Test files
│   ├── unit/                          # Unit tests (components, composables)
│   │   ├── components/
│   │   └── composables/
│   ├── integration/                   # Integration tests
│   └── e2e/                           # End-to-end tests (Playwright/Cypress)
│
├── public/                            # Public static assets
│   ├── favicon.ico
│   └── robots.txt
│
├── .storybook/                        # Storybook configuration (optional)
│   └── main.ts
│
├── docs/                              # Project documentation
│   ├── features/                      # Feature documentation
│   ├── design/                        # Design decisions & mockups
│   └── feedback/                      # User feedback logs
│
├── .github/
│   └── workflows/                     # CI/CD workflows
│       └── ci.yml
│
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.js
├── postcss.config.js
├── .eslintrc.js
├── .prettierrc
└── README.md
```

**Key Prototype Structural Principles:**

- **Component Modularity**: Clear separation between reusable `base/` components,
  feature-specific `features/` components, and page-level `views/`.
- **Mock-First Development**: `services/mocks/` contains mock implementations enabling
  development without backend dependencies. Easy to swap with real API calls later.
- **Centralized State**: Pinia stores in `stores/` manage application state with clear
  boundaries per domain (auth, cart, products, UI).
- **Type Safety**: `contracts/` directory centralizes all TypeScript interfaces and types,
  preparing for future API integration with typed contracts.
- **Design Tokens**: Consolidated color palette, spacing, and typography in
  `assets/styles/tokens.css` using Tailwind custom properties. No ad hoc color values.
- **Experimental Isolation**: Time-boxed experiments live under `experimental/` and are
  clearly marked with expiration dates in their docstrings.
- **Accessibility Built-In**: Base components follow WCAG AA standards with semantic HTML,
  proper ARIA labels, and keyboard navigation support.
- **Lightweight Testing**: 40% coverage target with focus on critical user journeys
  (checkout, auth flows). Interaction tests in `tests/unit/`, visual regression with
  Storybook (optional).

**Future Backend Integration Path:**

When transitioning from prototype to production with backend:
1. Replace `services/mocks/` imports with real API clients from `services/api/`
2. Update `contracts/` types to match backend API schemas (Pydantic/OpenAPI)
3. Add authentication middleware in `router/guards.ts`
4. Implement versioned API contracts (`contracts/v1/`, `contracts/v2/`)
5. Increase test coverage to production standards (60%+ overall)

## Architecture & Technical Constraints

Stack: Frontend only (Vue 3, TypeScript, Vite, TailwindCSS). No live backend dependency—API
calls mocked via local modules or mock service worker until backend integration phase. State
management: Pinia (or minimal store) centralized. Component library seeds: shared primitives
in `src/components/base/`. Performance prototype targets: First meaningful paint under 1s (local
dev), core bundle ≤ 250KB gzip. No premature SSR or micro-frontend segmentation.

Deferred (Future Backend Phase): API gateway strategy, auth provider integration, Zero Trust
controls, production observability platform.
## Future Hardening Roadmap

Planned Reintroduction (Backend Phase):
- Zero Trust enforcement (service identity, authN/authZ layering)
- Data stewardship & PII classification
- Formal SLOs & error budget policy
- Observability stack (metrics, tracing, structured logs) with coverage gates
- Contract versioning with deprecation windows

Prototype Era Constraints:
- Security: basic dependency audit (weekly), no secrets committed, environment variables for API keys.
- Performance: monitor bundle size growth per feature; flag if >10% increase.

Prohibited: Tight coupling of UI state management to transport layer, implicit circular
imports, schema drift (detect via migration diff checks), silent exception swallowing.

## Delivery Workflow & Quality Gates

Phases per feature: 0 Sketch → 1 Slice Plan → 2 Implement Slice → 3 Demo & Feedback → 4
Refine (optional). Constitution Gate for prototype: architecture alignment (Principles 1–3 & 5),
mock contract presence, accessibility checks, bundle impact, and documented next risks.

Pull Request Requirements:
1. Link to plan slice and mock contract (if API involved).
2. At least one screenshot or short Loom/GIF demonstration.
3. Added/updated component story (Storybook or equivalent) for new UI elements.
4. Accessibility quick audit (keyboard nav + contrast) noted.
5. Bundle size delta noted (if >10KB gzip change in core bundle).

Merge is BLOCKED if any gate unmet unless explicitly waived (waiver ≤ 14 days, tracked).

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

Documentation Synchronization: Plan template gates reflect prototype focus. When backend
introduced, restore security & observability gates and retire TODO(SECURITY_REINTRO).

**Version**: 2.0.0 | **Ratified**: 2025-10-26 | **Last Amended**: 2025-10-26
