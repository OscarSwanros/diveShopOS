# frozen_string_literal: true

# Development seed data
# Run with: bin/rails db:seed

puts "Seeding database..."

# --- Organization ---
org = Organization.find_or_create_by!(slug: "abucear") do |o|
  o.name = "A Bucear"
  o.subdomain = "localhost"
  o.custom_domain = "abucear.mx"
  o.locale = "en"
  o.time_zone = "America/Mexico_City"
end
puts "  Organization: #{org.name} (#{org.slug})"

# --- Users ---
owner = User.find_or_create_by!(organization: org, email_address: "oscar@abucear.mx") do |u|
  u.name = "Oscar"
  u.password = "password"
  u.role = :owner
end
puts "  Owner: #{owner.email_address} / password"

manager = User.find_or_create_by!(organization: org, email_address: "manager@abucear.mx") do |u|
  u.name = "Carlos Rivera"
  u.password = "password"
  u.role = :manager
end
puts "  Manager: #{manager.email_address} / password"

staff = User.find_or_create_by!(organization: org, email_address: "staff@abucear.mx") do |u|
  u.name = "Ana Torres"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{staff.email_address} / password"

# Instructors / divemasters
pedro = User.find_or_create_by!(organization: org, email_address: "pedro@abucear.mx") do |u|
  u.name = "Pedro Castillo"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{pedro.email_address} / password"

luisa = User.find_or_create_by!(organization: org, email_address: "luisa@abucear.mx") do |u|
  u.name = "Luisa Fernandez"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{luisa.email_address} / password"

miguel = User.find_or_create_by!(organization: org, email_address: "miguel@abucear.mx") do |u|
  u.name = "Miguel Reyes"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{miguel.email_address} / password"

# --- Dive Sites ---
coral = DiveSite.find_or_create_by!(organization: org, name: "Coral Garden") do |s|
  s.description = "Beautiful shallow reef with abundant coral formations and tropical fish."
  s.max_depth_meters = 18.0
  s.difficulty_level = :beginner
  s.latitude = 20.2114
  s.longitude = -87.4654
  s.location_description = "South of the marina, 15 min boat ride"
end

wall = DiveSite.find_or_create_by!(organization: org, name: "The Wall") do |s|
  s.description = "Dramatic drop-off starting at 15m, wall descends to 40m+. Strong currents possible."
  s.max_depth_meters = 40.0
  s.difficulty_level = :advanced
  s.latitude = 20.2098
  s.longitude = -87.4701
  s.location_description = "East side, 25 min boat ride"
end

cenote = DiveSite.find_or_create_by!(organization: org, name: "Cenote Azul") do |s|
  s.description = "Crystal clear freshwater cenote with light effects and cavern zone."
  s.max_depth_meters = 30.0
  s.difficulty_level = :intermediate
  s.latitude = 20.3186
  s.longitude = -87.3812
  s.location_description = "45 min drive inland, entrance fee required"
end

puts "  Dive sites: #{org.dive_sites.count}"

# --- Excursions ---
tomorrow = Date.current + 1.day
next_week = Date.current + 7.days

morning = Excursion.find_or_create_by!(organization: org, title: "Morning Reef Trip", scheduled_date: tomorrow) do |e|
  e.description = "Two-tank morning dive at the reef. Suitable for all levels."
  e.departure_time = "08:00"
  e.return_time = "12:30"
  e.capacity = 12
  e.price_cents = 12_000
  e.status = :published
end

wall_trip = Excursion.find_or_create_by!(organization: org, title: "Advanced Wall Dive", scheduled_date: next_week) do |e|
  e.description = "Deep wall dive for advanced certified divers. Two tanks."
  e.departure_time = "07:30"
  e.return_time = "12:00"
  e.capacity = 8
  e.price_cents = 15_000
  e.status = :published
end

cenote_trip = Excursion.find_or_create_by!(organization: org, title: "Cenote Adventure", scheduled_date: next_week + 1.day) do |e|
  e.description = "Full day cenote excursion. Two dives plus lunch."
  e.departure_time = "07:00"
  e.return_time = "16:00"
  e.capacity = 6
  e.price_cents = 22_000
  e.status = :draft
end

puts "  Excursions: #{org.excursions.count}"

