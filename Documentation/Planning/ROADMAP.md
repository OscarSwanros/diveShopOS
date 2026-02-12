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
- [ ] Customer model with certifications, medical records
- [ ] StaffMember model with instructor ratings
- [x] DiveSite model (pulled forward from Tier 2 for Excursions)
- [x] Excursion model with trip dives, participants
- [x] Capacity gate safety service object
- [ ] Booking model tying customers to activities
- [ ] Safety gate service objects (certification, medical, waiver)
- [ ] Basic CRUD views with Turbo/Stimulus
- [ ] Dashboard for daily operations

## Phase 2: Education & Equipment
- [ ] Course catalog and course offerings (see [FB-002: capacity planning](FEATURE_BACKLOG.md#fb-002-courses-module-with-capacity-planning))
- [ ] Enrollment with prerequisite validation
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
- [ ] API (`Api::V1::`) for integrations
- [ ] Multi-currency support
- [ ] Advanced reporting and analytics
- [ ] Mobile-optimized workflows
