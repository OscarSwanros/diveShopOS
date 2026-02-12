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
