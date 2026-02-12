# Feature Backlog

Feature requests from the shop owner, cataloged for planning and prioritization.

---

## FB-001: Destinations Catalog

**Date**: 2026-02-12
**Domains**: Excursions, Sites
**Status**: In Progress (via Excursions domain build)

**Description**: A public-facing catalog of dive destinations and excursions that the shop offers. Potential customers should be able to browse available trips, see dive site details (depth, difficulty, location), and express interest or sign up.

**Dependencies**:
- Excursions domain (core entity)
- Sites domain (DiveSite model, pulled forward into Excursions build)
- Public-facing application layer (ADR-006)

**Notes**: The Excursions domain build delivers the staff-facing foundation. A future public layer will expose this data to unauthenticated visitors on the shop's whitelabel domain.

---

## FB-002: Courses Module with Capacity Planning

**Date**: 2026-02-12
**Domains**: Courses, Equipment
**Status**: In Progress (course catalog, enrollment, attendance, completion delivered; equipment capacity planning deferred)

**Description**: A full course catalog with enrollment, progress tracking, and certification issuance. Includes capacity planning that cross-references equipment availability (e.g., enough regulators for a class of 8) and instructor availability.

**Dependencies**:
- Courses domain (catalog, offerings, enrollments) -- **delivered**
- Equipment domain (inventory tracking, availability queries) -- deferred to Equipment build
- Staff domain (instructor ratings, availability) -- **delivered** (InstructorRating model)
- Excursions domain (establishes the "schedulable activity with participants" pattern) -- **delivered**

**Delivered**:
- Course catalog (Course model, agency-neutral, 5 course types)
- CourseOffering (scheduled instances with instructor, pricing, status)
- ClassSession (classroom/confined water/open water sessions)
- Enrollment with safety gates (student ratio, minimum age, medical clearance)
- Instructor rating validation and scheduling conflict detection
- Attendance tracking (SessionAttendance, batch update UI)
- Course completion with automatic certification issuance
- Mailers (enrollment confirmation, completion, class session reschedule)

**Notes**: The capacity planning aspect creates a cross-dependency between Courses and Equipment that needs careful interface design. Equipment capacity planning will be addressed when the Equipment domain is built.

---

## FB-003: Finances Module

**Date**: 2026-02-12
**Domains**: Billing, Reporting
**Status**: Planned

**Description**: Per-customer payment tracking, invoicing, and financial reporting. The shop owner wants to see what each customer owes, has paid, and track revenue by activity type (excursions, courses, equipment rental).

**Dependencies**:
- Billing domain (invoices, payments, line items)
- Reporting domain (dashboards, revenue analytics)
- Bookings domain (ties payments to activities)
- Excursions domain (gives Billing something to charge for)

**Notes**: A simple `paid` boolean on TripParticipant serves as a stopgap until the full Billing domain is built. The Billing domain should support multiple payment methods and partial payments.

---

## FB-004: Activity Feed

**Date**: 2026-02-12
**Domains**: Cross-domain aggregation
**Status**: Planned

**Description**: A public-facing activity feed showing upcoming excursions, new course offerings, and shop news. Visitors can see what's happening and express interest or sign up. This serves as a marketing and engagement tool on the shop's whitelabel domain.

**Dependencies**:
- Excursions domain (upcoming trips to display)
- Courses domain (upcoming course offerings)
- Public-facing application layer (ADR-006)
- Cross-domain aggregation pattern (ADR-007)

**Notes**: This is a read-only aggregation layer that pulls published data from multiple domains. It does not own any data itself. Could be implemented as a dedicated controller that queries across domains, or as a Turbo Stream-powered real-time feed.
