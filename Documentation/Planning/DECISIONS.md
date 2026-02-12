# Architectural Decision Records

## ADR-001: Multi-Tenancy via Row-Level Scoping

**Date**: 2026-02-12
**Status**: Accepted

**Context**: DiveShopOS serves multiple dive shops. We need tenant isolation.

**Decision**: Use row-level scoping via `organization_id` on all business data tables.

**Rationale**: Simplest approach. No schema-per-tenant complexity. Sufficient for target scale (hundreds of organizations, not thousands). Easy to reason about. Easy to test.

**Consequences**: Must be disciplined about always scoping queries. Default scopes or controller-level enforcement needed. Cross-tenant queries require explicit opt-in.

---

## ADR-002: UUID Primary Keys

**Date**: 2026-02-12
**Status**: Accepted

**Context**: Need primary keys that are safe for multi-tenant URLs, future API, and potential sync.

**Decision**: UUID primary keys on all tables.

**Rationale**: No sequential ID guessing. Safe in URLs without additional obfuscation. API-friendly. Future-proof for sync scenarios.

**Consequences**: Slightly larger indexes. Need to configure Rails generators. No `find(1)` in tests -- use fixtures with named references.

---

## ADR-003: SQLite for All Environments

**Date**: 2026-02-12
**Status**: Accepted

**Context**: Rails 8 has significantly improved SQLite support.

**Decision**: Use SQLite for development, test, and production.

**Rationale**: Simpler deployment (no Postgres to manage). Rails 8 Solid Queue/Cache/Cable all work with SQLite. Sufficient performance for target scale. Easier backups.

**Consequences**: Some PostgreSQL-specific features unavailable. May need to migrate if scale requires it. Must use SQLite-compatible query patterns.

---

## ADR-004: Safety Gates as Service Objects

**Date**: 2026-02-12
**Status**: Accepted

**Context**: Safety rules (certification checks, medical clearance, etc.) are the core differentiator.

**Decision**: Implement all safety gates as explicit, testable service objects. Never use model callbacks for safety logic.

**Rationale**: Service objects are easy to test in isolation. Easy to audit. Easy to override with documented reasons. Callbacks hide critical business logic and make testing harder.

**Consequences**: More files (one service per gate). Controllers must explicitly call services. But: safety logic is visible, testable, and auditable.

---

## ADR-005: Pundit for Authorization

**Date**: 2026-02-12
**Status**: Accepted

**Context**: Need role-based access control for dive shop staff.

**Decision**: Use Pundit gem for authorization.

**Rationale**: Clean policy objects. One policy per model. Easy to test. Well-maintained. Integrates naturally with Rails controllers.

**Consequences**: Must remember to call `authorize` in every controller action. Policy scopes needed for index actions.

---

## ADR-006: Public-Facing Application Layer (Proposed)

**Date**: 2026-02-12
**Status**: Proposed

**Context**: Feature requests FB-001 (Destinations Catalog) and FB-004 (Activity Feed) require exposing data to unauthenticated visitors on the shop's whitelabel domain. Currently, all controllers require authentication.

**Decision**: TBD. Options under consideration:
1. Separate `Public::` namespace with controllers that skip authentication and read published data
2. Conditional authentication in existing controllers with public/private action split
3. Separate public-facing Rails engine mounted at a subpath

**Rationale**: Need a clean pattern for serving public content without compromising the authenticated staff interface. The whitelabel system already resolves the tenant from the domain, so organization scoping works for public pages too.

**Consequences**: Must ensure public controllers cannot leak unpublished or internal data. Need clear conventions for which data is "publishable." The Excursion `status: published` pattern establishes the foundation.

---

## ADR-007: Cross-Domain Aggregation Pattern (Proposed)

**Date**: 2026-02-12
**Status**: Proposed

**Context**: The Activity Feed (FB-004) needs to pull data from multiple domains (Excursions, Courses, etc.) into a single view. This is the first feature that reads across domain boundaries.

**Decision**: TBD. Options under consideration:
1. A dedicated query object that reads from multiple domain models directly
2. A denormalized `activity_events` table populated by domain-specific jobs
3. Turbo Frames that compose multiple domain-specific partials into one page

**Rationale**: Cross-domain reads are inherently coupling. Need a pattern that lets domains evolve independently while feeding a shared aggregation layer.

**Consequences**: Whatever pattern is chosen becomes the standard for future cross-domain features (dashboards, reporting). Should be decided before building the Activity Feed.

---

## ADR-008: No Return Inside Rails.cache.fetch Blocks

**Date**: 2026-02-12
**Status**: Accepted

**Context**: During development, a `return` statement was used inside a `Rails.cache.fetch` block. In Ruby, `return` exits the enclosing method, not just the block. This means the cache never receives the computed value and the fetch is effectively a no-op — the block runs every time.

**Decision**: Never use `return` inside `Rails.cache.fetch` blocks. The last expression in the block is the cached value.

**Rationale**: `Rails.cache.fetch` expects the block to yield the value to cache. A `return` bypasses the cache write entirely. This is a subtle bug that causes silent performance degradation — the cache appears to work but never stores anything.

**Consequences**: Use the block's implicit return value. If early exit logic is needed, compute the value in a local variable and let it be the last expression.
