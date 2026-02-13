# Roadmap

## Phase 0: Foundation (Current)
- [x] Project setup (Rails 8, SQLite, Hotwire)
- [x] Agent configuration and documentation
- [x] UUID primary keys
- [x] Organization model (multi-tenancy foundation)
- [x] User model with authentication
- [ ] Pundit authorization setup
- [ ] Tailwind CSS integration
- [ ] Basic layout and navigation

## Phase 1: MVP Core
- [x] Customer model with certifications, medical records
- [x] InstructorRating model (instructor ratings per agency)
- [x] DiveSite model (pulled forward from Tier 2 for Excursions)
- [x] Excursion model with trip dives, participants
- [x] Capacity gate safety service object
- [ ] Booking model tying customers to activities
- [x] Safety gate service objects (age, medical, instructor rating, student ratio, instructor conflict)
- [ ] Basic CRUD views with Turbo/Stimulus
- [ ] Dashboard for daily operations

## Phase 2: Education & Equipment
- [x] Course catalog and course offerings (see [FB-002: capacity planning](FEATURE_BACKLOG.md#fb-002-courses-module-with-capacity-planning))
- [x] Enrollment with safety gate validation
- [x] Attendance tracking and course completion with certification issuance
- [x] Enrollment and scheduling mailers (confirmation, completion, reschedule)
- [ ] Equipment fleet tracking (serialized items)
- [ ] Rental assignment workflow
- [ ] Equipment service tracking (life-support gear emphasis)

## Phase 3: Operations
- [ ] Waiver/compliance management (digital signatures)
- [ ] Dive site conditions and access requirements
- [ ] Billing and payments (see [FB-003: per-customer payment tracking](FEATURE_BACKLOG.md#fb-003-finances-module))
- [ ] Notification system (reminders, confirmations)
- [ ] Reporting dashboards

## Phase 4: Scale
- [x] API (`Api::V1::`) for integrations -- token auth, all CRUD endpoints, safety gates, pagination (ADR-009)
- [ ] Multi-currency support
- [ ] Advanced reporting and analytics
- [ ] Mobile-optimized workflows
