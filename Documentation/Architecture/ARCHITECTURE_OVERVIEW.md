# Architecture Overview

## System Architecture

DiveShopOS is a monolithic Ruby on Rails 8 application organized around business domains. It uses Hotwire (Turbo + Stimulus) for a modern, responsive frontend without a JavaScript framework.

## Multi-Tenancy

All data is scoped to an **Organization** (the tenant). Every model that contains business data includes an `organization_id` foreign key. Queries are scoped through the current organization context to ensure data isolation.

```ruby
# All queries go through the organization
current_organization.customers.find(params[:id])
current_organization.excursions.upcoming
```

## Domain Model

```
Organization (tenant)
  |-- has_many :users (authentication, staff access)
  |-- has_many :customers (divers who use the shop)
  |-- has_many :staff_members (instructors, divemasters)
  |-- has_many :excursions (scheduled dive trips)
  |-- has_many :courses (course catalog)
  |-- has_many :equipment_items (rental/retail inventory)
  |-- has_many :bookings (reservations)
  |-- has_many :dive_sites (dive site database)
```

## Key Architectural Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Multi-tenancy | Row-level scoping via `organization_id` | Simplest, sufficient for target scale |
| Authentication | Rails 8 `has_secure_password` | Built-in, no additional gem |
| Authorization | Pundit | Clean, testable policy objects |
| CSS | Tailwind CSS | Utility-first, pairs well with Hotwire |
| Database | SQLite everywhere | Rails 8 SQLite support, simpler deployment |
| Primary keys | UUIDs | Multi-tenancy, future sync, API-friendly |
| Soft deletes | Customer-facing data | Certifications and dive data are irreplaceable |
| Background jobs | Solid Queue | Rails 8 default, no Redis needed |
| File storage | Active Storage | Waivers, medical docs, photos |
| API | Versioned JSON API (`Api::V1::`) | Future mobile/integration |

## Safety Gates

Business rules enforced as explicit, testable service objects -- never model callbacks. See CLAUDE.md for the full list.

## Request Flow

1. Request hits Rails router
2. Controller authenticates user and loads organization context
3. Pundit policy authorizes the action
4. Service object executes business logic (including safety gate checks)
5. Model persists changes
6. Turbo Frame/Stream updates the relevant UI section
