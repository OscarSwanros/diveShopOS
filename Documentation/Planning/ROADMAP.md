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
- [ ] Excursion model with trip dives, participants
- [ ] Booking model tying customers to activities
- [ ] Safety gate service objects (certification, medical, waiver, capacity)
- [ ] Basic CRUD views with Turbo/Stimulus
- [ ] Dashboard for daily operations

## Phase 2: Education & Equipment
- [ ] Course catalog and course offerings
- [ ] Enrollment with prerequisite validation
- [ ] Equipment fleet tracking (serialized items)
- [ ] Rental assignment workflow
- [ ] Equipment service tracking (life-support gear emphasis)

## Phase 3: Operations
- [ ] Waiver/compliance management (digital signatures)
- [ ] Dive site database with conditions
- [ ] Billing and payments
- [ ] Notification system (reminders, confirmations)
- [ ] Reporting dashboards

## Phase 4: Scale
- [ ] API (`Api::V1::`) for integrations
- [ ] Multi-currency support
- [ ] Advanced reporting and analytics
- [ ] Mobile-optimized workflows
