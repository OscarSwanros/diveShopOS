# Getting Started

## Prerequisites

- Ruby 3.3.6
- PostgreSQL 17
- Node.js (for asset compilation)

## Setup

```bash
# Clone the repository
git clone <repo-url>
cd vamosabucear

# Install dependencies and set up database
bin/setup

# Start development server
bin/dev
```

## Development Commands

| Command | Purpose |
|---------|---------|
| `bin/dev` | Start dev server (web + background jobs) |
| `bin/rails test` | Run test suite |
| `bin/rubocop` | Run linter |
| `bin/ci` | Run all CI checks |
| `bin/rails db:migrate` | Run pending migrations |
| `bin/rails console` | Open Rails console |

## Project Organization

DiveShopOS is organized around business domains. See [Domain Module Index](../Domains/README.md) for the full list.

Key directories:
- `app/models/` -- Domain models, all scoped to Organization
- `app/controllers/` -- RESTful controllers
- `app/services/` -- Service objects organized by domain
- `app/policies/` -- Pundit authorization policies
- `Documentation/` -- All project documentation
- `test/` -- Minitest tests

## Key Concepts

1. **Multi-tenancy**: All data belongs to an Organization. Always scope queries.
2. **Safety gates**: Business rules enforced as service objects. See CLAUDE.md.
3. **Hotwire**: Turbo Frames for partial updates, Stimulus for JS behavior.
4. **UUID keys**: All tables use UUID primary keys.
