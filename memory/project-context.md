---
description: "Project context template for AI agent consistency"
---

# Project Context: [PROJECT NAME]

**Purpose**: This file provides essential project information that AI agents should reference before implementing any task to ensure consistency across the development lifecycle.

---

## Project Goal

> **A one-sentence mission statement for the entire project**

[EXAMPLE: "Build a scalable e-commerce platform that enables small businesses to sell products online with integrated payment processing and inventory management."]

---

## Product Development Stage
- [EXAMPLE: Mock-up: A static visual representation, typically an image or non-functional wireframe, used only for design and layout approval.]
- [EXAMPLE: PoC (Proof of Concept): A minimal, non-production-ready implementation designed solely to validate a single technical idea or assumption.]
- [EXAMPLE: MVP (Minimum Viable Product): The first usable, production-ready version of a product that offers just enough core functionality to be deployed and gather initial user feedback.]
- [EXAMPLE: Production: The fully stable, scalable, and polished system currently deployed and actively serving end-users with comprehensive features and quality standards.]
---

## Tech Stack & Versions

**Programming Languages:**
- [EXAMPLE: Python 3.12]
- [EXAMPLE: TypeScript 5.3]

**Major Frameworks:**
- Backend: [EXAMPLE: FastAPI 0.109, Django 5.0]
- Frontend: [EXAMPLE: React 18.2, Next.js 14]
- Mobile: [EXAMPLE: React Native 0.73]

**Critical Libraries & Versions:**
- Database: [EXAMPLE: PostgreSQL 16, SQLAlchemy 2.0]
- Authentication: [EXAMPLE: JWT, JWE, OAuth2]
- Testing: [EXAMPLE: pytest 8.0, Jest 29]
- Others: [EXAMPLE: Redis 7.2, Celery 5.3]

---

## Coding Style Guide

### Naming Conventions

**Variables & Functions:**
- [EXAMPLE: Python: `snake_case` for variables, functions, and methods]
- [EXAMPLE: TypeScript: `camelCase` for variables and functions, `PascalCase` for classes and components]

**Classes & Components:**
- [EXAMPLE: Python: `PascalCase` for class names]
- [EXAMPLE: TypeScript: `PascalCase` for React components and TypeScript classes]

**Constants:**
- [EXAMPLE: `UPPER_SNAKE_CASE` for constants across all languages]

**Files & Directories:**
- [EXAMPLE: Python: `snake_case.py` for modules]
- [EXAMPLE: TypeScript: `PascalCase.tsx` for React components, `camelCase.ts` for utilities]
- [EXAMPLE: Directories: `kebab-case` for all directory names]

---

## Architectural Overview

### System Architecture

[EXAMPLE: "Microservices architecture with separate services for user management, product catalog, order processing, and payment handling. Services communicate via REST APIs and message queues (Kafka)."]

[EXAMPLE: "Monolithic architecture with clear separation between presentation layer (React frontend), business logic layer (FastAPI backend), and data access layer (SQLAlchemy ORM)."]

### Project Source Code Structure

```
[PROJECT ROOT]/
├── src/
│   ├── domain/                   # [EXAMPLE: Core business logic (hexagon center)]
│   │   ├── entities/             # [EXAMPLE: Business entities and value objects]
│   │   ├── services/             # [EXAMPLE: Domain services with business rules]
│   │   └── ports/                # [EXAMPLE: Interfaces for external interactions]
│   │       ├── inbound/          # [EXAMPLE: Use cases/application services (driving ports)]
│   │       └── outbound/         # [EXAMPLE: Repository/external service interfaces (driven ports)]
│   ├── application/              # [EXAMPLE: Application layer orchestration]
│   │   ├── usecases/             # [EXAMPLE: Implementation of inbound ports]
│   │   ├── dto/                  # [EXAMPLE: Data transfer objects]
│   │   └── mappers/              # [EXAMPLE: Domain <-> DTO mappers]
│   ├── adapters/                 # [EXAMPLE: External adapters (hexagon edges)]
│   │   ├── inbound/              # [EXAMPLE: Driving/primary adapters]
│   │   │   ├── api/              # [EXAMPLE: REST API controllers]
│   │   │   ├── graphql/          # [EXAMPLE: GraphQL resolvers]
│   │   │   ├── grpc/             # [EXAMPLE: gRPC service implementations]
│   │   │   └── cli/              # [EXAMPLE: Command-line interface]
│   │   └── outbound/             # [EXAMPLE: Driven/secondary adapters]
│   │       ├── persistence/      # [EXAMPLE: Database repositories implementation]
│   │       ├── messaging/        # [EXAMPLE: Message queue adapters (Kafka, RabbitMQ)]
│   │       ├── cache/            # [EXAMPLE: Cache adapters (Redis, Memcached)]
│   │       └── external/         # [EXAMPLE: Third-party API clients]
│   ├── infrastructure/           # [EXAMPLE: Cross-cutting concerns]
│   │   ├── config/               # [EXAMPLE: Configuration management]
│   │   ├── middleware/           # [EXAMPLE: Request/response middleware]
│   │   ├── logging/              # [EXAMPLE: Logging infrastructure]
│   │   └── security/             # [EXAMPLE: Authentication/authorization]
│   └── shared/                   # [EXAMPLE: Shared utilities and helpers]
│       ├── errors/               # [EXAMPLE: Custom error classes]
│       ├── validators/           # [EXAMPLE: Common validation logic]
│       └── utils/                # [EXAMPLE: Utility functions]
├── tests/                        # [EXAMPLE: Test suite]
│   ├── unit/                     # [EXAMPLE: Domain and application unit tests]
│   ├── integration/              # [EXAMPLE: Adapter integration tests]
│   └── e2e/                      # [EXAMPLE: End-to-end tests]
├── docs/                         # [EXAMPLE: Project documentation]
├── scripts/                      # [EXAMPLE: Automation and deployment scripts]
└── config/                       # [EXAMPLE: Environment-specific configurations]
```
---

