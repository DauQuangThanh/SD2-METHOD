# TypeScript Coding Standards

**Version**: 1.1.0
**Last Updated**: 2025-10-26
**Applies To**: TypeScript 5.0+ projects (Vue 3, React, Node.js)

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Naming Conventions](#naming-conventions)
3. [Code Layout and Formatting](#code-layout-and-formatting)
4. [Type Annotations](#type-annotations)
5. [Import and Export Organization](#import-and-export-organization)
6. [Documentation Standards](#documentation-standards)
7. [Error Handling](#error-handling)
8. [Async/Await Patterns](#asyncawait-patterns)
9. [HTML and DOM Element Naming Conventions](#html-and-dom-element-naming-conventions)
10. [Vue 3 Specific Guidelines](#vue-3-specific-guidelines)
11. [Testing Conventions](#testing-conventions)
12. [Tools and Enforcement](#tools-and-enforcement)

---

## General Principles

### 1. TypeScript Best Practices

All TypeScript code MUST leverage the type system fully. Type safety is not optional.

### 2. Code Quality Tenets

- **Type safety first**: Use the strictest TypeScript configuration
- **Explicit over implicit**: Declare types explicitly when inference is unclear
- **Immutability preferred**: Use `const` by default, `readonly` for properties
- **Functional patterns**: Prefer pure functions and composition
- **Modern JavaScript**: Use ES2020+ features (optional chaining, nullish coalescing)

### 3. TypeScript Philosophy

- Types should help you, not fight you
- Prefer union types over enums when possible
- Use branded types for domain primitives
- Leverage discriminated unions for state machines
- Type inference is powerful - use it, but don't abuse it

---

## Naming Conventions

### Files and Directories

```typescript
// Files: kebab-case
user-service.ts
api-client.ts
use-auth.ts

// Vue components: PascalCase
UserProfile.vue
LoginForm.vue
ProductCard.vue

// Test files: same as source + .test or .spec
user-service.test.ts
UserProfile.spec.ts

// Type definition files
types.ts
user.types.ts
api.types.ts
```

### Variables and Constants

```typescript
// camelCase for variables and functions
const userName = "John";
const totalAmount = 100.50;

function calculateTotalPrice(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// SCREAMING_SNAKE_CASE for true constants
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = "https://api.example.com";
const DEFAULT_TIMEOUT_MS = 5000;

// PascalCase for enums and their values
enum OrderStatus {
  Pending = "PENDING",
  Confirmed = "CONFIRMED",
  Shipped = "SHIPPED",
  Delivered = "DELIVERED",
}

// AVOID: Hungarian notation or type prefixes
const strName = "John";     // BAD
const iCount = 5;            // BAD
const bIsActive = true;      // BAD

// GOOD: Descriptive names without type prefix
const name = "John";
const count = 5;
const isActive = true;
```

### Types and Interfaces

```typescript
// PascalCase for types and interfaces
interface User {
  id: number;
  email: string;
  name: string;
}

type UserId = number;

type UserRole = "admin" | "user" | "guest";

// DO NOT use "I" prefix for interfaces
interface IUser {}  // BAD
interface User {}   // GOOD

// Use descriptive names that express purpose
interface Props {}              // BAD: Too generic
interface UserCardProps {}      // GOOD: Specific
interface TodoItemStorage {}    // GOOD: Expresses purpose

// Type aliases vs interfaces
type Point = { x: number; y: number };     // GOOD for unions, primitives
interface User { name: string; }           // GOOD for object shapes

// Prefer type for unions and complex types
type Result<T> = { success: true; data: T } | { success: false; error: string };
```

### Classes

```typescript
// PascalCase for class names
class UserService {
  private readonly repository: UserRepository;

  constructor(repository: UserRepository) {
    this.repository = repository;
  }

  async getUser(id: number): Promise<User> {
    return this.repository.findById(id);
  }
}

// Private fields with # (modern)
class Counter {
  #count = 0;

  increment(): void {
    this.#count++;
  }

  getCount(): number {
    return this.#count;
  }
}
```

### Functions

```typescript
// camelCase for function names
function calculateDiscount(price: number, rate: number): number {
  return price * (1 - rate);
}

// Arrow functions for callbacks
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);

// Named functions for top-level declarations
function processOrder(order: Order): void {
  // Implementation
}

// Arrow functions for methods when you need lexical this
class Component {
  private value = 10;

  // Arrow function preserves 'this'
  handleClick = (): void => {
    console.log(this.value);
  };
}
```

### Generics

```typescript
// Single letter for simple generics
function identity<T>(value: T): T {
  return value;
}

// Descriptive names for complex generics
function mapValues<TInput, TOutput>(
  items: TInput[],
  mapper: (item: TInput) => TOutput
): TOutput[] {
  return items.map(mapper);
}

// Common generic parameter names
// T - Type (default single generic)
// K - Key
// V - Value
// E - Element
// R - Return type
```

---

## Code Layout and Formatting

### Line Length

```typescript
// Prefer 80-100 characters per line
// Use Prettier default (80 characters)

// GOOD: Break long lines naturally
const result = calculateTotalPrice(
  items,
  taxRate,
  shippingCost
);

// GOOD: Object properties on separate lines
const user = {
  id: 1,
  email: "test@example.com",
  name: "Test User",
  role: "admin",
};
```

### Indentation

```typescript
// 2 spaces for indentation (TypeScript/JavaScript convention)
function example(): void {
  if (condition) {
    doSomething();
  }
}
```

### Semicolons

```typescript
// Always use semicolons (Prettier/ESLint default)
const value = 10;
const name = "John";

function greet(): void {
  console.log("Hello");
}
```

### Quotes

```typescript
// Use double quotes for strings (consistency with JSON)
const message = "Hello, World!";
const template = `Value: ${value}`;

// Single quotes acceptable if consistent across project
// Pick one and enforce with Prettier
```

### Braces

```typescript
// Always use braces, even for single-line blocks
if (condition) {
  doSomething();
}

// AVOID: Omitting braces
if (condition) doSomething();  // BAD

// Exception: Arrow functions with single expression
const double = (n: number) => n * 2;  // OK
```

### Object and Array Formatting

```typescript
// Trailing commas (better for diffs)
const items = [
  "first",
  "second",
  "third",  // Trailing comma
];

const config = {
  host: "localhost",
  port: 8080,
  timeout: 5000,  // Trailing comma
};

// Destructuring
const { name, email } = user;
const [first, second, ...rest] = array;
```

---

## Type Annotations

### Variable Type Annotations

```typescript
// Let TypeScript infer simple types
const count = 5;              // inferred as number
const name = "John";          // inferred as string
const isActive = true;        // inferred as boolean

// Explicit types for complex structures
const users: User[] = [];
const cache: Map<string, User> = new Map();
const config: Config = {
  host: "localhost",
  port: 8080,
};

// Explicit types when inference is unclear
let value: number | undefined;
const result: Promise<User> = fetchUser();
```

### Function Type Annotations

```typescript
// Always annotate function parameters and return types
function calculateTotal(
  price: number,
  quantity: number
): number {
  return price * quantity;
}

// Async functions return Promise
async function fetchUser(id: number): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}

// Void for functions without return value
function logMessage(message: string): void {
  console.log(message);
}

// Arrow function types
const add = (a: number, b: number): number => a + b;

type Calculator = (a: number, b: number) => number;
const multiply: Calculator = (a, b) => a * b;
```

### Union and Intersection Types

```typescript
// Union types for "or" relationships
type Result = Success | Failure;
type Id = number | string;

function display(value: string | number): void {
  console.log(value);
}

// Intersection types for "and" relationships
type Timestamped = { createdAt: Date; updatedAt: Date };
type User = { id: number; name: string } & Timestamped;

// Discriminated unions for state machines
type LoadingState =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: User }
  | { status: "error"; error: string };

function handleState(state: LoadingState): void {
  switch (state.status) {
    case "idle":
      break;
    case "loading":
      break;
    case "success":
      console.log(state.data);  // Type-safe access to data
      break;
    case "error":
      console.error(state.error);  // Type-safe access to error
      break;
  }
}
```

### Utility Types

```typescript
// Partial - all properties optional
type PartialUser = Partial<User>;
// { id?: number; name?: string; email?: string }

// Required - all properties required
type RequiredConfig = Required<Config>;

// Pick - select specific properties
type UserCredentials = Pick<User, "email" | "password">;

// Omit - exclude specific properties
type UserWithoutPassword = Omit<User, "password">;

// Record - key-value map
type ErrorMessages = Record<string, string>;

// Readonly - immutable properties
type ImmutableUser = Readonly<User>;

// ReturnType - extract return type
type FetchUserReturn = ReturnType<typeof fetchUser>;
// Promise<User>
```

### Type Guards

```typescript
// Type predicates
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function isUser(value: unknown): value is User {
  return (
    typeof value === "object" &&
    value !== null &&
    "id" in value &&
    "email" in value
  );
}

// Usage
function processValue(value: string | number): void {
  if (isString(value)) {
    console.log(value.toUpperCase());  // Type-safe
  } else {
    console.log(value.toFixed(2));     // Type-safe
  }
}
```

### Branded Types

```typescript
// Branded types for domain primitives
type UserId = number & { readonly __brand: "UserId" };
type Email = string & { readonly __brand: "Email" };

function createUserId(id: number): UserId {
  return id as UserId;
}

function createEmail(email: string): Email {
  if (!email.includes("@")) {
    throw new Error("Invalid email");
  }
  return email as Email;
}

// Type safety prevents mixing
function getUser(id: UserId): User {
  // Implementation
}

const id = 123;
getUser(id);  // Error: number is not assignable to UserId
getUser(createUserId(123));  // OK
```

---

## Import and Export Organization

### Import Order

```typescript
// 1. External dependencies
import { ref, computed, onMounted } from "vue";
import { useRouter } from "vue-router";
import axios from "axios";

// 2. Internal utilities and types
import type { User, Order } from "@/types";
import { formatDate, formatCurrency } from "@/utils";

// 3. Components
import UserCard from "@/components/UserCard.vue";
import LoginForm from "@/components/LoginForm.vue";

// 4. Styles (Vue SFC)
import "./styles.css";
```

### Import Styles

```typescript
// Named imports (preferred)
import { useState, useEffect } from "react";
import { useAuth, useCart } from "@/composables";

// Default imports
import axios from "axios";
import UserService from "@/services/user-service";

// Type-only imports (TypeScript 3.8+)
import type { User, Config } from "@/types";

// Namespace imports (when needed)
import * as userUtils from "@/utils/user";

// AVOID: Wildcard exports/imports
export * from "./user";  // BAD: Unclear what's exported
```

### Export Styles

```typescript
// Named exports (preferred for libraries)
export function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

export interface User {
  id: number;
  name: string;
}

// Default export (for main entry points)
export default class UserService {
  // Implementation
}

// Re-exporting
export { User } from "./user";
export type { Config } from "./config";
```

### Path Aliases

```typescript
// Use path aliases for cleaner imports
// tsconfig.json: "paths": { "@/*": ["src/*"] }

// GOOD: With alias
import { User } from "@/types/user";
import UserCard from "@/components/UserCard.vue";

// AVOID: Relative paths for distant files
import { User } from "../../../types/user";  // BAD
```

---

## Documentation Standards

### TSDoc Comments

```typescript
/**
 * Calculates the total price including tax and shipping.
 *
 * @param subtotal - Order subtotal before tax and shipping
 * @param taxRate - Tax rate as decimal (e.g., 0.08 for 8%)
 * @param shippingCost - Shipping cost in dollars
 * @returns Total price including all fees and taxes
 *
 * @example
 * ```typescript
 * const total = calculateTotal(100, 0.08, 10);
 * // Returns: 118
 * ```
 */
function calculateTotal(
  subtotal: number,
  taxRate: number,
  shippingCost: number
): number {
  return subtotal * (1 + taxRate) + shippingCost;
}
```

### Type Documentation

```typescript
/**
 * Represents a user in the system.
 *
 * @remarks
 * Users are identified by email and can have multiple roles.
 * The `createdAt` timestamp is set automatically during creation.
 */
interface User {
  /** Unique user identifier */
  id: number;

  /** User email address (must be unique) */
  email: string;

  /** Display name */
  name: string;

  /** User roles for authorization */
  roles: UserRole[];

  /** Account creation timestamp */
  createdAt: Date;
}
```

### Inline Comments

```typescript
// GOOD: Explain WHY, not WHAT
// Check cache first to avoid expensive API call
if (cache.has(userId)) {
  return cache.get(userId);
}

// Apply 10% discount for orders over $100 (marketing campaign)
if (order.total > 100) {
  order.discount = order.total * 0.10;
}

// BAD: Redundant comments
// Increment counter by 1
counter++;  // BAD: Obvious from code
```

---

## Error Handling

### Error Types

```typescript
// Custom error classes
class NotFoundError extends Error {
  constructor(resource: string, id: string | number) {
    super(`${resource} with ID ${id} not found`);
    this.name = "NotFoundError";
  }
}

class ValidationError extends Error {
  constructor(
    message: string,
    public readonly fields: Record<string, string>
  ) {
    super(message);
    this.name = "ValidationError";
  }
}

// Domain-specific errors
class UserNotFoundError extends NotFoundError {
  constructor(userId: number) {
    super("User", userId);
  }
}
```

### Try-Catch Patterns

```typescript
// GOOD: Specific error handling
async function fetchUser(id: number): Promise<User> {
  try {
    const response = await fetch(`/api/users/${id}`);

    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    if (error instanceof TypeError) {
      // Network error
      throw new Error("Network error occurred");
    }
    throw error;
  }
}

// GOOD: Type-safe error handling
function handleError(error: unknown): void {
  if (error instanceof ValidationError) {
    console.error("Validation failed:", error.fields);
  } else if (error instanceof Error) {
    console.error("Error:", error.message);
  } else {
    console.error("Unknown error:", error);
  }
}
```

### Result Type Pattern

```typescript
// Result type for explicit error handling
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function fetchUserSafe(id: number): Promise<Result<User>> {
  try {
    const user = await fetchUser(id);
    return { success: true, data: user };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error : new Error(String(error)),
    };
  }
}

// Usage
const result = await fetchUserSafe(123);
if (result.success) {
  console.log(result.data.name);  // Type-safe
} else {
  console.error(result.error.message);  // Type-safe
}
```

---

## Async/Await Patterns

### Async Function Best Practices

```typescript
// GOOD: Always use async/await with Promises
async function loadUserData(userId: number): Promise<UserData> {
  const user = await fetchUser(userId);
  const orders = await fetchOrders(userId);
  return { user, orders };
}

// GOOD: Parallel execution with Promise.all
async function loadUserDataParallel(userId: number): Promise<UserData> {
  const [user, orders] = await Promise.all([
    fetchUser(userId),
    fetchOrders(userId),
  ]);
  return { user, orders };
}

// AVOID: Mixing then/catch with async/await
async function badExample(): Promise<void> {
  const user = await fetchUser(1)
    .then(u => u)        // BAD: Mixing patterns
    .catch(e => null);   // BAD: Use try/catch instead
}
```

### Error Handling with Async

```typescript
// GOOD: Try-catch for async operations
async function processOrder(orderId: string): Promise<void> {
  try {
    const order = await fetchOrder(orderId);
    await validateOrder(order);
    await processPayment(order);
    await sendConfirmation(order);
  } catch (error) {
    console.error("Order processing failed:", error);
    throw error;
  }
}
```

---

## HTML and DOM Element Naming Conventions

This section defines naming standards for HTML elements, attributes, and test selectors to ensure consistency and improve testability with tools like Playwright.

### Test Data Attributes

```html
<!-- REQUIRED: Use data-testid for all interactive elements and key content -->
<!-- Pattern: data-testid="section-element-action" or "section-element" -->

<!-- GOOD: Descriptive, hierarchical test IDs -->
<button data-testid="login-form-submit-button">Login</button>
<input data-testid="login-form-email-input" type="email" />
<div data-testid="user-profile-avatar">...</div>
<span data-testid="order-total-amount">$100.00</span>

<!-- GOOD: List items with index or unique identifier -->
<li data-testid="product-list-item-1">Product 1</li>
<li data-testid="product-list-item-2">Product 2</li>
<!-- Or use dynamic IDs -->
<li :data-testid="`product-list-item-${product.id}`">{{ product.name }}</li>

<!-- BAD: Generic or non-descriptive test IDs -->
<button data-testid="btn1">Login</button>        <!-- BAD: Not descriptive -->
<input data-testid="input">                      <!-- BAD: Too generic -->
<div data-testid="container">...</div>           <!-- BAD: No context -->

<!-- BAD: Inconsistent naming patterns -->
<button data-testid="loginButton">Login</button>        <!-- BAD: camelCase -->
<button data-testid="login_button">Login</button>       <!-- BAD: snake_case -->
<button data-testid="login-form-submit-button">...</button> <!-- GOOD: kebab-case -->
```

### Test Data Attribute Naming Rules

```typescript
/**
 * Test ID Naming Pattern:
 * [section]-[component]-[element]-[descriptor?]
 *
 * Examples:
 * - login-form-submit-button
 * - user-profile-edit-button
 * - product-card-add-to-cart-button
 * - order-list-item-123
 * - search-results-loading-spinner
 */

// Use kebab-case for all test IDs
type TestIdPattern = `${string}-${string}` | `${string}-${string}-${string}`;

// Examples of good test IDs by element type:
const testIds = {
  // Buttons
  buttons: "section-action-button",           // e.g., "cart-checkout-button"

  // Form inputs
  inputs: "form-field-input",                 // e.g., "login-email-input"
  textareas: "form-field-textarea",           // e.g., "comment-body-textarea"
  selects: "form-field-select",               // e.g., "country-select"

  // Links
  links: "section-target-link",               // e.g., "nav-home-link"

  // Content
  headings: "section-heading",                // e.g., "user-profile-heading"
  text: "section-element-text",               // e.g., "order-total-text"

  // Containers
  containers: "section-container",            // e.g., "product-grid-container"
  cards: "section-type-card",                 // e.g., "user-profile-card"

  // Lists
  listItems: "list-item-id",                  // e.g., "todo-item-123"

  // Status indicators
  loaders: "section-loading-spinner",         // e.g., "orders-loading-spinner"
  errors: "section-error-message",            // e.g., "login-error-message"
  success: "section-success-message",         // e.g., "signup-success-message"

  // Modals and overlays
  modals: "section-modal",                    // e.g., "confirm-delete-modal"
  overlays: "section-overlay",                // e.g., "loading-overlay"
};
```

### ID Attributes

```html
<!-- Use IDs sparingly and follow kebab-case -->
<!-- Pattern: component-name-element-purpose -->

<!-- GOOD: Descriptive IDs for unique elements -->
<header id="main-header">...</header>
<nav id="primary-navigation">...</nav>
<form id="user-registration-form">...</form>
<dialog id="confirm-delete-modal">...</dialog>

<!-- GOOD: IDs for form labels and accessibility -->
<label for="email-input">Email</label>
<input id="email-input" type="email" />

<label for="country-select">Country</label>
<select id="country-select">...</select>

<!-- AVOID: IDs when classes or data attributes suffice -->
<div id="container1">...</div>           <!-- BAD: Use class or data-testid -->
<span id="text">Hello</span>             <!-- BAD: Too generic -->
```

### Class Attributes

```html
<!-- Use BEM (Block Element Modifier) or utility-first (Tailwind) approach -->

<!-- BEM Naming Pattern: block__element--modifier -->
<div class="user-card">
  <img class="user-card__avatar" src="..." />
  <h3 class="user-card__name">John Doe</h3>
  <p class="user-card__bio user-card__bio--truncated">...</p>
  <button class="user-card__action user-card__action--primary">Follow</button>
</div>

<!-- Tailwind Utility Classes (preferred for this project) -->
<div class="flex flex-col gap-4 p-6 bg-white rounded-lg shadow">
  <img class="w-16 h-16 rounded-full" src="..." />
  <h3 class="text-xl font-bold text-gray-900">John Doe</h3>
  <p class="text-sm text-gray-600 line-clamp-2">...</p>
  <button class="px-4 py-2 text-white bg-blue-600 rounded hover:bg-blue-700">
    Follow
  </button>
</div>

<!-- AVOID: Non-descriptive or inconsistent class names -->
<div class="box1">...</div>              <!-- BAD: Not descriptive -->
<div class="UserCard">...</div>          <!-- BAD: PascalCase for CSS -->
<div class="user_card">...</div>         <!-- BAD: snake_case for CSS -->
```

### ARIA and Accessibility Attributes

```html
<!-- REQUIRED: Include ARIA attributes for accessibility and testing -->

<!-- Buttons and interactive elements -->
<button
  data-testid="menu-toggle-button"
  aria-label="Toggle navigation menu"
  aria-expanded="false"
  aria-controls="main-menu"
>
  <span aria-hidden="true">☰</span>
</button>

<!-- Form inputs with labels -->
<label for="search-input" class="sr-only">Search products</label>
<input
  id="search-input"
  data-testid="header-search-input"
  type="search"
  aria-label="Search products"
  placeholder="Search..."
/>

<!-- Loading states -->
<div
  data-testid="products-loading-spinner"
  role="status"
  aria-live="polite"
  aria-busy="true"
>
  <span class="sr-only">Loading products...</span>
  <svg class="animate-spin" aria-hidden="true">...</svg>
</div>

<!-- Alerts and messages -->
<div
  data-testid="login-error-message"
  role="alert"
  aria-live="assertive"
  class="text-red-600"
>
  Invalid email or password
</div>

<!-- Modals and dialogs -->
<dialog
  id="confirm-delete-modal"
  data-testid="confirm-delete-modal"
  role="dialog"
  aria-labelledby="modal-title"
  aria-describedby="modal-description"
  aria-modal="true"
>
  <h2 id="modal-title">Confirm Deletion</h2>
  <p id="modal-description">Are you sure you want to delete this item?</p>
  <button data-testid="modal-cancel-button" aria-label="Cancel deletion">
    Cancel
  </button>
  <button data-testid="modal-confirm-button" aria-label="Confirm deletion">
    Delete
  </button>
</dialog>
```

### Vue 3 Component Data Attributes

```vue
<script setup lang="ts">
interface Props {
  userId: number;
  isActive?: boolean;
}

const props = defineProps<Props>();

// Computed test ID based on props
const testIdPrefix = computed(() => `user-${props.userId}`);
</script>

<template>
  <!-- Dynamic test IDs based on component state -->
  <div
    :data-testid="`${testIdPrefix}-card`"
    class="user-card"
  >
    <img
      :data-testid="`${testIdPrefix}-avatar`"
      :src="user.avatarUrl"
      :alt="`${user.name} avatar`"
    />

    <h3 :data-testid="`${testIdPrefix}-name`">
      {{ user.name }}
    </h3>

    <!-- Conditional test IDs -->
    <span
      v-if="isActive"
      data-testid="user-card-active-badge"
      class="badge-active"
    >
      Active
    </span>

    <!-- Interactive elements with clear test IDs -->
    <button
      :data-testid="`${testIdPrefix}-follow-button`"
      :aria-label="`Follow ${user.name}`"
      @click="handleFollow"
    >
      Follow
    </button>

    <button
      :data-testid="`${testIdPrefix}-message-button`"
      :aria-label="`Send message to ${user.name}`"
      @click="handleMessage"
    >
      Message
    </button>
  </div>
</template>
```

### Playwright Test Selector Helpers

```typescript
// test-helpers/selectors.ts

/**
 * Test selector builder for consistent Playwright queries.
 */
export class TestSelectors {
  /**
   * Get selector by test ID.
   */
  static byTestId(testId: string): string {
    return `[data-testid="${testId}"]`;
  }

  /**
   * Get selector for button by test ID.
   */
  static button(testId: string): string {
    return `button[data-testid="${testId}"]`;
  }

  /**
   * Get selector for input by test ID.
   */
  static input(testId: string): string {
    return `input[data-testid="${testId}"]`;
  }

  /**
   * Get selector for link by test ID.
   */
  static link(testId: string): string {
    return `a[data-testid="${testId}"]`;
  }

  /**
   * Get selector by role and name (accessibility-first).
   */
  static byRole(role: string, name?: string): string {
    return name
      ? `[role="${role}"][aria-label="${name}"]`
      : `[role="${role}"]`;
  }

  /**
   * Get selector for list item by index.
   */
  static listItem(listTestId: string, index: number): string {
    return `${this.byTestId(listTestId)} > [data-testid$="-item-${index}"]`;
  }
}

// Usage in Playwright tests
import { test, expect } from "@playwright/test";
import { TestSelectors } from "./test-helpers/selectors";

test("user can login", async ({ page }) => {
  await page.goto("/login");

  // Using test ID selectors
  await page.locator(TestSelectors.input("login-form-email-input"))
    .fill("user@example.com");

  await page.locator(TestSelectors.input("login-form-password-input"))
    .fill("password123");

  await page.locator(TestSelectors.button("login-form-submit-button"))
    .click();

  // Assert success
  await expect(
    page.locator(TestSelectors.byTestId("dashboard-welcome-message"))
  ).toBeVisible();
});

test("user can add product to cart", async ({ page }) => {
  await page.goto("/products");

  // Click on first product
  await page.locator(TestSelectors.byTestId("product-list-item-1"))
    .click();

  // Add to cart
  await page.locator(TestSelectors.button("product-detail-add-to-cart-button"))
    .click();

  // Verify cart count
  const cartCount = page.locator(TestSelectors.byTestId("header-cart-count"));
  await expect(cartCount).toHaveText("1");
});
```

### Form Element Naming Conventions

```html
<!-- Form container -->
<form
  id="user-registration-form"
  data-testid="registration-form"
  @submit.prevent="handleSubmit"
>
  <!-- Text input -->
  <div class="form-field">
    <label for="registration-email-input" class="form-label">
      Email Address
    </label>
    <input
      id="registration-email-input"
      data-testid="registration-form-email-input"
      type="email"
      name="email"
      aria-required="true"
      aria-describedby="email-error"
    />
    <span
      id="email-error"
      data-testid="registration-form-email-error"
      role="alert"
      aria-live="polite"
    >
      Please enter a valid email
    </span>
  </div>

  <!-- Password input with visibility toggle -->
  <div class="form-field">
    <label for="registration-password-input" class="form-label">
      Password
    </label>
    <div class="input-group">
      <input
        id="registration-password-input"
        data-testid="registration-form-password-input"
        :type="showPassword ? 'text' : 'password'"
        name="password"
        aria-required="true"
      />
      <button
        type="button"
        data-testid="registration-form-toggle-password-button"
        :aria-label="showPassword ? 'Hide password' : 'Show password'"
        @click="showPassword = !showPassword"
      >
        <span aria-hidden="true">{{ showPassword ? '👁️' : '🙈' }}</span>
      </button>
    </div>
  </div>

  <!-- Select dropdown -->
  <div class="form-field">
    <label for="registration-country-select" class="form-label">
      Country
    </label>
    <select
      id="registration-country-select"
      data-testid="registration-form-country-select"
      name="country"
      aria-required="true"
    >
      <option value="">Select a country</option>
      <option value="us">United States</option>
      <option value="uk">United Kingdom</option>
    </select>
  </div>

  <!-- Checkbox -->
  <div class="form-field">
    <label class="checkbox-label">
      <input
        id="registration-terms-checkbox"
        data-testid="registration-form-terms-checkbox"
        type="checkbox"
        name="terms"
        aria-required="true"
      />
      <span>I agree to the terms and conditions</span>
    </label>
  </div>

  <!-- Submit button -->
  <button
    type="submit"
    data-testid="registration-form-submit-button"
    :disabled="isSubmitting"
    :aria-busy="isSubmitting"
  >
    {{ isSubmitting ? 'Creating account...' : 'Create Account' }}
  </button>
</form>
```

### Navigation and Menu Elements

```html
<!-- Primary navigation -->
<nav
  id="primary-navigation"
  data-testid="primary-nav"
  aria-label="Primary navigation"
>
  <ul class="nav-list">
    <li>
      <a
        href="/"
        data-testid="nav-home-link"
        aria-current="page"
      >
        Home
      </a>
    </li>
    <li>
      <a
        href="/products"
        data-testid="nav-products-link"
      >
        Products
      </a>
    </li>
    <li>
      <a
        href="/about"
        data-testid="nav-about-link"
      >
        About
      </a>
    </li>
  </ul>
</nav>

<!-- User menu dropdown -->
<div
  class="user-menu"
  data-testid="user-menu"
>
  <button
    data-testid="user-menu-toggle-button"
    aria-expanded="false"
    aria-controls="user-menu-dropdown"
    aria-label="User menu"
  >
    {{ userName }}
  </button>

  <ul
    id="user-menu-dropdown"
    data-testid="user-menu-dropdown"
    class="dropdown-menu"
    :aria-hidden="!isMenuOpen"
  >
    <li>
      <a
        href="/profile"
        data-testid="user-menu-profile-link"
      >
        Profile
      </a>
    </li>
    <li>
      <a
        href="/settings"
        data-testid="user-menu-settings-link"
      >
        Settings
      </a>
    </li>
    <li>
      <button
        data-testid="user-menu-logout-button"
        @click="handleLogout"
      >
        Logout
      </button>
    </li>
  </ul>
</div>
```

### Best Practices Summary

1. **Always use `data-testid`** for elements that need to be tested
2. **Use kebab-case** for all test IDs, IDs, and CSS classes (except Tailwind)
3. **Be descriptive and hierarchical**: `section-component-element-action`
4. **Include ARIA attributes** for accessibility and testing
5. **Avoid generic names** like "button1", "container", "text"
6. **Use dynamic test IDs** for list items with unique identifiers
7. **Combine with ARIA roles** for more robust selectors
8. **Document test ID patterns** in component files
9. **Create selector helpers** to avoid hardcoding selectors in tests
10. **Prefer accessibility attributes** (`role`, `aria-label`) over presentational selectors

---

## Vue 3 Specific Guidelines

### Composition API

```typescript
// GOOD: Use Composition API with <script setup>
<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import type { User } from "@/types";

// Props with types
interface Props {
  userId: number;
  showDetails?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  showDetails: false,
});

// Emits with types
interface Emits {
  (e: "update", user: User): void;
  (e: "delete", userId: number): void;
}

const emit = defineEmits<Emits>();

// Reactive state
const user = ref<User | null>(null);
const loading = ref(false);

// Computed properties
const displayName = computed(() => {
  return user.value ? user.value.name : "Unknown";
});

// Lifecycle hooks
onMounted(async () => {
  loading.value = true;
  try {
    user.value = await fetchUser(props.userId);
  } finally {
    loading.value = false;
  }
});

// Methods
function handleUpdate(): void {
  if (user.value) {
    emit("update", user.value);
  }
}
</script>

<template>
  <div v-if="loading">Loading...</div>
  <div v-else-if="user">
    <h2>{{ displayName }}</h2>
    <button @click="handleUpdate">Update</button>
  </div>
</template>
```

### Composables

```typescript
// composables/useAuth.ts
import { ref, computed } from "vue";
import type { User } from "@/types";

export function useAuth() {
  const user = ref<User | null>(null);
  const loading = ref(false);

  const isAuthenticated = computed(() => user.value !== null);
  const isAdmin = computed(() => user.value?.role === "admin");

  async function login(email: string, password: string): Promise<void> {
    loading.value = true;
    try {
      user.value = await authService.login(email, password);
    } finally {
      loading.value = false;
    }
  }

  function logout(): void {
    user.value = null;
  }

  return {
    user: readonly(user),
    loading: readonly(loading),
    isAuthenticated,
    isAdmin,
    login,
    logout,
  };
}
```

### Pinia Stores

```typescript
// stores/user.ts
import { defineStore } from "pinia";
import type { User } from "@/types";

interface UserState {
  users: User[];
  currentUser: User | null;
  loading: boolean;
}

export const useUserStore = defineStore("user", {
  state: (): UserState => ({
    users: [],
    currentUser: null,
    loading: false,
  }),

  getters: {
    isAuthenticated: (state): boolean => state.currentUser !== null,

    getUserById: (state) => {
      return (id: number): User | undefined => {
        return state.users.find(u => u.id === id);
      };
    },
  },

  actions: {
    async fetchUsers(): Promise<void> {
      this.loading = true;
      try {
        this.users = await userService.fetchAll();
      } finally {
        this.loading = false;
      }
    },

    async login(email: string, password: string): Promise<void> {
      this.currentUser = await authService.login(email, password);
    },

    logout(): void {
      this.currentUser = null;
    },
  },
});
```

---

## Testing Conventions

### Test File Structure

```typescript
// user-service.test.ts
import { describe, it, expect, beforeEach, vi } from "vitest";
import { UserService } from "./user-service";

describe("UserService", () => {
  let service: UserService;
  let mockRepository: MockUserRepository;

  beforeEach(() => {
    mockRepository = new MockUserRepository();
    service = new UserService(mockRepository);
  });

  describe("getUser", () => {
    it("should return user when found", async () => {
      const user = { id: 1, name: "John", email: "john@example.com" };
      mockRepository.findById.mockResolvedValue(user);

      const result = await service.getUser(1);

      expect(result).toEqual(user);
      expect(mockRepository.findById).toHaveBeenCalledWith(1);
    });

    it("should throw error when user not found", async () => {
      mockRepository.findById.mockResolvedValue(null);

      await expect(service.getUser(999)).rejects.toThrow("User not found");
    });
  });
});
```

### Component Testing (Vue)

```typescript
// UserCard.spec.ts
import { mount } from "@vue/test-utils";
import { describe, it, expect } from "vitest";
import UserCard from "./UserCard.vue";

describe("UserCard", () => {
  it("renders user name correctly", () => {
    const wrapper = mount(UserCard, {
      props: {
        user: {
          id: 1,
          name: "John Doe",
          email: "john@example.com",
        },
      },
    });

    expect(wrapper.text()).toContain("John Doe");
  });

  it("emits delete event when delete button clicked", async () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: 1, name: "John", email: "john@example.com" } },
    });

    await wrapper.find("[data-test='delete-button']").trigger("click");

    expect(wrapper.emitted("delete")).toBeTruthy();
    expect(wrapper.emitted("delete")?.[0]).toEqual([1]);
  });
});
```

---

## Tools and Enforcement

### TypeScript Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "moduleResolution": "bundler",
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### ESLint Configuration

```javascript
// .eslintrc.cjs
module.exports = {
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:vue/vue3-recommended",
    "prettier",
  ],
  parser: "vue-eslint-parser",
  parserOptions: {
    parser: "@typescript-eslint/parser",
    ecmaVersion: 2020,
    sourceType: "module",
  },
  rules: {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": "error",
    "no-console": ["warn", { allow: ["warn", "error"] }],
  },
};
```

### Prettier Configuration

```json
// .prettierrc
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": false,
  "printWidth": 80,
  "tabWidth": 2,
  "arrowParens": "avoid"
}
```

### Running Tools

```bash
# Type check
npm run type-check  # tsc --noEmit

# Lint
npm run lint        # eslint . --ext .ts,.tsx,.vue
npm run lint:fix    # eslint . --ext .ts,.tsx,.vue --fix

# Format
npm run format      # prettier --write \"src/**/*.{ts,tsx,vue}\"

# Test
npm run test        # vitest
npm run test:coverage  # vitest --coverage

# All checks
npm run type-check && npm run lint && npm run test
```

---

## Enforcement

- All code MUST pass TypeScript compiler in strict mode
- All code MUST pass ESLint with zero warnings
- All code MUST be formatted with Prettier
- Pre-commit hooks SHOULD be enabled to enforce standards automatically
- CI pipeline MUST fail if any tool reports errors
- Code reviews MUST verify adherence to these standards
- Test coverage MUST meet thresholds defined in constitution (40%+ for prototypes, 60%+ for production)

---

**Version History**:
- 1.1.0 (2025-10-26): Added comprehensive HTML and DOM Element Naming Conventions section for Playwright testing support
- 1.0.0 (2025-10-26): Initial release