# --- Trip Dives ---
TripDive.find_or_create_by!(excursion: morning, dive_number: 1) do |td|
  td.dive_site = coral
  td.planned_max_depth_meters = 15.0
  td.planned_bottom_time_minutes = 55
end

TripDive.find_or_create_by!(excursion: morning, dive_number: 2) do |td|
  td.dive_site = coral
  td.planned_max_depth_meters = 12.0
  td.planned_bottom_time_minutes = 60
  td.notes = "Shallower second dive for gas management"
end

TripDive.find_or_create_by!(excursion: wall_trip, dive_number: 1) do |td|
  td.dive_site = wall
  td.planned_max_depth_meters = 30.0
  td.planned_bottom_time_minutes = 35
end

TripDive.find_or_create_by!(excursion: wall_trip, dive_number: 2) do |td|
  td.dive_site = wall
  td.planned_max_depth_meters = 18.0
  td.planned_bottom_time_minutes = 50
  td.notes = "Shallower profile for second dive"
end

puts "  Trip dives: #{TripDive.count}"

# --- Trip Participants ---
TripParticipant.find_or_create_by!(excursion: morning, name: "Jane Smith", role: :diver) do |tp|
  tp.email = "jane@example.com"
  tp.phone = "+1-555-0101"
  tp.certification_level = "Advanced Open Water"
  tp.certification_agency = "PADI"
  tp.paid = true
end

TripParticipant.find_or_create_by!(excursion: morning, name: "Bob Johnson", role: :diver) do |tp|
  tp.email = "bob@example.com"
  tp.phone = "+1-555-0102"
  tp.certification_level = "Open Water"
  tp.certification_agency = "SSI"
  tp.paid = false
end

TripParticipant.find_or_create_by!(excursion: morning, name: "Pedro Castillo", role: :divemaster) do |tp|
  tp.email = "pedro@abucear.mx"
  tp.certification_level = "Divemaster"
  tp.certification_agency = "PADI"
  tp.paid = true
  tp.notes = "Staff guide"
end

puts "  Trip participants: #{TripParticipant.count}"

# --- Customers ---
jane = Customer.find_or_create_by!(organization: org, email: "jane.diver@example.com") do |c|
  c.first_name = "Jane"
  c.last_name = "Diver"
  c.phone = "+1-555-0201"
  c.date_of_birth = "1990-05-15"
  c.emergency_contact_name = "John Diver"
  c.emergency_contact_phone = "+1-555-0200"
end

roberto = Customer.find_or_create_by!(organization: org, email: "roberto@example.com") do |c|
  c.first_name = "Roberto"
  c.last_name = "Lopez"
  c.phone = "+52-984-555-0301"
  c.date_of_birth = "1988-03-22"
  c.emergency_contact_name = "Maria Lopez"
  c.emergency_contact_phone = "+52-984-555-0300"
end

sofia = Customer.find_or_create_by!(organization: org, email: "sofia@example.com") do |c|
  c.first_name = "Sofia"
  c.last_name = "Martinez"
  c.date_of_birth = "2010-08-10"
  c.emergency_contact_name = "Carlos Martinez"
  c.emergency_contact_phone = "+1-555-0400"
  c.notes = "Minor - parent must be present for water activities"
end

elena = Customer.find_or_create_by!(organization: org, email: "elena.rios@example.com") do |c|
  c.first_name = "Elena"
  c.last_name = "Rios"
  c.phone = "+52-998-555-0501"
  c.date_of_birth = "1985-11-03"
  c.emergency_contact_name = "Marco Rios"
  c.emergency_contact_phone = "+52-998-555-0500"
end

david = Customer.find_or_create_by!(organization: org, email: "david.chen@example.com") do |c|
  c.first_name = "David"
  c.last_name = "Chen"
  c.phone = "+1-555-0601"
  c.date_of_birth = "1992-07-19"
  c.emergency_contact_name = "Linda Chen"
  c.emergency_contact_phone = "+1-555-0600"
end

maria = Customer.find_or_create_by!(organization: org, email: "maria.garcia@example.com") do |c|
  c.first_name = "Maria"
  c.last_name = "Garcia"
  c.phone = "+52-984-555-0701"
  c.date_of_birth = "1978-02-28"
  c.emergency_contact_name = "Luis Garcia"
  c.emergency_contact_phone = "+52-984-555-0700"
  c.notes = "Returning customer, has logged 200+ dives"
