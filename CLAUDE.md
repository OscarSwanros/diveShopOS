# DiveShopOS

**The operating system for dive shops and schools.**

DiveShopOS is a web-based platform that manages all aspects of running a dive operation: teaching courses, scheduling excursions, tracking inventory, managing customers, and ensuring safety compliance. Built with Ruby on Rails 8.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Ruby 3.3.6 |
| Framework | Rails 8.1.2 |
| Database | PostgreSQL 17 (all environments) |
| Frontend | Hotwire (Turbo + Stimulus), Tailwind CSS |
| Background Jobs | Solid Queue |
| Caching | Solid Cache |
| WebSockets | Solid Cable |
| File Storage | Active Storage |
| Authentication | `has_secure_password` (Rails built-in) |
| Authorization | Pundit |
| Deployment | Kamal + Docker |
| CI | GitHub Actions |
| Primary Keys | UUIDs |

## Project Structure

```
app/
  models/              # Domain models (Organization-scoped)
  controllers/         # RESTful controllers
  views/               # ERB templates with Turbo Frames
  services/            # Service objects by domain namespace
  jobs/                # Background jobs by domain namespace
  policies/            # Pundit authorization policies
config/                # Rails configuration
db/                    # Migrations and schema
Documentation/         # All project documentation
  Architecture/        # System architecture, DB design, Rails conventions
  Design/              # UI design system, philosophy
  Domains/             # Domain module documentation
  Planning/            # Roadmap, decisions
  Release/             # Changelog
  Onboarding/          # Developer setup, module development guides
test/                  # Minitest tests
.claude/agents/        # AI agent configurations
```

## Domain Modules

DiveShopOS is organized around business domains using Rails namespaces. Each domain owns its models, controllers, views, services, and jobs.

### Tier 1 -- MVP
| Domain | Namespace | Purpose |
|--------|-----------|---------|
| Core | `--` (root) | Authentication, Organization (tenant), User |
| Customers | `Customers::` | Diver profiles, certifications, medical records, waivers |
| Staff | `Staff::` | Instructors, divemasters, ratings, availability |
| Excursions | `Excursions::` | Trip scheduling, dive sites, manifests, participants |
| Bookings | `Bookings::` | Reservations, deposits, payments, cancellations |

### Tier 2 -- Core Growth
| Domain | Namespace | Purpose |
|--------|-----------|---------|
| Courses | `Courses::` | Course catalog, enrollments, progress, certifications |
| Equipment | `Equipment::` | Rental fleet, retail inventory, service tracking |
| Compliance | `Compliance::` | Waivers, medical clearance, incident reports |
| Sites | `Sites::` | Dive site database, conditions, access requirements |

### Tier 3 -- Later
| Domain | Namespace | Purpose |
|--------|-----------|---------|
| Billing | `Billing::` | Invoices, payments, commissions, multi-currency |
| Notifications | `Notifications::` | Automated reminders, confirmations |
| Reporting | `Reporting::` | Dashboards, analytics, capacity reports |

## Multi-Tenancy

All data is scoped to an Organization via `organization_id` (row-level scoping). Every model that holds business data belongs to an Organization. Always scope queries through the current organization.

## Safety Gates

The core differentiator. These business rules are enforced as explicit, testable service objects -- never model callbacks:

1. **Certification gate**: Cannot add diver to activity exceeding their cert level
2. **Instructor rating gate**: Cannot assign instructor without active rating for course/agency
3. **Medical fitness gate**: Expired/uncleared medical blocks water activities
4. **Waiver gate**: No valid waiver = no water activity
5. **Equipment service gate**: Life-support gear overdue for service is blocked from rental
6. **Capacity gate**: Boat capacity and instructor ratios are hard limits
7. **Age gate**: Minimum age requirements per course/agency

All safety gates are auditable and override-able by authorized staff with a documented reason.

## Development Conventions

### Code Style
- Follow Rails Omakase Ruby style (`rubocop-rails-omakase`)
- `frozen_string_literal: true` in all Ruby files
- Prefer keyword arguments for methods with more than 2 parameters
- Use `Time.current` and `Date.current`, not `Time.now` and `Date.today`
- Name things based on the dive shop domain language

### Testing
- Minitest with fixtures
- Test safety gates exhaustively (happy path + every rejection reason)
- System tests with Capybara for critical workflows
- Run tests: `bin/rails test`

### Database
- UUID primary keys on all tables
- Soft deletes on all customer-facing data (certifications, medical records, dive data)
- Database-level constraints alongside ActiveRecord validations for data integrity
- All tables with business data include `organization_id`

### Frontend
- Tailwind CSS utility classes (no arbitrary values)
- Turbo Frames for partial page updates
- Turbo Streams for real-time updates
- Stimulus controllers for JavaScript behavior
- Progressive enhancement: core functionality works without JS
- All strings use `I18n.t()` for localization

### Services & Jobs
- Service objects in `app/services/<domain>/` with a single `call` method
- Background jobs in `app/jobs/<domain>/`, always idempotent
- Use Solid Queue (already configured)

### Authorization
- Pundit policies in `app/policies/`
- One policy per model
- Scope all queries through policy scopes
- Policies must include `index?` and `show?` for API endpoints

### API
- Versioned JSON API under `Api::V1::` namespace
- Token-based auth via `Authorization: Bearer <token>` header (ADR-009)
- Every web UI action must have a corresponding API endpoint
- API controllers inherit from `Api::V1::BaseController` (not `ApplicationController`)
- Include `ApiPagination` concern for index actions
- jbuilder templates in `app/views/api/v1/<resource>/`
- Tests in `test/controllers/api/v1/`
- Routes exclude `new`/`edit` actions (HTML-only)
- See @Documentation/Architecture/API_CONVENTIONS.md for full conventions

## Agent Roster

| Agent | Role |
|-------|------|
| `rails-architect` | Architecture decisions, feature design, data modeling |
| `diving-product-manager` | Product strategy, feature prioritization, market analysis |
| `diving-ui-expert` | UI/UX design, accessibility, web design system |
| `dive-copywriter` | User-facing text, localization, brand voice |
| `technical-project-manager` | Documentation governance, cross-module consistency |
| `swift-systems-architect` | Future iOS integration work |

## Key Documentation

- @Documentation/Architecture/ARCHITECTURE_OVERVIEW.md -- System architecture
- @Documentation/Architecture/API_CONVENTIONS.md -- API authentication, errors, endpoints
- @Documentation/Architecture/DATABASE_DESIGN.md -- Schema conventions
- @Documentation/Architecture/RAILS_CONVENTIONS.md -- Project Rails patterns
- @Documentation/Design/DESIGN_SYSTEM.md -- UI components and accessibility
- @Documentation/Design/DESIGN_PHILOSOPHY.md -- Design philosophy
- @Documentation/Domains/README.md -- Domain module index
- @Documentation/Planning/ROADMAP.md -- Feature roadmap
- @Documentation/Planning/FEATURE_BACKLOG.md -- Owner feature requests and prioritization
- @Documentation/Planning/DECISIONS.md -- Architectural Decision Records

## Commands

```bash
bin/setup          # Initial project setup
bin/dev            # Start development server (web + jobs)
bin/rails test     # Run test suite
bin/rubocop        # Run linter
bin/ci             # Run all CI checks (tests + linter + security)
bin/rails db:migrate  # Run pending migrations
```
