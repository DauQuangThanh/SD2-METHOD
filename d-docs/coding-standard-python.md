# Python Coding Standards

**Version**: 1.0.0
**Last Updated**: 2025-10-26
**Applies To**: Python 3.12+ projects (FastAPI, async applications)

---

## Table of Contents

1. [General Principles](#general-principles)
2. [Naming Conventions](#naming-conventions)
3. [Code Layout and Formatting](#code-layout-and-formatting)
4. [Import Organization](#import-organization)
5. [Type Annotations](#type-annotations)
6. [Documentation Standards](#documentation-standards)
7. [Error Handling](#error-handling)
8. [Async/Await Conventions](#asyncawait-conventions)
9. [Testing Conventions](#testing-conventions)
10. [Hexagonal Architecture Guidelines](#hexagonal-architecture-guidelines)
11. [Tools and Enforcement](#tools-and-enforcement)

---

## General Principles

### 1. Follow PEP 8

All Python code MUST adhere to [PEP 8](https://peps.python.org/pep-0008/) style guide. Code readability is paramount - code is read much more often than it is written.

### 2. Code Quality Tenets

- **Explicit is better than implicit**: Avoid magic behavior
- **Readability counts**: Clear code beats clever code
- **Simple is better than complex**: Prefer straightforward solutions
- **Flat is better than nested**: Avoid deep nesting (max 3-4 levels)

### 3. Python Zen

```python
import this  # The Zen of Python - guiding philosophy
```

---

## Naming Conventions

### Files and Modules

```python
# Module names: lowercase with underscores
user_repository.py
order_service.py
api_schemas.py

# Package names: lowercase, no underscores preferred
domain/
adapters/
infrastructure/
```

### Variables and Functions

```python
# snake_case for variables and functions
user_name = "John"
total_amount = 100.50

def calculate_total_price(items: list[Item]) -> Decimal:
    """Calculate total price of items."""
    pass

def get_user_by_id(user_id: int) -> User | None:
    """Retrieve user by ID. Returns None if not found."""
    pass
```

### Classes

```python
# PascalCase for class names
class UserRepository:
    """Repository for user data access."""
    pass

class OrderService:
    """Service for order business logic."""
    pass

class HTTPAdapter:
    """Adapter for HTTP communication."""
    pass
```

### Constants

```python
# UPPERCASE with underscores for constants
MAX_RETRY_ATTEMPTS = 3
DEFAULT_TIMEOUT_SECONDS = 30
API_VERSION = "v1"
DATABASE_URL = "postgresql://localhost/db"
```

### Private/Protected Members

```python
class UserService:
    def __init__(self):
        self._internal_state = {}  # Protected (convention only)
        self.__private_data = []   # Name mangling applied

    def public_method(self):
        """Public method."""
        pass

    def _protected_method(self):
        """Protected method (convention only)."""
        pass

    def __private_method(self):
        """Private method with name mangling."""
        pass
```

### Special Names

```python
# Avoid single character names except for:
# - Counters: i, j, k in loops
# - Exceptions: e in except clauses
# - File handles: f in with statements

# NEVER use these single characters:
# l (lowercase L) - confusing with 1
# O (uppercase O) - confusing with 0
# I (uppercase I) - confusing with 1

# Magic methods (dunder methods)
class User:
    def __init__(self, name: str):
        self.name = name

    def __str__(self) -> str:
        return f"User({self.name})"

    def __repr__(self) -> str:
        return f"User(name={self.name!r})"
```

### Naming by Intent

```python
# BAD: Non-descriptive names
def f(x, y):
    return x + y

data = []
temp = calculate()

# GOOD: Descriptive names
def calculate_total_price(base_price: Decimal, tax_rate: Decimal) -> Decimal:
    return base_price * (1 + tax_rate)

user_orders = []
calculated_discount = calculate_discount()
```

---

## Code Layout and Formatting

### Line Length

```python
# Maximum line length: 88 characters (Black default)
# PEP 8 recommends 79, but 88 is modern standard

# For docstrings and comments: 72 characters
```

### Indentation

```python
# 4 spaces per indentation level (NEVER tabs)

def long_function_name(
    var_one: str,
    var_two: int,
    var_three: dict[str, Any],
) -> bool:
    """Function with many parameters."""
    print(var_one)
    return True

# Hanging indents
result = some_function_that_takes_arguments(
    argument_one,
    argument_two,
    argument_three,
    argument_four,
)
```

### Blank Lines

```python
# 2 blank lines before top-level class/function definitions


class FirstClass:
    """First class."""
    pass


class SecondClass:
    """Second class."""
    pass


def top_level_function():
    """Top level function."""
    pass


# 1 blank line between methods within a class
class MyClass:
    def first_method(self):
        pass

    def second_method(self):
        pass
```

### Whitespace

```python
# BAD: Extra whitespace
spam( ham[ 1 ], { eggs: 2 } )
if x == 4 : print x , y ; x , y = y , x

# GOOD: Proper whitespace
spam(ham[1], {eggs: 2})
if x == 4:
    print(x, y)
    x, y = y, x

# Operators
i = i + 1
submitted += 1
x = x*2 - 1
hypot2 = x*x + y*y
c = (a+b) * (a-b)
```

### String Quotes

```python
# Use double quotes for strings, single quotes for dict keys
message = "Hello, World!"
sql_query = "SELECT * FROM users WHERE id = %s"

# Use single quotes for dict keys (optional consistency choice)
user_data = {"name": "John", "age": 30}

# Triple double quotes for docstrings
def example():
    """This is a docstring."""
    pass
```

---

## Import Organization

### Import Order

```python
# 1. Standard library imports
import json
import os
from datetime import datetime
from typing import Any

# 2. Related third-party imports
import fastapi
from pydantic import BaseModel
from sqlalchemy import Column, Integer, String

# 3. Local application imports
from domain.entities.user import User
from domain.repositories.user_repository import UserRepository
from adapters.persistence.models import UserModel
```

### Import Style

```python
# GOOD: Absolute imports
from domain.entities.user import User
from application.use_cases.create_user import CreateUserUseCase

# AVOID: Relative imports (except within same package)
from ..entities.user import User  # OK within domain package
from ...domain.entities.user import User  # BAD: Too many levels

# GOOD: Multiple imports on separate lines for clarity
from domain.entities import User
from domain.entities import Order
from domain.entities import Product

# GOOD: Or use grouped import for related items
from domain.entities import (
    User,
    Order,
    Product,
)

# BAD: Star imports (except in __init__.py for re-exporting)
from domain.entities import *  # Avoid
```

### Import Aliases

```python
# Use standard aliases
import numpy as np
import pandas as pd

# Avoid custom aliases unless necessary for clarity
from domain.repositories.user_repository import UserRepository as UserRepo  # BAD
from domain.repositories.user_repository import UserRepository  # GOOD

# Use aliases to resolve naming conflicts
from domain.entities.user import User as DomainUser
from adapters.persistence.models import User as UserModel
```

---

## Type Annotations

### Function Annotations

```python
from typing import Any
from collections.abc import Sequence

# REQUIRED: All public functions must have type annotations
def calculate_discount(
    price: Decimal,
    discount_rate: float,
) -> Decimal:
    """Calculate discounted price."""
    return price * Decimal(1 - discount_rate)

# Use None for functions without return value
def log_message(message: str) -> None:
    """Log a message."""
    print(message)

# Use modern union syntax (Python 3.10+)
def get_user(user_id: int) -> User | None:
    """Get user by ID or None if not found."""
    pass

# Use Sequence for read-only sequences
def process_items(items: Sequence[Item]) -> list[Result]:
    """Process items and return results."""
    return [process_item(item) for item in items]
```

### Variable Annotations

```python
# Annotate complex types
user_cache: dict[int, User] = {}
active_sessions: set[str] = set()
response_queue: list[Response] = []

# Type aliases for complex types
UserId = int
UserCache = dict[UserId, User]

cache: UserCache = {}
```

### Generic Types

```python
from typing import TypeVar, Generic

T = TypeVar("T")

class Repository(Generic[T]):
    """Generic repository interface."""

    def get_by_id(self, id: int) -> T | None:
        """Get entity by ID."""
        pass

    def save(self, entity: T) -> None:
        """Save entity."""
        pass
```

### Protocol Classes (Structural Subtyping)

```python
from typing import Protocol

class HasName(Protocol):
    """Protocol for objects with a name attribute."""
    name: str

def greet(obj: HasName) -> str:
    """Greet any object with a name."""
    return f"Hello, {obj.name}!"
```

---

## Documentation Standards

### Module Docstrings

```python
"""User repository module.

This module contains the implementation of UserRepository which provides
data access operations for User entities.

Typical usage example:
    repository = UserRepository(db_session)
    user = repository.get_by_id(123)
"""
```

### Function Docstrings

```python
def calculate_shipping_cost(
    weight: Decimal,
    distance: int,
    express: bool = False,
) -> Decimal:
    """Calculate shipping cost based on weight and distance.

    Args:
        weight: Package weight in kilograms.
        distance: Shipping distance in kilometers.
        express: Whether to use express shipping. Defaults to False.

    Returns:
        Shipping cost in USD.

    Raises:
        ValueError: If weight is negative or zero.
        ValueError: If distance is negative.

    Example:
        >>> calculate_shipping_cost(Decimal("2.5"), 100)
        Decimal('15.50')
        >>> calculate_shipping_cost(Decimal("2.5"), 100, express=True)
        Decimal('25.50')
    """
    if weight <= 0:
        raise ValueError("Weight must be positive")
    if distance < 0:
        raise ValueError("Distance cannot be negative")

    base_cost = weight * Decimal("5.0") + distance * Decimal("0.10")
    return base_cost * Decimal("1.5") if express else base_cost
```

### Class Docstrings

```python
class UserService:
    """Service for user-related business logic.

    This service coordinates user operations including creation, updates,
    and authentication. It depends on UserRepository for data persistence.

    Attributes:
        repository: User data repository.
        logger: Logger instance.

    Example:
        >>> service = UserService(repository, logger)
        >>> user = service.create_user("john@example.com", "password")
    """

    def __init__(
        self,
        repository: UserRepository,
        logger: Logger,
    ) -> None:
        """Initialize UserService.

        Args:
            repository: User data repository.
            logger: Logger instance.
        """
        self.repository = repository
        self.logger = logger
```

### Inline Comments

```python
# GOOD: Explain WHY, not WHAT
# Check cache before expensive DB query to improve performance
if user_id in cache:
    return cache[user_id]

# BAD: Redundant comment explaining obvious code
# Increment counter by 1
counter += 1

# GOOD: Document complex logic or non-obvious behavior
# Apply discount only if order total exceeds threshold AND
# customer has no previous returns (fraud prevention)
if order.total > DISCOUNT_THRESHOLD and not customer.has_returns():
    order.apply_discount()
```

---

## Error Handling

### Exception Handling

```python
# Be specific with exception types
try:
    user = repository.get_by_id(user_id)
except UserNotFoundError as e:
    logger.error(f"User {user_id} not found: {e}")
    raise HTTPException(status_code=404, detail="User not found")
except DatabaseError as e:
    logger.error(f"Database error: {e}")
    raise HTTPException(status_code=500, detail="Internal server error")

# AVOID: Bare except
try:
    risky_operation()
except:  # BAD: Catches everything including KeyboardInterrupt
    pass

# AVOID: Catching Exception without re-raising
try:
    operation()
except Exception:  # BAD: Silently swallowing errors
    pass

# GOOD: Log and re-raise or handle appropriately
try:
    operation()
except Exception as e:
    logger.exception("Operation failed")
    raise
```

### Custom Exceptions

```python
# Domain exceptions in domain layer
class DomainError(Exception):
    """Base exception for domain errors."""
    pass

class UserNotFoundError(DomainError):
    """Raised when user is not found."""

    def __init__(self, user_id: int):
        self.user_id = user_id
        super().__init__(f"User with ID {user_id} not found")

class InvalidEmailError(DomainError):
    """Raised when email is invalid."""
    pass

# Use custom exceptions
def get_user(user_id: int) -> User:
    user = repository.find_by_id(user_id)
    if user is None:
        raise UserNotFoundError(user_id)
    return user
```

### Context Managers

```python
# GOOD: Always use context managers for resources
with open("file.txt") as f:
    content = f.read()

# For database sessions
async with db_session() as session:
    user = await session.get(User, user_id)
    await session.commit()
```

---

## Async/Await Conventions

### Async Function Naming

```python
# Name async functions clearly
async def fetch_user_data(user_id: int) -> UserData:
    """Fetch user data asynchronously."""
    pass

async def send_notification(user: User, message: str) -> None:
    """Send notification asynchronously."""
    pass
```

### Async Best Practices

```python
# GOOD: Use async/await consistently
async def process_order(order_id: int) -> Order:
    order = await repository.get_by_id(order_id)
    await payment_service.process_payment(order)
    await notification_service.send_confirmation(order)
    return order

# GOOD: Use asyncio.gather for concurrent operations
async def fetch_user_details(user_id: int) -> UserDetails:
    user, orders, preferences = await asyncio.gather(
        user_repository.get_by_id(user_id),
        order_repository.get_by_user_id(user_id),
        preference_repository.get_by_user_id(user_id),
    )
    return UserDetails(user, orders, preferences)

# AVOID: Blocking calls in async functions
async def bad_example():
    time.sleep(1)  # BAD: Blocks event loop
    await asyncio.sleep(1)  # GOOD: Non-blocking
```

---

## Testing Conventions

### Test File Organization

```python
# tests/unit/domain/test_user_entity.py
# tests/integration/adapters/test_user_repository.py
# tests/e2e/test_user_registration_flow.py
```

### Test Function Naming

```python
# Pattern: test_<unit>_<scenario>_<expected_behavior>

def test_user_entity_creation_with_valid_data_succeeds():
    """Test that User entity is created successfully with valid data."""
    user = User(email="test@example.com", name="Test User")
    assert user.email == "test@example.com"

def test_calculate_discount_with_zero_rate_returns_original_price():
    """Test discount calculation with zero rate."""
    price = Decimal("100.00")
    result = calculate_discount(price, 0.0)
    assert result == price

def test_user_repository_get_by_id_with_missing_user_returns_none():
    """Test that repository returns None for non-existent user."""
    repository = UserRepository(db_session)
    user = repository.get_by_id(999999)
    assert user is None
```

### Test Structure (Arrange-Act-Assert)

```python
def test_order_service_create_order_with_valid_data():
    # Arrange
    user = User(email="test@example.com")
    items = [Item(product_id=1, quantity=2)]
    service = OrderService(repository, payment_gateway)

    # Act
    order = service.create_order(user, items)

    # Assert
    assert order.user == user
    assert len(order.items) == 1
    assert order.status == OrderStatus.PENDING
```

### Fixtures and Mocks

```python
import pytest
from unittest.mock import Mock, patch

@pytest.fixture
def user():
    """Fixture for test user."""
    return User(id=1, email="test@example.com", name="Test")

@pytest.fixture
def mock_repository():
    """Fixture for mocked repository."""
    return Mock(spec=UserRepository)

def test_user_service_with_mock_repository(mock_repository):
    """Test user service with mocked repository."""
    mock_repository.get_by_id.return_value = User(id=1, email="test@example.com")

    service = UserService(mock_repository)
    user = service.get_user(1)

    assert user.id == 1
    mock_repository.get_by_id.assert_called_once_with(1)
```

---

## Hexagonal Architecture Guidelines

### Domain Layer (Pure Python)

```python
# domain/entities/user.py
# MUST NOT import FastAPI, SQLAlchemy, or any framework

from dataclasses import dataclass
from datetime import datetime

@dataclass
class User:
    """User entity - pure domain object."""

    id: int | None
    email: str
    name: str
    created_at: datetime

    def change_email(self, new_email: str) -> None:
        """Change user email with validation."""
        if not self._is_valid_email(new_email):
            raise InvalidEmailError(new_email)
        self.email = new_email

    @staticmethod
    def _is_valid_email(email: str) -> bool:
        """Validate email format."""
        return "@" in email and "." in email.split("@")[1]
```

### Repository Interfaces (Ports)

```python
# domain/repositories/user_repository.py
from abc import ABC, abstractmethod
from domain.entities.user import User

class UserRepository(ABC):
    """User repository interface (port)."""

    @abstractmethod
    async def get_by_id(self, user_id: int) -> User | None:
        """Get user by ID."""
        pass

    @abstractmethod
    async def save(self, user: User) -> User:
        """Save user entity."""
        pass

    @abstractmethod
    async def delete(self, user_id: int) -> None:
        """Delete user by ID."""
        pass
```

### Adapter Implementation

```python
# adapters/persistence/repositories/user_repository_impl.py
from sqlalchemy.ext.asyncio import AsyncSession
from domain.repositories.user_repository import UserRepository
from domain.entities.user import User
from adapters.persistence.models.user_model import UserModel

class UserRepositoryImpl(UserRepository):
    """SQLAlchemy implementation of UserRepository."""

    def __init__(self, session: AsyncSession):
        self._session = session

    async def get_by_id(self, user_id: int) -> User | None:
        """Get user by ID from database."""
        model = await self._session.get(UserModel, user_id)
        return self._to_entity(model) if model else None

    async def save(self, user: User) -> User:
        """Save user to database."""
        model = self._to_model(user)
        self._session.add(model)
        await self._session.flush()
        return self._to_entity(model)

    @staticmethod
    def _to_entity(model: UserModel) -> User:
        """Convert model to entity."""
        return User(
            id=model.id,
            email=model.email,
            name=model.name,
            created_at=model.created_at,
        )

    @staticmethod
    def _to_model(entity: User) -> UserModel:
        """Convert entity to model."""
        return UserModel(
            id=entity.id,
            email=entity.email,
            name=entity.name,
            created_at=entity.created_at,
        )
```

### Dependency Injection

```python
# infrastructure/di/container.py
from dependency_injector import containers, providers
from adapters.persistence.repositories.user_repository_impl import UserRepositoryImpl

class Container(containers.DeclarativeContainer):
    """Dependency injection container."""

    config = providers.Configuration()

    db_session = providers.Singleton(
        create_async_session,
        database_url=config.database_url,
    )

    user_repository = providers.Factory(
        UserRepositoryImpl,
        session=db_session,
    )

    user_service = providers.Factory(
        UserService,
        repository=user_repository,
    )
```

---

## Tools and Enforcement

### Required Tools

```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py312']

[tool.isort]
profile = "black"
line_length = 88

[tool.mypy]
python_version = "3.12"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "B", "C4", "UP"]
ignore = []

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = "test_*.py"
python_functions = "test_*"
```

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.10.0
    hooks:
      - id: black

  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.0
    hooks:
      - id: ruff

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.13.0
    hooks:
      - id: mypy
```

### Running Tools

```bash
# Format code
black src/ tests/
isort src/ tests/

# Lint code
ruff check src/ tests/
mypy src/

# Run tests with coverage
pytest --cov=src --cov-report=html --cov-report=term

# All checks in one command
black src/ && isort src/ && ruff check src/ && mypy src/ && pytest
```

---

## Enforcement

- All code MUST pass `black`, `isort`, `ruff`, and `mypy` checks before commit
- Pre-commit hooks SHOULD be enabled to enforce standards automatically
- CI pipeline MUST fail if any tool reports errors
- Code reviews MUST verify adherence to these standards
- Test coverage MUST meet thresholds defined in constitution (70%+ domain, 50%+ adapters for PoC)

---

**Version History**:
- 1.0.0 (2025-10-26): Initial release
