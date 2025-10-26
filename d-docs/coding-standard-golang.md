# Go Coding Standards

**Version**: 1.0.0
**Last Updated**: 2025-10-26
**Applies To**: Go 1.24+ projects

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Naming Conventions](#naming-conventions)
3. [Code Layout and Formatting](#code-layout-and-formatting)
4. [Package Organization](#package-organization)
5. [Type Declarations](#type-declarations)
6. [Documentation Standards](#documentation-standards)
7. [Error Handling](#error-handling)
8. [Concurrency Patterns](#concurrency-patterns)
9. [Testing Conventions](#testing-conventions)
10. [Hexagonal Architecture Guidelines](#hexagonal-architecture-guidelines)
11. [Tools and Enforcement](#tools-and-enforcement)

---

## General Principles

### 1. Follow Effective Go

All Go code MUST adhere to [Effective Go](https://go.dev/doc/effective_go) guidelines and the official [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments).

### 2. Code Quality Tenets

- **Simplicity beats complexity**: Clear, straightforward code is preferred
- **Readability counts**: Code should be self-documenting where possible
- **Composition over inheritance**: Use interfaces and composition
- **Explicit error handling**: Never ignore errors
- **Small interfaces**: Prefer small, focused interfaces

### 3. Go Proverbs

- Don't communicate by sharing memory; share memory by communicating
- Concurrency is not parallelism
- The bigger the interface, the weaker the abstraction
- Make the zero value useful
- interface{} says nothing
- Gofmt's style is no one's favorite, yet gofmt is everyone's favorite
- Clear is better than clever
- Reflection is never clear

---

## Naming Conventions

### Package Names

```go
// Package names: lowercase, single word, no underscores
package user
package order
package http

// AVOID: Multiple words or underscores
package user_service  // BAD
package userService   // BAD

// If multiple words needed, use one compound word
package httputil
package ioutil
```

### File Names

```go
// File names: lowercase with underscores for multiple words
user.go
user_repository.go
user_test.go
http_handler.go

// AVOID: Camel case or mixed case
userRepository.go  // BAD
UserRepository.go  // BAD
```

### Variables and Functions

```go
// Use mixedCaps (camelCase) for unexported, MixedCaps (PascalCase) for exported

// Exported (public)
func CalculateTotalPrice(items []Item) decimal.Decimal {
    // ...
}

var DefaultTimeout = 30 * time.Second

// Unexported (private)
func calculateDiscount(price decimal.Decimal) decimal.Decimal {
    // ...
}

var maxRetryAttempts = 3

// Short variable names for small scopes
for i := 0; i < len(items); i++ {
    // i is fine here
}

// Longer names for broader scopes
var userRepository UserRepository
var httpClient *http.Client
```

### Variable Naming Guidelines

```go
// GOOD: Short names for short scopes
for i, item := range items {
    process(item)
}

// GOOD: Descriptive names for longer scopes
func ProcessOrder(orderID string, userRepository UserRepository, paymentGateway PaymentGateway) error {
    // orderID, userRepository, paymentGateway are clear
}

// Common short names
// i, j, k: loop indices
// n: counter or size
// r: reader
// w: writer
// b: buffer/byte slice
// err: error
// ctx: context
```

### Type Names

```go
// Use PascalCase for exported types
type User struct {
    ID    int
    Email string
    Name  string
}

type UserRepository interface {
    GetByID(ctx context.Context, id int) (*User, error)
    Save(ctx context.Context, user *User) error
}

// Use camelCase for unexported types
type httpAdapter struct {
    client *http.Client
}

// Avoid stuttering
type User struct {} // GOOD
type UserStruct struct {} // BAD: Don't use "Struct" suffix

// Use singular form
type User struct {} // GOOD
type Users struct {} // BAD (unless it's a collection type)
```

### Interface Names

```go
// Single-method interfaces: method name + "er"
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

// Multi-method interfaces: descriptive name
type UserRepository interface {
    GetByID(ctx context.Context, id int) (*User, error)
    Save(ctx context.Context, user *User) error
    Delete(ctx context.Context, id int) error
}

// AVOID: "I" prefix
type IUserRepository interface {} // BAD
type UserRepository interface {}  // GOOD
```

### Constants

```go
// Exported constants: PascalCase
const (
    MaxRetryAttempts = 3
    DefaultTimeout   = 30 * time.Second
    APIVersion       = "v1"
)

// Unexported constants: camelCase
const (
    maxBufferSize = 1024
    defaultPort   = 8080
)

// Enumerated constants: Use iota
type OrderStatus int

const (
    OrderStatusPending OrderStatus = iota
    OrderStatusConfirmed
    OrderStatusShipped
    OrderStatusDelivered
    OrderStatusCancelled
)
```

### Acronyms and Initialisms

```go
// Keep case consistent for acronyms
type HTTPClient struct {}  // GOOD: All caps
type UserID int            // GOOD: All caps
type URLParser struct {}   // GOOD: All caps

type HttpClient struct {}  // BAD: Mixed case
type UserId int            // BAD: Mixed case

// In variable names
var userID int            // GOOD
var httpClient *HTTPClient // GOOD

var userId int            // BAD
var httpClient *HttpClient // BAD
```

---

## Code Layout and Formatting

### Formatting with gofmt

```go
// ALL code must be formatted with gofmt
// Run before committing:
// gofmt -w .

// Or use goimports (includes import management):
// goimports -w .
```

### Line Length

```go
// No strict line limit, but aim for readability
// Break long lines naturally at punctuation

// GOOD: Natural breaks
result := someFunction(
    firstArgument,
    secondArgument,
    thirdArgument,
)

// GOOD: Method chaining
result := SomeType{}.
    WithFirst(value1).
    WithSecond(value2).
    WithThird(value3)
```

### Indentation

```go
// Use tabs for indentation (gofmt enforces this)
// Editors should display tabs as 4 or 8 spaces

func ExampleFunction() {
	if condition {
		doSomething()
	}
}
```

### Blank Lines

```go
package user

import (
    "context"
    "errors"
)

// One blank line between import groups

const (
    MaxNameLength = 100
)

// One blank line before type declarations

type User struct {
    ID   int
    Name string
}

// One blank line between top-level declarations

func NewUser(name string) (*User, error) {
    if name == "" {
        return nil, errors.New("name required")
    }

    return &User{
        Name: name,
    }, nil
}
```

### Struct Field Alignment

```go
// GOOD: Aligned fields for readability
type User struct {
    ID        int       `json:"id"`
    Email     string    `json:"email"`
    Name      string    `json:"name"`
    CreatedAt time.Time `json:"created_at"`
}

// For large structs, group related fields
type Order struct {
    // Identification
    ID     string
    UserID int

    // Status
    Status    OrderStatus
    CreatedAt time.Time
    UpdatedAt time.Time

    // Financial
    Total    decimal.Decimal
    Currency string
}
```

---

## Package Organization

### Package Structure

```go
// internal/domain/user/user.go
package user

type User struct {
    ID    int
    Email string
}

// internal/domain/user/repository.go
package user

type Repository interface {
    GetByID(ctx context.Context, id int) (*User, error)
}

// internal/domain/user/service.go
package user

type Service struct {
    repo Repository
}
```

### Import Organization

```go
import (
    // Standard library
    "context"
    "fmt"
    "time"

    // Third-party packages
    "github.com/gin-gonic/gin"
    "github.com/shopspring/decimal"

    // Internal packages
    "github.com/mycompany/myproject/internal/domain/user"
    "github.com/mycompany/myproject/internal/infrastructure/database"
)

// Use goimports to automatically organize imports
```

### Import Aliases

```go
// Avoid aliases unless necessary
import (
    "github.com/mycompany/myproject/internal/domain/user"
)

// Use aliases to resolve conflicts
import (
    domainUser "github.com/mycompany/myproject/internal/domain/user"
    modelUser "github.com/mycompany/myproject/internal/adapters/persistence/user"
)

// Use dot imports sparingly (mainly for tests)
import . "github.com/onsi/ginkgo/v2"  // OK for testing frameworks
```

---

## Type Declarations

### Struct Initialization

```go
// GOOD: Use named fields
user := User{
    ID:    1,
    Email: "test@example.com",
    Name:  "Test User",
}

// AVOID: Positional fields (fragile to field reordering)
user := User{1, "test@example.com", "Test User"}  // BAD

// GOOD: Trailing comma for multi-line
config := Config{
    Host:     "localhost",
    Port:     8080,
    Database: "mydb",  // Trailing comma
}
```

### Constructor Functions

```go
// Use New prefix for constructors
func NewUser(email, name string) (*User, error) {
    if email == "" {
        return nil, errors.New("email required")
    }

    return &User{
        Email:     email,
        Name:      name,
        CreatedAt: time.Now(),
    }, nil
}

// For package-scoped types, include package name
func NewUserService(repo UserRepository) *UserService {
    return &UserService{
        repo: repo,
    }
}
```

### Method Receivers

```go
// Use short, consistent receiver names (1-2 letters)
type User struct {
    Name string
}

func (u *User) SetName(name string) {
    u.Name = name
}

func (u User) GetName() string {
    return u.Name
}

// AVOID: Long receiver names
func (user *User) SetName(name string) {}  // BAD
func (this *User) SetName(name string) {}  // BAD
func (self *User) SetName(name string) {}  // BAD

// Use pointer receivers when:
// - Method modifies the receiver
// - Struct is large (copy cost)
// - Consistency (if some methods use *, all should)

// Use value receivers when:
// - Receiver is small and doesn't need modification
// - Receiver is a map, function, or channel
```

### Interface Types

```go
// Define interfaces at the point of use (consumer side)
// GOOD: Interface in the package that uses it
package service

type UserRepository interface {
    GetByID(ctx context.Context, id int) (*User, error)
}

type UserService struct {
    repo UserRepository
}

// AVOID: Defining interfaces in the implementation package
package repository

type UserRepository interface {  // BAD: Defined where implemented
    GetByID(ctx context.Context, id int) (*User, error)
}
```

---

## Documentation Standards

### Package Documentation

```go
// Package user provides user domain entities and business logic.
//
// The package contains the User entity, validation rules, and repository
// interface. It is framework-agnostic and contains no external dependencies.
//
// Example usage:
//
//	user, err := user.NewUser("test@example.com", "Test User")
//	if err != nil {
//	    log.Fatal(err)
//	}
package user
```

### Function Documentation

```go
// CalculateTotalPrice calculates the total price including tax and shipping.
//
// The function applies the tax rate to the subtotal and adds shipping cost.
// If express shipping is requested, an additional fee is applied.
//
// Parameters:
//   - subtotal: Order subtotal before tax and shipping
//   - taxRate: Tax rate as decimal (e.g., 0.08 for 8%)
//   - express: Whether to use express shipping
//
// Returns the total price including all fees and taxes.
func CalculateTotalPrice(subtotal decimal.Decimal, taxRate float64, express bool) decimal.Decimal {
    // Implementation
}

// AVOID: Redundant comments
// Get gets the value  // BAD: Obvious from function name
func Get() string {
    return ""
}
```

### Type Documentation

```go
// User represents a user in the system.
//
// Users are identified by email and can be associated with multiple orders.
// The CreatedAt timestamp is set automatically during creation.
type User struct {
    ID        int       // Unique identifier
    Email     string    // User email address
    Name      string    // Display name
    CreatedAt time.Time // Account creation timestamp
}

// UserRepository provides data access operations for users.
//
// All methods require a context for cancellation and deadlines.
// Methods return errors for database failures or constraint violations.
type UserRepository interface {
    GetByID(ctx context.Context, id int) (*User, error)
    Save(ctx context.Context, user *User) error
}
```

### Inline Comments

```go
// GOOD: Explain WHY, not WHAT
// Check cache first to avoid expensive DB query
if user, ok := cache.Get(userID); ok {
    return user, nil
}

// Apply 10% discount for orders over $100 (marketing campaign requirement)
if order.Total.GreaterThan(decimal.NewFromInt(100)) {
    order.ApplyDiscount(decimal.NewFromFloat(0.10))
}

// BAD: Redundant comments
// Increment counter
counter++ // BAD
```

---

## Error Handling

### Error Creation

```go
// Use standard errors for simple cases
import "errors"

if user == nil {
    return errors.New("user not found")
}

// Use fmt.Errorf for formatted errors
if age < 0 {
    return fmt.Errorf("invalid age: %d", age)
}

// Use error wrapping with %w
func ProcessUser(id int) error {
    user, err := repo.GetByID(ctx, id)
    if err != nil {
        return fmt.Errorf("failed to get user %d: %w", id, err)
    }
    // ...
}
```

### Custom Errors

```go
// Define custom error types for domain errors
type NotFoundError struct {
    Entity string
    ID     int
}

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("%s with ID %d not found", e.Entity, e.ID)
}

// Sentinel errors for expected conditions
var (
    ErrUserNotFound     = errors.New("user not found")
    ErrInvalidEmail     = errors.New("invalid email format")
    ErrDuplicateEmail   = errors.New("email already exists")
)

// Usage
func GetUser(id int) (*User, error) {
    user := findUser(id)
    if user == nil {
        return nil, ErrUserNotFound
    }
    return user, nil
}

// Checking sentinel errors
user, err := GetUser(123)
if errors.Is(err, ErrUserNotFound) {
    // Handle not found
}
```

### Error Handling Patterns

```go
// GOOD: Check errors immediately
user, err := repo.GetByID(ctx, userID)
if err != nil {
    return fmt.Errorf("get user: %w", err)
}

// GOOD: Early return on errors
func ProcessOrder(orderID string) error {
    order, err := getOrder(orderID)
    if err != nil {
        return err
    }

    if err := validateOrder(order); err != nil {
        return err
    }

    if err := processPayment(order); err != nil {
        return err
    }

    return nil
}

// AVOID: Ignoring errors
_ = file.Close()  // BAD: Error ignored

// GOOD: Handle or log errors
if err := file.Close(); err != nil {
    log.Printf("failed to close file: %v", err)
}

// GOOD: Defer with error handling
defer func() {
    if err := file.Close(); err != nil {
        log.Printf("failed to close file: %v", err)
    }
}()
```

### Panic and Recover

```go
// AVOID: Using panic for normal error handling
func GetUser(id int) *User {
    user, err := repo.GetByID(id)
    if err != nil {
        panic(err)  // BAD: Use error return instead
    }
    return user
}

// GOOD: Use panic only for programmer errors
func NewConfig(path string) *Config {
    if path == "" {
        panic("config path cannot be empty")  // OK: Programming error
    }
    // ...
}

// Recover in defer if needed (rare)
func SafeOperation() (err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic recovered: %v", r)
        }
    }()
    // Risky operation
    return nil
}
```

---

## Concurrency Patterns

### Goroutines

```go
// GOOD: Always handle goroutine lifecycle
func ProcessOrders(ctx context.Context, orders []Order) error {
    var wg sync.WaitGroup
    errCh := make(chan error, len(orders))

    for _, order := range orders {
        wg.Add(1)
        go func(o Order) {
            defer wg.Done()
            if err := processOrder(ctx, o); err != nil {
                errCh <- err
            }
        }(order)  // Pass value to avoid closure issues
    }

    // Wait in separate goroutine
    go func() {
        wg.Wait()
        close(errCh)
    }()

    // Collect errors
    for err := range errCh {
        if err != nil {
            return err
        }
    }

    return nil
}
```

### Context Usage

```go
// ALWAYS pass context as first parameter
func GetUser(ctx context.Context, id int) (*User, error) {
    // Check context cancellation
    select {
    case <-ctx.Done():
        return nil, ctx.Err()
    default:
    }

    // Pass context to downstream calls
    return repo.GetByID(ctx, id)
}

// GOOD: Respect context deadlines
func FetchData(ctx context.Context, url string) ([]byte, error) {
    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil {
        return nil, err
    }

    resp, err := client.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()

    return io.ReadAll(resp.Body)
}
```

### Channel Patterns

```go
// GOOD: Sender closes channels
func GenerateNumbers(max int) <-chan int {
    ch := make(chan int)
    go func() {
        defer close(ch)  // Sender closes
        for i := 0; i < max; i++ {
            ch <- i
        }
    }()
    return ch
}

// GOOD: Buffered channels for known capacity
results := make(chan Result, 100)

// GOOD: Select with context
select {
case result := <-resultCh:
    return result, nil
case <-ctx.Done():
    return nil, ctx.Err()
case <-time.After(timeout):
    return nil, errors.New("timeout")
}
```

### Mutex Usage

```go
// GOOD: Protect shared state with mutex
type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Inc() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

func (c *Counter) Value() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.value
}

// GOOD: Use sync.Once for one-time initialization
var (
    instance *Singleton
    once     sync.Once
)

func GetInstance() *Singleton {
    once.Do(func() {
        instance = &Singleton{}
    })
    return instance
}
```

---

## Testing Conventions

### Test File Naming

```go
// user.go -> user_test.go
// user_repository.go -> user_repository_test.go
```

### Test Function Naming

```go
// Pattern: Test<Function>_<Scenario>_<ExpectedBehavior>

func TestCalculateTotalPrice_WithZeroTaxRate_ReturnsSubtotal(t *testing.T) {
    subtotal := decimal.NewFromInt(100)
    result := CalculateTotalPrice(subtotal, 0.0, false)
    assert.Equal(t, subtotal, result)
}

func TestUserRepository_GetByID_WithMissingUser_ReturnsError(t *testing.T) {
    repo := NewUserRepository(db)
    user, err := repo.GetByID(context.Background(), 999999)
    assert.Error(t, err)
    assert.Nil(t, user)
}
```

### Table-Driven Tests

```go
func TestCalculateDiscount(t *testing.T) {
    tests := []struct {
        name     string
        price    decimal.Decimal
        rate     float64
        expected decimal.Decimal
    }{
        {
            name:     "zero rate returns original",
            price:    decimal.NewFromInt(100),
            rate:     0.0,
            expected: decimal.NewFromInt(100),
        },
        {
            name:     "10 percent discount",
            price:    decimal.NewFromInt(100),
            rate:     0.10,
            expected: decimal.NewFromInt(90),
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := CalculateDiscount(tt.price, tt.rate)
            assert.Equal(t, tt.expected, result)
        })
    }
}
```

### Test Helpers

```go
// Use test helpers to reduce duplication
func setupTestDB(t *testing.T) *sql.DB {
    t.Helper()  // Mark as helper for better error reporting

    db, err := sql.Open("postgres", "test_connection_string")
    if err != nil {
        t.Fatalf("failed to open db: %v", err)
    }

    t.Cleanup(func() {
        db.Close()
    })

    return db
}

func TestUserRepository(t *testing.T) {
    db := setupTestDB(t)
    repo := NewUserRepository(db)
    // Test repo...
}
```

### Mocking

```go
// Use interfaces for testability
type UserRepository interface {
    GetByID(ctx context.Context, id int) (*User, error)
}

// Mock implementation for testing
type MockUserRepository struct {
    GetByIDFunc func(ctx context.Context, id int) (*User, error)
}

func (m *MockUserRepository) GetByID(ctx context.Context, id int) (*User, error) {
    if m.GetByIDFunc != nil {
        return m.GetByIDFunc(ctx, id)
    }
    return nil, errors.New("not implemented")
}

// Usage in tests
func TestUserService(t *testing.T) {
    mockRepo := &MockUserRepository{
        GetByIDFunc: func(ctx context.Context, id int) (*User, error) {
            return &User{ID: id, Email: "test@example.com"}, nil
        },
    }

    service := NewUserService(mockRepo)
    user, err := service.GetUser(context.Background(), 1)

    assert.NoError(t, err)
    assert.Equal(t, 1, user.ID)
}
```

---

## Hexagonal Architecture Guidelines

### Domain Layer

```go
// internal/domain/user/user.go
package user

import "errors"

// User entity - pure domain object, no infrastructure dependencies
type User struct {
    ID        int
    Email     string
    Name      string
}

// NewUser creates a new user with validation
func NewUser(email, name string) (*User, error) {
    if email == "" {
        return nil, errors.New("email required")
    }
    if name == "" {
        return nil, errors.New("name required")
    }

    return &User{
        Email: email,
        Name:  name,
    }, nil
}

// ChangeEmail updates user email with validation
func (u *User) ChangeEmail(newEmail string) error {
    if newEmail == "" {
        return errors.New("email required")
    }
    u.Email = newEmail
    return nil
}
```

### Repository Interface (Port)

```go
// internal/domain/user/repository.go
package user

import "context"

// Repository defines data access operations for users (port)
type Repository interface {
    GetByID(ctx context.Context, id int) (*User, error)
    Save(ctx context.Context, user *User) error
    Delete(ctx context.Context, id int) error
}
```

### Repository Implementation (Adapter)

```go
// internal/adapters/persistence/postgres/user_repository.go
package postgres

import (
    "context"
    "database/sql"

    "github.com/mycompany/myproject/internal/domain/user"
)

// UserRepository implements user.Repository using PostgreSQL
type UserRepository struct {
    db *sql.DB
}

func NewUserRepository(db *sql.DB) *UserRepository {
    return &UserRepository{db: db}
}

func (r *UserRepository) GetByID(ctx context.Context, id int) (*user.User, error) {
    var u user.User
    err := r.db.QueryRowContext(
        ctx,
        "SELECT id, email, name FROM users WHERE id = $1",
        id,
    ).Scan(&u.ID, &u.Email, &u.Name)

    if err == sql.ErrNoRows {
        return nil, user.ErrNotFound
    }
    if err != nil {
        return nil, err
    }

    return &u, nil
}

func (r *UserRepository) Save(ctx context.Context, u *user.User) error {
    _, err := r.db.ExecContext(
        ctx,
        "INSERT INTO users (email, name) VALUES ($1, $2) ON CONFLICT (id) DO UPDATE SET email = $1, name = $2",
        u.Email, u.Name,
    )
    return err
}
```

### Use Case (Application Layer)

```go
// internal/application/usecases/create_user.go
package usecases

import (
    "context"

    "github.com/mycompany/myproject/internal/domain/user"
)

type CreateUserRequest struct {
    Email string
    Name  string
}

type CreateUserUseCase struct {
    repo user.Repository
}

func NewCreateUserUseCase(repo user.Repository) *CreateUserUseCase {
    return &CreateUserUseCase{repo: repo}
}

func (uc *CreateUserUseCase) Execute(ctx context.Context, req CreateUserRequest) (*user.User, error) {
    // Domain logic
    u, err := user.NewUser(req.Email, req.Name)
    if err != nil {
        return nil, err
    }

    // Persistence
    if err := uc.repo.Save(ctx, u); err != nil {
        return nil, err
    }

    return u, nil
}
```

### HTTP Handler (Adapter)

```go
// internal/adapters/http/handlers/user_handler.go
package handlers

import (
    "encoding/json"
    "net/http"

    "github.com/mycompany/myproject/internal/application/usecases"
)

type UserHandler struct {
    createUserUC *usecases.CreateUserUseCase
}

func NewUserHandler(createUserUC *usecases.CreateUserUseCase) *UserHandler {
    return &UserHandler{createUserUC: createUserUC}
}

func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
    var req usecases.CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    user, err := h.createUserUC.Execute(r.Context(), req)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(user)
}
```

---

## Tools and Enforcement

### Required Tools

```bash
# Install tools
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
```

### golangci-lint Configuration

```yaml
# .golangci.yml
linters:
  enable:
    - errcheck
    - gosimple
    - govet
    - ineffassign
    - staticcheck
    - unused
    - gofmt
    - goimports
    - misspell
    - gocritic
    - revive

linters-settings:
  govet:
    check-shadowing: true
  gofmt:
    simplify: true
  revive:
    rules:
      - name: exported
        severity: error
```

### Running Tools

```bash
# Format code
gofmt -w .
goimports -w .

# Lint code
golangci-lint run

# Run tests
go test ./...

# Run tests with coverage
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# Static analysis
staticcheck ./...

# All checks
gofmt -w . && goimports -w . && golangci-lint run && go test ./...
```

### Pre-commit Configuration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: master
    hooks:
      - id: go-fmt
      - id: go-imports
      - id: go-lint
      - id: go-unit-tests
```

---

## Enforcement

- All code MUST be formatted with `gofmt` and `goimports` before commit
- All code MUST pass `golangci-lint` with zero warnings
- Pre-commit hooks SHOULD be enabled to enforce standards automatically
- CI pipeline MUST fail if any linter reports errors
- Code reviews MUST verify adherence to these standards
- Test coverage MUST meet thresholds defined in constitution (70%+ domain, 50%+ adapters for PoC)

---

**Version History**:
- 1.0.0 (2025-10-26): Initial release
