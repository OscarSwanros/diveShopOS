# Rails Architect Memory

## Project Overview
- DiveShopOS: operating system for dive shops and schools
- Rails 8.1.2, Ruby 3.3.6, SQLite3 (all envs), Hotwire/Turbo/Stimulus, Tailwind CSS
- UUID primary keys (string type, generated via `SecureRandom.uuid` in `ApplicationRecord`)
- Multi-tenancy: row-level scoping via `organization_id`
- Auth: `has_secure_password`, Authorization: Pundit
- Background jobs: Solid Queue, Caching: Solid Cache, WebSockets: Solid Cable
- Deployment: Kamal + Docker

## Key Architecture Decisions
- Whitelabel support: Organizations have `custom_domain` and `subdomain` columns
- Tenant resolution via Rack middleware (not controller before_action)
- Middleware resolves request.host -> Organization, sets `Current.organization`
- Branding: `brand_primary_color`, `brand_accent_color`, `tagline` columns; logos via Active Storage
- Domain lookup cached with `Rails.cache.fetch`, 5-min TTL
- Caddy reverse proxy for TLS/custom domain routing in front of Rails
- `slug` is internal identifier, not student-facing

## Schema Conventions
- See `Documentation/Architecture/DATABASE_DESIGN.md`
- Soft deletes via `discarded_at` on customer-facing data
- Money: `decimal(10,2)`, Status: `integer` with Rails enum
- Both DB constraints AND ActiveRecord validations for critical data
- Partial unique indexes used (SQLite supports them)

## File Locations
- Organization model: `app/models/organization.rb`
- Organization migration: `db/migrate/20260212220226_create_organizations.rb`
- Database conventions: `Documentation/Architecture/DATABASE_DESIGN.md`
- Architecture overview: `Documentation/Architecture/ARCHITECTURE_OVERVIEW.md`

## Domain Modules (Tiers)
- Tier 1 (MVP): Core, Customers, Staff, Excursions, Bookings
- Tier 2: Courses, Equipment, Compliance, Sites
- Tier 3: Billing, Notifications, Reporting

## Detailed Notes
- See [whitelabel-design.md](whitelabel-design.md) for full whitelabel architecture