end

tom = Customer.find_or_create_by!(organization: org, email: "tom.baker@example.com") do |c|
  c.first_name = "Tom"
  c.last_name = "Baker"
  c.phone = "+1-555-0801"
  c.date_of_birth = "1995-12-01"
  c.emergency_contact_name = "Susan Baker"
  c.emergency_contact_phone = "+1-555-0800"
end

yuki = Customer.find_or_create_by!(organization: org, email: "yuki.tanaka@example.com") do |c|
  c.first_name = "Yuki"
  c.last_name = "Tanaka"
  c.phone = "+81-90-5555-0901"
  c.date_of_birth = "2000-04-14"
  c.emergency_contact_name = "Kenji Tanaka"
  c.emergency_contact_phone = "+81-90-5555-0900"
end

puts "  Customers: #{org.customers.count}"

# --- Medical Records ---
MedicalRecord.find_or_create_by!(customer: jane, clearance_date: Date.current - 2.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 10.months
  m.physician_name = "Dr. Garcia"
end

MedicalRecord.find_or_create_by!(customer: roberto, clearance_date: Date.current - 6.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 6.months
  m.physician_name = "Dr. Hernandez"
end

MedicalRecord.find_or_create_by!(customer: elena, clearance_date: Date.current - 1.month) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 11.months
  m.physician_name = "Dr. Ramirez"
end

MedicalRecord.find_or_create_by!(customer: david, clearance_date: Date.current - 3.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 9.months
  m.physician_name = "Dr. Wong"
end

MedicalRecord.find_or_create_by!(customer: maria, clearance_date: Date.current - 13.months) do |m|
  m.status = :expired
  m.expiration_date = Date.current - 1.month
  m.physician_name = "Dr. Hernandez"
  m.notes = "Needs renewal before next water activity"
end

MedicalRecord.find_or_create_by!(customer: tom, clearance_date: Date.current - 5.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 7.months
  m.physician_name = "Dr. Smith"
end

MedicalRecord.find_or_create_by!(customer: yuki, clearance_date: Date.current - 1.week) do |m|
  m.status = :pending_review
  m.expiration_date = Date.current + 1.year
  m.physician_name = "Dr. Sato"
  m.notes = "Awaiting translated documents"
end

puts "  Medical records: #{MedicalRecord.count}"

# --- Certifications ---
Certification.find_or_create_by!(customer: jane, agency: "PADI", certification_level: "Advanced Open Water") do |c|
  c.certification_number = "1234567890"
  c.issued_date = Date.current - 2.years
end

Certification.find_or_create_by!(customer: roberto, agency: "SSI", certification_level: "Open Water") do |c|
  c.issued_date = Date.current - 1.year
end

Certification.find_or_create_by!(customer: elena, agency: "PADI", certification_level: "Rescue Diver") do |c|
  c.certification_number = "PD-2345678"
  c.issued_date = Date.current - 1.year
end

Certification.find_or_create_by!(customer: elena, agency: "PADI", certification_level: "Enriched Air Diver") do |c|
  c.issued_date = Date.current - 8.months
end

Certification.find_or_create_by!(customer: david, agency: "SSI", certification_level: "Advanced Adventurer") do |c|
  c.certification_number = "SSI-3456789"
  c.issued_date = Date.current - 6.months
end

Certification.find_or_create_by!(customer: maria, agency: "NAUI", certification_level: "Master Diver") do |c|
  c.certification_number = "NAUI-4567890"
  c.issued_date = Date.current - 5.years
end

Certification.find_or_create_by!(customer: tom, agency: "PADI", certification_level: "Open Water") do |c|
  c.certification_number = "PD-5678901"
  c.issued_date = Date.current - 3.months
end

puts "  Certifications: #{Certification.count}"

# --- Instructor Ratings ---
InstructorRating.find_or_create_by!(user: owner, agency: "PADI", rating_level: "Course Director") do |r|
  r.rating_number = "CD-12345"
  r.expiration_date = Date.current + 1.year
end

InstructorRating.find_or_create_by!(user: manager, agency: "SSI", rating_level: "Instructor") do |r|
  r.rating_number = "SSI-67890"
  r.expiration_date = Date.current + 8.months
end

InstructorRating.find_or_create_by!(user: pedro, agency: "PADI", rating_level: "Divemaster") do |r|
  r.rating_number = "DM-11111"
  r.expiration_date = Date.current + 10.months
end

InstructorRating.find_or_create_by!(user: luisa, agency: "PADI", rating_level: "Open Water Scuba Instructor") do |r|
  r.rating_number = "OWSI-22222"
  r.expiration_date = Date.current + 6.months
end

InstructorRating.find_or_create_by!(user: luisa, agency: "SSI", rating_level: "Instructor") do |r|
  r.rating_number = "SSI-33333"
  r.expiration_date = Date.current + 9.months
end

InstructorRating.find_or_create_by!(user: miguel, agency: "NAUI", rating_level: "Instructor") do |r|
  r.rating_number = "NAUI-44444"
  r.expiration_date = Date.current + 1.year
end

puts "  Instructor ratings: #{InstructorRating.count}"

# --- Courses ---
ow_course = Course.find_or_create_by!(organization: org, name: "PADI Open Water Diver") do |c|
  c.description = "Learn the fundamentals of scuba diving. Includes confined water dives and open water dives."
  c.agency = "PADI"
  c.level = "Open Water"
  c.course_type = :certification
  c.min_age = 10
  c.max_students = 8
  c.duration_days = 4
  c.price_cents = 35_000
  c.price_currency = "USD"
end

aow_course = Course.find_or_create_by!(organization: org, name: "PADI Advanced Open Water") do |c|
  c.description = "Five adventure dives including deep and navigation."
  c.agency = "PADI"
  c.level = "Advanced Open Water"
  c.course_type = :certification
  c.min_age = 12
  c.max_students = 8
  c.duration_days = 2
  c.price_cents = 30_000
  c.price_currency = "USD"
end

nitrox_course = Course.find_or_create_by!(organization: org, name: "SSI Enriched Air Nitrox") do |c|
  c.description = "Learn to dive with enriched air nitrox."
  c.agency = "SSI"
  c.level = "Specialty"
  c.course_type = :specialty
  c.max_students = 10
  c.price_cents = 15_000
  c.price_currency = "USD"
end

rescue_course = Course.find_or_create_by!(organization: org, name: "PADI Rescue Diver") do |c|
  c.description = "Learn to manage dive emergencies. Stressful but rewarding course that makes you a better buddy."
  c.agency = "PADI"
  c.level = "Rescue Diver"
  c.course_type = :certification
  c.min_age = 12
  c.max_students = 8
  c.duration_days = 4
  c.price_cents = 38_000
  c.price_currency = "USD"
end

dm_course = Course.find_or_create_by!(organization: org, name: "PADI Divemaster") do |c|
  c.description = "Your first professional-level certification. Assist instructors, lead dives, and inspire others."
  c.agency = "PADI"
  c.level = "Divemaster"
  c.course_type = :professional
  c.min_age = 18
  c.max_students = 4
  c.duration_days = 30
  c.price_cents = 75_000
  c.price_currency = "USD"
end

deep_course = Course.find_or_create_by!(organization: org, name: "SSI Deep Diving") do |c|
  c.description = "Explore depths beyond 18 meters safely. Learn deep dive planning and gas management."
  c.agency = "SSI"
  c.level = "Specialty"
  c.course_type = :specialty
  c.min_age = 15
  c.max_students = 6
  c.duration_days = 2
  c.price_cents = 20_000
  c.price_currency = "USD"
end

naui_ow = Course.find_or_create_by!(organization: org, name: "NAUI Scuba Diver") do |c|
  c.description = "NAUI entry-level scuba certification. Emphasizes understanding over rote skills."
  c.agency = "NAUI"
  c.level = "Scuba Diver"
  c.course_type = :certification
  c.min_age = 10
  c.max_students = 8
  c.duration_days = 5
  c.price_cents = 37_000
  c.price_currency = "USD"
end

discover_course = Course.find_or_create_by!(organization: org, name: "Discover Scuba Diving") do |c|
  c.description = "Try scuba for the first time! A supervised pool and open water experience. No certification required."
  c.agency = "PADI"
  c.level = "Introductory"
  c.course_type = :non_certification
  c.max_students = 4
  c.duration_days = 1
  c.price_cents = 12_000
  c.price_currency = "USD"
end

puts "  Courses: #{org.courses.count}"

# --- Course Offerings ---
ow_offering = CourseOffering.find_or_create_by!(
  course: ow_course,
  organization: org,
  start_date: Date.current + 14.days
) do |o|
  o.instructor = owner
  o.end_date = Date.current + 18.days
  o.max_students = 6
  o.status = :published
end

aow_offering = CourseOffering.find_or_create_by!(
  course: aow_course,
  organization: org,
  start_date: Date.current + 30.days
) do |o|
  o.instructor = owner
  o.end_date = Date.current + 32.days
  o.max_students = 8
  o.status = :draft
  o.notes = "Pending minimum enrollment of 3 students"
end

nitrox_offering = CourseOffering.find_or_create_by!(
  course: nitrox_course,
  organization: org,
  start_date: Date.current + 7.days
) do |o|
  o.instructor = manager
  o.end_date = Date.current + 7.days
  o.max_students = 10
  o.status = :published
  o.notes = "Single-day classroom + two optional dives"
end

rescue_offering = CourseOffering.find_or_create_by!(
  course: rescue_course,
  organization: org,
  start_date: Date.current + 21.days
) do |o|
  o.instructor = luisa
  o.end_date = Date.current + 25.days
  o.max_students = 6
  o.status = :published
end

discover_offering = CourseOffering.find_or_create_by!(
  course: discover_course,
  organization: org,
  start_date: Date.current + 3.days
) do |o|
  o.instructor = pedro
  o.end_date = Date.current + 3.days
  o.max_students = 4
  o.price_cents = 10_000
  o.status = :published
  o.notes = "Weekend special pricing"
end

naui_ow_offering = CourseOffering.find_or_create_by!(
  course: naui_ow,
  organization: org,
  start_date: Date.current + 45.days
) do |o|
  o.instructor = miguel
  o.end_date = Date.current + 50.days
  o.max_students = 6
  o.status = :draft
  o.notes = "Awaiting minimum 3 enrollments to confirm"
end

puts "  Course offerings: #{org.course_offerings.count}"

# --- Class Sessions ---
ClassSession.find_or_create_by!(course_offering: ow_offering, scheduled_date: Date.current + 14.days, start_time: "09:00") do |s|
  s.session_type = :classroom
  s.title = "Module 1: Dive Theory"
  s.end_time = "12:00"
  s.location_description = "Classroom"
end

ClassSession.find_or_create_by!(course_offering: ow_offering, scheduled_date: Date.current + 15.days, start_time: "08:00") do |s|
  s.session_type = :confined_water
  s.title = "Confined Water Dive 1 & 2"
  s.end_time = "12:00"
  s.location_description = "Training Pool"
end

ClassSession.find_or_create_by!(course_offering: ow_offering, scheduled_date: Date.current + 17.days, start_time: "07:30") do |s|
  s.session_type = :open_water
  s.title = "Open Water Dive 1 & 2"
  s.end_time = "13:00"
  s.dive_site = coral
end

ClassSession.find_or_create_by!(course_offering: ow_offering, scheduled_date: Date.current + 18.days, start_time: "07:30") do |s|
  s.session_type = :open_water
  s.title = "Open Water Dive 3 & 4"
  s.end_time = "13:00"
  s.dive_site = coral
end

puts "  Class sessions: #{ClassSession.count}"

# --- Enrollments ---
Enrollment.find_or_create_by!(course_offering: ow_offering, customer: roberto) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 3.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: ow_offering, customer: sofia) do |e|
  e.status = :pending
  e.enrolled_at = Time.current - 1.day
  e.paid = false
  e.notes = "Parent signed waiver"
end

Enrollment.find_or_create_by!(course_offering: nitrox_offering, customer: jane) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 5.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: nitrox_offering, customer: elena) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 4.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: rescue_offering, customer: elena) do |e|
  e.status = :pending
  e.enrolled_at = Time.current - 2.days
  e.paid = false
end

Enrollment.find_or_create_by!(course_offering: rescue_offering, customer: david) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 3.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: discover_offering, customer: yuki) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 1.day
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: discover_offering, customer: tom) do |e|
  e.status = :pending
  e.enrolled_at = Time.current
  e.paid = false
  e.notes = "Walk-in, wants to try diving"
end

puts "  Enrollments: #{Enrollment.count}"

puts "Done! Login with: oscar@abucear.mx / password"
