# Domain Module Index

DiveShopOS is organized around business domains. Each domain owns its models, controllers, views, services, and jobs.

## Module Registry

### Tier 1 -- MVP (Phase 1)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| **Core** | In Progress | Organization, User | Authentication, multi-tenancy |
| **Customers** | In Progress | Customer, Certification, MedicalRecord | Diver profiles, certifications, medical clearance |
| **Staff** | In Progress | InstructorRating (on User) | Instructor ratings per agency |
| **Excursions** | In Progress | Excursion, TripDive, TripParticipant, DiveSite | Trip scheduling, manifests; also serves Destinations catalog ([FB-001](../Planning/FEATURE_BACKLOG.md#fb-001-destinations-catalog)) and Activity Feed ([FB-004](../Planning/FEATURE_BACKLOG.md#fb-004-activity-feed)) |
| Bookings | Planned | Booking, BookingItem, Payment | Reservations and payments |

### Tier 2 -- Core Growth (Phase 2)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| **Courses** | In Progress | Course, CourseOffering, ClassSession, Enrollment, SessionAttendance | Course catalog, scheduling, enrollment with safety gates, attendance, completion with certification issuance, mailers ([FB-002](../Planning/FEATURE_BACKLOG.md#fb-002-courses-module-with-capacity-planning)), serves Activity Feed ([FB-004](../Planning/FEATURE_BACKLOG.md#fb-004-activity-feed)) |
| Equipment | Planned | EquipmentItem, ServiceRecord, RentalAssignment | Fleet and inventory |
| Compliance | Planned | WaiverTemplate, IncidentReport | Compliance and safety records |
| Sites | Partially Delivered | DiveSite, SiteCondition | Dive site database; DiveSite model pulled forward into Excursions build, serves Destinations catalog ([FB-001](../Planning/FEATURE_BACKLOG.md#fb-001-destinations-catalog)) |

### Tier 3 -- Later (Phase 3)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| Billing | Planned | Invoice, Payment, Commission | Financial operations |
| Notifications | Planned | Notification, NotificationTemplate | Automated communications |
| Reporting | Planned | Report, Dashboard | Analytics and insights |

### Tier 4 -- Public Engagement (Proposed)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| Destinations | Proposed | (views only, reads from Excursions + Sites) | Public-facing destinations catalog ([FB-001](../Planning/FEATURE_BACKLOG.md#fb-001-destinations-catalog)) |
| ActivityFeed | Proposed | (views only, cross-domain aggregation) | Public-facing activity feed ([FB-004](../Planning/FEATURE_BACKLOG.md#fb-004-activity-feed)) |

## File Organization Pattern

Using Excursions as an example:

```
app/models/excursion.rb
app/models/trip_dive.rb
app/models/trip_participant.rb
app/controllers/excursions_controller.rb
app/controllers/trip_participants_controller.rb
app/views/excursions/
app/views/trip_participants/
app/services/excursions/create_trip.rb
app/services/excursions/validate_participant_eligibility.rb
app/jobs/excursions/send_manifest_job.rb
app/policies/excursion_policy.rb
app/controllers/api/v1/excursions_controller.rb
app/controllers/api/v1/trip_dives_controller.rb
app/controllers/api/v1/trip_participants_controller.rb
app/views/api/v1/excursions/
app/views/api/v1/trip_dives/
app/views/api/v1/trip_participants/
test/models/excursion_test.rb
test/services/excursions/validate_participant_eligibility_test.rb
test/controllers/api/v1/excursions_controller_test.rb
test/controllers/api/v1/trip_dives_controller_test.rb
test/controllers/api/v1/trip_participants_controller_test.rb
```

## Adding a New Module

See [Module Development Guide](../Onboarding/MODULE_DEVELOPMENT.md) for step-by-step instructions.