## Error & Log Handling Strategy

### Error Handling

**HTTP Status Codes:**
- [EXAMPLE: 200 OK for successful GET requests]
- [EXAMPLE: 201 Created for successful POST requests]
- [EXAMPLE: 400 Bad Request for validation errors]
- [EXAMPLE: 401 Unauthorized for authentication failures]
- [EXAMPLE: 403 Forbidden for authorization failures]
- [EXAMPLE: 404 Not Found for missing resources]
- [EXAMPLE: 500 Internal Server Error for unexpected errors]

**Error Response Format:**
```json
[EXAMPLE:
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "User-friendly error message",
    "details": [
      {
        "field": "email",
        "issue": "Invalid email format"
      }
    ]
  }
}
]
```

**Exception Handling:**
- [EXAMPLE: All exceptions should be caught at the controller/endpoint level]
- [EXAMPLE: Never expose internal error details to end users]
- [EXAMPLE: User-facing errors must be localized (support i18n)]
- [EXAMPLE: Use custom exception classes for different error types]

### Logging Strategy

**Log Levels:**
- [EXAMPLE: DEBUG: Detailed diagnostic information]
- [EXAMPLE: INFO: General informational messages (user actions, system events)]
- [EXAMPLE: WARNING: Warning messages for recoverable issues]
- [EXAMPLE: ERROR: Error messages for failures that need attention]
- [EXAMPLE: CRITICAL: Critical errors that may cause system failure]

**Logging Framework:**
- [EXAMPLE: Python: Use standard `logging` module with structured logging]
- [EXAMPLE: TypeScript: Use Winston or Pino for structured logging]

**Log Destination:**
- [EXAMPLE: Development: Console output]
- [EXAMPLE: Production: Send logs to Fluentd/ELK Stack/CloudWatch]

**What to Log:**
- [EXAMPLE: Log all API requests (method, path, user ID, response status)]
- [EXAMPLE: Log all authentication attempts (success/failure)]
- [EXAMPLE: Log all database operations (queries, errors)]
- [EXAMPLE: Log all exceptions with full stack traces]
- [EXAMPLE: NEVER log sensitive data (passwords, tokens, credit cards)]

**Log Format:**
```
[EXAMPLE:
{
  "timestamp": "2025-10-28T12:34:56.789Z",
  "level": "INFO",
  "service": "user-service",
  "message": "User login successful",
  "userId": "user-123",
  "requestId": "req-abc-xyz"
}
]
```

---

## Other Important Rules

### Security Guidelines

- [EXAMPLE: Always validate and sanitize user input]
- [EXAMPLE: Use parameterized queries to prevent SQL injection]
- [EXAMPLE: Store passwords using bcrypt with minimum 12 rounds]
- [EXAMPLE: Implement rate limiting on all public endpoints]
- [EXAMPLE: Implement CORS policies appropriately]

### Environment Management

- [EXAMPLE: Use environment variables for configuration (never hardcode)]
- [EXAMPLE: Provide .env.example with all required variables]
- [EXAMPLE: Separate configurations for dev, staging, and production]
- [EXAMPLE: Use secrets manager (AWS Secrets Manager, HashiCorp Vault) in production]

---

## Notes

This file should be updated whenever:
- Major architectural decisions are made
- New frameworks or libraries are adopted
- Coding standards or conventions change
- New error handling or logging patterns are established

**Last Updated**: [DATE]
**Updated By**: [NAME/ROLE]
