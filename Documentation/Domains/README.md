# Domain Module Index

DiveShopOS is organized around business domains. Each domain owns its models, controllers, views, services, and jobs.

## Module Registry

### Tier 1 -- MVP (Phase 1)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| **Core** | In Progress | Organization, User | Authentication, multi-tenancy |
| Customers | Planned | Customer, Certification, MedicalRecord, Waiver | Diver profiles and compliance |
| Staff | Planned | StaffMember, InstructorRating | Instructor and divemaster management |
| Excursions | Planned | Excursion, TripDive, TripParticipant | Trip scheduling and manifests |
| Bookings | Planned | Booking, BookingItem, Payment | Reservations and payments |

### Tier 2 -- Core Growth (Phase 2)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| Courses | Planned | Course, CourseOffering, Enrollment | Course catalog and education |
| Equipment | Planned | EquipmentItem, ServiceRecord, RentalAssignment | Fleet and inventory |
| Compliance | Planned | WaiverTemplate, IncidentReport | Compliance and safety records |
| Sites | Planned | DiveSite, SiteCondition | Dive site database |

### Tier 3 -- Later (Phase 3)

| Domain | Status | Models | Description |
|--------|--------|--------|-------------|
| Billing | Planned | Invoice, Payment, Commission | Financial operations |
| Notifications | Planned | Notification, NotificationTemplate | Automated communications |
| Reporting | Planned | Report, Dashboard | Analytics and insights |

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
test/models/excursion_test.rb
test/services/excursions/validate_participant_eligibility_test.rb
```

## Adding a New Module

See [Module Development Guide](../Onboarding/MODULE_DEVELOPMENT.md) for step-by-step instructions.
