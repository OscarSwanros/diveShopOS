# frozen_string_literal: true

# Development seed data
# Run with: bin/rails db:seed

puts "Seeding database..."

# --- Organization ---
org = Organization.find_or_create_by!(slug: "abucear") do |o|
  o.name = "A Bucear"
  o.subdomain = "localhost"
  o.custom_domain = "abucear.test"
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

# --- Equipment Items ---
bcd1 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "AQ-BCD-001") do |e|
  e.category = :bcd
  e.name = "Aqualung Pro HD BCD #1"
  e.size = "M"
  e.manufacturer = "Aqualung"
  e.product_model = "Pro HD"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 1.year
end

bcd2 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "AQ-BCD-002") do |e|
  e.category = :bcd
  e.name = "Aqualung Pro HD BCD #2"
  e.size = "L"
  e.manufacturer = "Aqualung"
  e.product_model = "Pro HD"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 1.year
end

reg1 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "SP-REG-001") do |e|
  e.category = :regulator
  e.name = "Scubapro MK25 Reg #1"
  e.manufacturer = "Scubapro"
  e.product_model = "MK25/S620Ti"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 2.years
end

reg2 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "SP-REG-002") do |e|
  e.category = :regulator
  e.name = "Scubapro MK25 Reg #2"
  e.manufacturer = "Scubapro"
  e.product_model = "MK25/S620Ti"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 18.months
end

reg_overdue = EquipmentItem.find_or_create_by!(organization: org, serial_number: "MA-REG-003") do |e|
  e.category = :regulator
  e.name = "Mares Prestige Reg #3 (OVERDUE)"
  e.manufacturer = "Mares"
  e.product_model = "Prestige"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 3.years
end

tank1 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "TANK-AL80-001") do |e|
  e.category = :tank
  e.name = "AL80 Tank #1"
  e.size = "AL80"
  e.manufacturer = "Luxfer"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 2.years
end

tank2 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "TANK-AL80-002") do |e|
  e.category = :tank
  e.name = "AL80 Tank #2"
  e.size = "AL80"
  e.manufacturer = "Luxfer"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 2.years
end

comp1 = EquipmentItem.find_or_create_by!(organization: org, serial_number: "COMP-001") do |e|
  e.category = :computer
  e.name = "Shearwater Peregrine #1"
  e.manufacturer = "Shearwater"
  e.product_model = "Peregrine"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 6.months
end

6.times do |i|
  EquipmentItem.find_or_create_by!(organization: org, name: "Fins M ##{i + 1}") do |e|
    e.category = :fins
    e.size = "M"
    e.manufacturer = "Mares"
    e.product_model = "Avanti Quattro"
    e.status = :available
    e.life_support = false
  end
end

4.times do |i|
  EquipmentItem.find_or_create_by!(organization: org, name: "Wetsuit 5mm M ##{i + 1}") do |e|
    e.category = :wetsuit
    e.size = "M"
    e.manufacturer = "Bare"
    e.product_model = "Velocity 5mm"
    e.status = :available
    e.life_support = false
  end
end

4.times do |i|
  EquipmentItem.find_or_create_by!(organization: org, name: "Mask ##{i + 1}") do |e|
    e.category = :mask
    e.manufacturer = "Cressi"
    e.product_model = "Big Eyes Evolution"
    e.status = :available
    e.life_support = false
  end
end

EquipmentItem.find_or_create_by!(organization: org, name: "Old BCD (Retired)") do |e|
  e.category = :bcd
  e.serial_number = "OLD-BCD-RETIRED"
  e.size = "L"
  e.manufacturer = "Zeagle"
  e.status = :retired
  e.life_support = true
end

puts "  Equipment items: #{org.equipment_items.count}"

# --- Service Records ---
ServiceRecord.find_or_create_by!(equipment_item: bcd1, service_date: Date.current - 3.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 9.months
  s.performed_by = "Dive Shop Service Center"
  s.cost_cents = 15_000
  s.description = "Annual service and inspection - all components OK"
end

ServiceRecord.find_or_create_by!(equipment_item: bcd2, service_date: Date.current - 4.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 8.months
  s.performed_by = "Dive Shop Service Center"
  s.cost_cents = 15_000
  s.description = "Annual service"
end

ServiceRecord.find_or_create_by!(equipment_item: reg1, service_date: Date.current - 6.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 6.months
  s.performed_by = "Scubapro Authorized Service"
  s.cost_cents = 20_000
  s.description = "Full regulator overhaul"
end

ServiceRecord.find_or_create_by!(equipment_item: reg2, service_date: Date.current - 5.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 7.months
  s.performed_by = "Scubapro Authorized Service"
  s.cost_cents = 20_000
  s.description = "Full regulator overhaul"
end

ServiceRecord.find_or_create_by!(equipment_item: reg_overdue, service_date: Date.current - 14.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current - 2.months
  s.performed_by = "Local Service Center"
  s.cost_cents = 18_000
  s.description = "Annual service - OVERDUE for next service"
end

ServiceRecord.find_or_create_by!(equipment_item: tank1, service_date: Date.current - 4.months) do |s|
  s.service_type = :visual_inspection
  s.next_due_date = Date.current + 8.months
  s.performed_by = "PSI/PCI Inspector"
  s.description = "Annual VIP passed"
end

ServiceRecord.find_or_create_by!(equipment_item: tank1, service_date: Date.current - 2.years) do |s|
  s.service_type = :hydrostatic_test
  s.next_due_date = Date.current + 3.years
  s.performed_by = "Hydro Test Facility"
  s.cost_cents = 4_000
  s.description = "5-year hydrostatic test passed"
end

ServiceRecord.find_or_create_by!(equipment_item: comp1, service_date: Date.current - 1.month) do |s|
  s.service_type = :inspection
  s.next_due_date = Date.current + 11.months
  s.performed_by = "Shearwater Authorized Dealer"
  s.description = "Battery check and firmware update"
end

puts "  Service records: #{ServiceRecord.count}"

# --- Equipment Profiles ---
EquipmentProfile.find_or_create_by!(customer: jane) do |p|
  p.height_cm = 170
  p.weight_kg = 65.0
  p.wetsuit_size = "M"
  p.wetsuit_thickness_mm = 5
  p.bcd_size = "M"
  p.boot_size = "40"
  p.fin_size = "40"
  p.glove_size = "M"
  p.owns_mask = true
  p.owns_computer = true
end

EquipmentProfile.find_or_create_by!(customer: elena) do |p|
  p.height_cm = 165
  p.weight_kg = 58.0
  p.wetsuit_size = "S"
  p.wetsuit_thickness_mm = 5
  p.bcd_size = "S"
  p.boot_size = "38"
  p.fin_size = "38"
  p.glove_size = "S"
  p.owns_mask = true
  p.owns_wetsuit = true
  p.owns_fins = true
  p.owns_bcd = true
  p.owns_regulator = true
  p.owns_computer = true
  p.notes = "Has full personal gear"
end

EquipmentProfile.find_or_create_by!(customer: david) do |p|
  p.height_cm = 180
  p.weight_kg = 82.0
  p.wetsuit_size = "L"
  p.wetsuit_thickness_mm = 5
  p.bcd_size = "L"
  p.boot_size = "44"
  p.fin_size = "44"
  p.glove_size = "L"
  p.owns_mask = true
end

puts "  Equipment profiles: #{EquipmentProfile.count}"

# --- Customer Tanks ---
CustomerTank.find_or_create_by!(customer: elena, organization: org, serial_number: "LUX-E-001") do |t|
  t.manufacturer = "Luxfer"
  t.material = "aluminum"
  t.size = "AL80"
  t.last_vip_date = Date.current - 6.months
  t.vip_due_date = Date.current + 6.months
  t.last_hydro_date = Date.current - 2.years
  t.hydro_due_date = Date.current + 3.years
end

CustomerTank.find_or_create_by!(customer: elena, organization: org, serial_number: "FAB-E-002") do |t|
  t.manufacturer = "Faber"
  t.material = "steel"
  t.size = "HP100"
  t.last_vip_date = Date.current - 4.months
  t.vip_due_date = Date.current + 8.months
  t.last_hydro_date = Date.current - 1.year
  t.hydro_due_date = Date.current + 4.years
end

CustomerTank.find_or_create_by!(customer: maria, organization: org, serial_number: "CAT-M-001") do |t|
  t.manufacturer = "Catalina"
  t.material = "aluminum"
  t.size = "AL80"
  t.last_vip_date = Date.current - 14.months
  t.vip_due_date = Date.current - 2.months
  t.last_hydro_date = Date.current - 6.years
  t.hydro_due_date = Date.current - 1.year
  t.notes = "VIP and hydro both expired - do not fill"
end

CustomerTank.find_or_create_by!(customer: tom, organization: org, serial_number: "LUX-T-001") do |t|
  t.manufacturer = "Luxfer"
  t.material = "aluminum"
  t.size = "AL63"
  t.last_vip_date = Date.current - 3.months
  t.vip_due_date = Date.current + 9.months
  t.notes = "No hydro test on file - tank purchased used"
end

puts "  Customer tanks: #{org.customer_tanks.count}"

# --- Checklist Templates ---
pre_departure = ChecklistTemplate.find_or_create_by!(organization: org, title: "Pre-Departure Safety Check") do |t|
  t.description = "Safety items to verify before any boat departure. Required for all excursions."
  t.category = :safety
end

post_trip = ChecklistTemplate.find_or_create_by!(organization: org, title: "Post-Trip Equipment Accounting") do |t|
  t.description = "Account for all equipment and rinse after every trip."
  t.category = :safety
end

shop_open = ChecklistTemplate.find_or_create_by!(organization: org, title: "Shop Opening Procedures") do |t|
  t.description = "Daily shop opening checklist."
  t.category = :operational
end

shop_close = ChecklistTemplate.find_or_create_by!(organization: org, title: "Shop Closing Procedures") do |t|
  t.description = "Daily shop closing checklist."
  t.category = :operational
end

weekly_inspection = ChecklistTemplate.find_or_create_by!(organization: org, title: "Weekly Equipment Visual Inspection") do |t|
  t.description = "Weekly visual check of all rental life-support equipment."
  t.category = :compliance
end

puts "  Checklist templates: #{org.checklist_templates.count}"

# --- Checklist Items ---
# Pre-Departure Safety Check items
[
  { title: "O2 kit onboard and pressure > 500 PSI", position: 0, required: true },
  { title: "First aid kit stocked and sealed", position: 1, required: true },
  { title: "VHF radio charged and tested (Ch 16 check)", position: 2, required: true },
  { title: "Dive flag and alpha flag onboard", position: 3, required: true },
  { title: "Emergency action plan posted and current", position: 4, required: true },
  { title: "DAN emergency number posted", position: 5, required: true },
  { title: "Float/rescue tube accessible", position: 6, required: true },
  { title: "Headcount matches manifest", position: 7, required: true },
  { title: "All participants have signed waivers", position: 8, required: true },
  { title: "Weather and sea conditions reviewed", position: 9, required: true },
  { title: "Reef-safe sunscreen available for guests", position: 10, required: false },
  { title: "Water and snacks stocked", position: 11, required: false }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: pre_departure, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

# Post-Trip Equipment items
[
  { title: "All tanks accounted for and secured", position: 0, required: true },
  { title: "All rental gear returned and counted", position: 1, required: true },
  { title: "Rinse all equipment with fresh water", position: 2, required: true },
  { title: "Hang BCDs and wetsuits to dry", position: 3, required: true },
  { title: "Inspect regulators for damage or salt buildup", position: 4, required: true },
  { title: "Log any equipment issues for service", position: 5, required: true },
  { title: "Boat rinsed and fuel level noted", position: 6, required: false }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: post_trip, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

# Shop Opening items
[
  { title: "Turn on lights and AC", position: 0, required: true },
  { title: "Open cash register and count float", position: 1, required: true },
  { title: "Check phone and email for reservations", position: 2, required: true },
  { title: "Review today's schedule (excursions + classes)", position: 3, required: true },
  { title: "Unlock gear room and check rental inventory", position: 4, required: true }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: shop_open, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

# Shop Closing items
[
  { title: "Close and count cash register", position: 0, required: true },
  { title: "Lock gear room", position: 1, required: true },
  { title: "Confirm all rental gear returned", position: 2, required: true },
  { title: "Turn off AC and lights", position: 3, required: true },
  { title: "Set alarm and lock up", position: 4, required: true }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: shop_close, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

# Weekly Inspection items
[
  { title: "Inspect all BCD inflator mechanisms", position: 0, required: true },
  { title: "Check regulator second stages for free-flow", position: 1, required: true },
  { title: "Inspect tank valve O-rings", position: 2, required: true },
  { title: "Check dive computer batteries", position: 3, required: true },
  { title: "Inspect wetsuit zippers and seams", position: 4, required: false }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: weekly_inspection, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

puts "  Checklist items: #{ChecklistItem.count}"

# --- Checklist Runs (sample completed run for morning trip) ---
run = ChecklistRun.find_or_create_by!(
  organization: org,
  checklist_template: pre_departure,
  checkable: morning,
  slug: "pre-departure-safety-check-seed"
) do |r|
  r.started_by = owner
  r.status = :completed
  r.completed_at = Time.current - 30.minutes
  r.template_snapshot = {
    template: { id: pre_departure.id, title: pre_departure.title, category: pre_departure.category },
    items: pre_departure.checklist_items.order(:position).map { |i|
      { id: i.id, title: i.title, position: i.position, required: i.required }
    }
  }
end

# Create responses for the completed run
pre_departure.checklist_items.order(:position).each do |item|
  ChecklistResponse.find_or_create_by!(checklist_run: run, checklist_item: item) do |r|
    r.checked = true
    r.checked_at = Time.current - 35.minutes
    r.completed_by = owner
  end
end

puts "  Checklist runs: #{org.checklist_runs.count}"

puts "Done! Login with: oscar@abucear.mx / password"

# ===========================================================================
# TANIWHA DIVE -- Second shop for multi-tenant testing
# ===========================================================================
puts "\nSeeding Taniwha Dive..."

taniwha = Organization.find_or_create_by!(slug: "taniwha") do |o|
  o.name = "Taniwha Dive"
  o.subdomain = "taniwha"
  o.custom_domain = "taniwha.test"
  o.locale = "en"
  o.time_zone = "Pacific/Auckland"
end
puts "  Organization: #{taniwha.name} (#{taniwha.slug})"

# --- Users ---
tw_owner = User.find_or_create_by!(organization: taniwha, email_address: "aroha@taniwha.co.nz") do |u|
  u.name = "Aroha Ngata"
  u.password = "password"
  u.role = :owner
end
puts "  Owner: #{tw_owner.email_address} / password"

tw_manager = User.find_or_create_by!(organization: taniwha, email_address: "wiremu@taniwha.co.nz") do |u|
  u.name = "Wiremu Henare"
  u.password = "password"
  u.role = :manager
end
puts "  Manager: #{tw_manager.email_address} / password"

tw_kiri = User.find_or_create_by!(organization: taniwha, email_address: "kiri@taniwha.co.nz") do |u|
  u.name = "Kiri Tūhoe"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{tw_kiri.email_address} / password"

tw_hemi = User.find_or_create_by!(organization: taniwha, email_address: "hemi@taniwha.co.nz") do |u|
  u.name = "Hemi Parata"
  u.password = "password"
  u.role = :staff
end
puts "  Staff: #{tw_hemi.email_address} / password"

# --- Dive Sites ---
tw_knights = DiveSite.find_or_create_by!(organization: taniwha, name: "Poor Knights Islands") do |s|
  s.description = "World-class subtropical dive site. Massive archways, soft corals, and schooling fish. Jacques Cousteau's top 10."
  s.max_depth_meters = 40.0
  s.difficulty_level = :intermediate
  s.latitude = -35.4737
  s.longitude = 174.7310
  s.location_description = "24 km off Tutukaka coast, 45 min boat ride"
end

tw_rainbow = DiveSite.find_or_create_by!(organization: taniwha, name: "Rainbow Warrior") do |s|
  s.description = "Greenpeace ship scuttled in 1987 as an artificial reef. Covered in marine life."
  s.max_depth_meters = 26.0
  s.difficulty_level = :advanced
  s.latitude = -35.1547
  s.longitude = 174.2678
  s.location_description = "Matauri Bay, Cavalli Islands"
end

tw_rikoriko = DiveSite.find_or_create_by!(organization: taniwha, name: "Rikoriko Cave") do |s|
  s.description = "Largest known sea cave in the world. Stunning light effects and stingray encounters."
  s.max_depth_meters = 15.0
  s.difficulty_level = :beginner
  s.latitude = -35.4750
  s.longitude = 174.7350
  s.location_description = "Poor Knights Islands, northern archway"
end

tw_middle_arch = DiveSite.find_or_create_by!(organization: taniwha, name: "Middle Arch") do |s|
  s.description = "Spectacular swim-through archway with dense kelp forests and nudibranchs."
  s.max_depth_meters = 30.0
  s.difficulty_level = :intermediate
  s.latitude = -35.4760
  s.longitude = 174.7295
  s.location_description = "Poor Knights Islands, between Aorangi and Tawhiti Rahi"
end

puts "  Dive sites: #{taniwha.dive_sites.count}"

# --- Excursions ---
tw_tomorrow = Date.current + 1.day
tw_next_week = Date.current + 7.days

tw_knights_trip = Excursion.find_or_create_by!(organization: taniwha, title: "Poor Knights Discovery", scheduled_date: tw_tomorrow) do |e|
  e.description = "Two-tank dive exploring the archways and walls of the Poor Knights Islands."
  e.departure_time = "07:00"
  e.return_time = "14:00"
  e.capacity = 16
  e.price_cents = 28_000
  e.status = :published
end

tw_rainbow_trip = Excursion.find_or_create_by!(organization: taniwha, title: "Rainbow Warrior Wreck Dive", scheduled_date: tw_next_week) do |e|
  e.description = "Advanced wreck dive on the Rainbow Warrior. Two tanks, deep profiles."
  e.departure_time = "06:30"
  e.return_time = "15:00"
  e.capacity = 8
  e.price_cents = 35_000
  e.status = :published
end

tw_night_trip = Excursion.find_or_create_by!(organization: taniwha, title: "Night Dive - Tutukaka", scheduled_date: tw_next_week + 2.days) do |e|
  e.description = "Shore-entry night dive off the Tutukaka marina. Crayfish, octopus, and bioluminescence."
  e.departure_time = "19:30"
  e.return_time = "22:00"
  e.capacity = 6
  e.price_cents = 12_000
  e.status = :draft
end

puts "  Excursions: #{taniwha.excursions.count}"

# --- Trip Dives ---
TripDive.find_or_create_by!(excursion: tw_knights_trip, dive_number: 1) do |td|
  td.dive_site = tw_middle_arch
  td.planned_max_depth_meters = 25.0
  td.planned_bottom_time_minutes = 45
end

TripDive.find_or_create_by!(excursion: tw_knights_trip, dive_number: 2) do |td|
  td.dive_site = tw_rikoriko
  td.planned_max_depth_meters = 12.0
  td.planned_bottom_time_minutes = 55
  td.notes = "Shallower second dive inside the cave"
end

TripDive.find_or_create_by!(excursion: tw_rainbow_trip, dive_number: 1) do |td|
  td.dive_site = tw_rainbow
  td.planned_max_depth_meters = 24.0
  td.planned_bottom_time_minutes = 35
end

TripDive.find_or_create_by!(excursion: tw_rainbow_trip, dive_number: 2) do |td|
  td.dive_site = tw_rainbow
  td.planned_max_depth_meters = 16.0
  td.planned_bottom_time_minutes = 50
  td.notes = "Shallower second pass along the hull"
end

puts "  Trip dives: #{taniwha.excursions.sum { |e| e.trip_dives.count }}"

# --- Trip Participants ---
TripParticipant.find_or_create_by!(excursion: tw_knights_trip, name: "Sam Fletcher", role: :diver) do |tp|
  tp.email = "sam.fletcher@example.com"
  tp.phone = "+64-21-555-0101"
  tp.certification_level = "Open Water"
  tp.certification_agency = "PADI"
  tp.paid = true
end

TripParticipant.find_or_create_by!(excursion: tw_knights_trip, name: "Maia Tūhoe", role: :diver) do |tp|
  tp.email = "maia@example.com"
  tp.phone = "+64-21-555-0102"
  tp.certification_level = "Advanced Open Water"
  tp.certification_agency = "SSI"
  tp.paid = true
end

TripParticipant.find_or_create_by!(excursion: tw_knights_trip, name: "Hemi Parata", role: :divemaster) do |tp|
  tp.email = "hemi@taniwha.co.nz"
  tp.certification_level = "Divemaster"
  tp.certification_agency = "PADI"
  tp.paid = true
  tp.notes = "Staff guide"
end

puts "  Trip participants: #{taniwha.excursions.sum { |e| e.trip_participants.count }}"

# --- Customers ---
tw_sam = Customer.find_or_create_by!(organization: taniwha, email: "sam.fletcher@example.com") do |c|
  c.first_name = "Sam"
  c.last_name = "Fletcher"
  c.phone = "+64-21-555-0101"
  c.date_of_birth = "1991-03-12"
  c.emergency_contact_name = "Beth Fletcher"
  c.emergency_contact_phone = "+64-21-555-0100"
end

tw_maia = Customer.find_or_create_by!(organization: taniwha, email: "maia.tuhoe@example.com") do |c|
  c.first_name = "Maia"
  c.last_name = "Tūhoe"
  c.phone = "+64-21-555-0102"
  c.date_of_birth = "1994-07-28"
  c.emergency_contact_name = "Rangi Tūhoe"
  c.emergency_contact_phone = "+64-21-555-0103"
end

tw_liam = Customer.find_or_create_by!(organization: taniwha, email: "liam.odonnell@example.com") do |c|
  c.first_name = "Liam"
  c.last_name = "O'Donnell"
  c.phone = "+64-22-555-0201"
  c.date_of_birth = "1987-11-05"
  c.emergency_contact_name = "Fiona O'Donnell"
  c.emergency_contact_phone = "+64-22-555-0200"
  c.notes = "Experienced wreck diver, owns full gear"
end

tw_anika = Customer.find_or_create_by!(organization: taniwha, email: "anika.kumar@example.com") do |c|
  c.first_name = "Anika"
  c.last_name = "Kumar"
  c.phone = "+64-27-555-0301"
  c.date_of_birth = "2000-01-20"
  c.emergency_contact_name = "Priya Kumar"
  c.emergency_contact_phone = "+64-27-555-0300"
end

tw_jack = Customer.find_or_create_by!(organization: taniwha, email: "jack.wilson@example.com") do |c|
  c.first_name = "Jack"
  c.last_name = "Wilson"
  c.phone = "+64-21-555-0401"
  c.date_of_birth = "1979-09-15"
  c.emergency_contact_name = "Karen Wilson"
  c.emergency_contact_phone = "+64-21-555-0400"
  c.notes = "Local regular, dives weekly"
end

tw_yuna = Customer.find_or_create_by!(organization: taniwha, email: "yuna.park@example.com") do |c|
  c.first_name = "Yuna"
  c.last_name = "Park"
  c.phone = "+64-22-555-0501"
  c.date_of_birth = "1996-04-03"
  c.emergency_contact_name = "Jiwon Park"
  c.emergency_contact_phone = "+64-22-555-0500"
end

puts "  Customers: #{taniwha.customers.count}"

# --- Medical Records ---
MedicalRecord.find_or_create_by!(customer: tw_sam, clearance_date: Date.current - 1.month) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 11.months
  m.physician_name = "Dr. Patel"
end

MedicalRecord.find_or_create_by!(customer: tw_maia, clearance_date: Date.current - 3.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 9.months
  m.physician_name = "Dr. Harrison"
end

MedicalRecord.find_or_create_by!(customer: tw_liam, clearance_date: Date.current - 2.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 10.months
  m.physician_name = "Dr. Thompson"
end

MedicalRecord.find_or_create_by!(customer: tw_anika, clearance_date: Date.current - 5.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 7.months
  m.physician_name = "Dr. Patel"
end

MedicalRecord.find_or_create_by!(customer: tw_jack, clearance_date: Date.current - 11.months) do |m|
  m.status = :cleared
  m.expiration_date = Date.current + 1.month
  m.physician_name = "Dr. Harrison"
  m.notes = "Renewal coming up soon"
end

MedicalRecord.find_or_create_by!(customer: tw_yuna, clearance_date: Date.current - 1.week) do |m|
  m.status = :pending_review
  m.expiration_date = Date.current + 1.year
  m.physician_name = "Dr. Kim"
  m.notes = "New patient, awaiting records transfer"
end

puts "  Medical records: #{taniwha.customers.sum { |c| c.medical_records.count }}"

# --- Certifications ---
Certification.find_or_create_by!(customer: tw_sam, agency: "PADI", certification_level: "Open Water") do |c|
  c.certification_number = "PD-NZ-10001"
  c.issued_date = Date.current - 8.months
end

Certification.find_or_create_by!(customer: tw_maia, agency: "SSI", certification_level: "Advanced Adventurer") do |c|
  c.certification_number = "SSI-NZ-20001"
  c.issued_date = Date.current - 1.year
end

Certification.find_or_create_by!(customer: tw_liam, agency: "PADI", certification_level: "Rescue Diver") do |c|
  c.certification_number = "PD-NZ-30001"
  c.issued_date = Date.current - 3.years
end

Certification.find_or_create_by!(customer: tw_liam, agency: "PADI", certification_level: "Deep Diver") do |c|
  c.certification_number = "PD-NZ-30002"
  c.issued_date = Date.current - 2.years
end

Certification.find_or_create_by!(customer: tw_anika, agency: "SSI", certification_level: "Open Water") do |c|
  c.issued_date = Date.current - 4.months
end

Certification.find_or_create_by!(customer: tw_jack, agency: "NAUI", certification_level: "Master Diver") do |c|
  c.certification_number = "NAUI-NZ-40001"
  c.issued_date = Date.current - 8.years
end

Certification.find_or_create_by!(customer: tw_jack, agency: "PADI", certification_level: "Enriched Air Diver") do |c|
  c.issued_date = Date.current - 5.years
end

puts "  Certifications: #{taniwha.customers.sum { |c| c.certifications.count }}"

# --- Instructor Ratings ---
InstructorRating.find_or_create_by!(user: tw_owner, agency: "PADI", rating_level: "Open Water Scuba Instructor") do |r|
  r.rating_number = "OWSI-NZ-001"
  r.expiration_date = Date.current + 14.months
end

InstructorRating.find_or_create_by!(user: tw_owner, agency: "SSI", rating_level: "Instructor") do |r|
  r.rating_number = "SSI-NZ-002"
  r.expiration_date = Date.current + 10.months
end

InstructorRating.find_or_create_by!(user: tw_manager, agency: "PADI", rating_level: "Divemaster") do |r|
  r.rating_number = "DM-NZ-003"
  r.expiration_date = Date.current + 8.months
end

InstructorRating.find_or_create_by!(user: tw_hemi, agency: "PADI", rating_level: "Divemaster") do |r|
  r.rating_number = "DM-NZ-004"
  r.expiration_date = Date.current + 11.months
end

InstructorRating.find_or_create_by!(user: tw_kiri, agency: "NAUI", rating_level: "Instructor") do |r|
  r.rating_number = "NAUI-NZ-005"
  r.expiration_date = Date.current + 1.year
end

puts "  Instructor ratings: #{taniwha.users.sum { |u| u.instructor_ratings.count }}"

# --- Courses ---
tw_ow = Course.find_or_create_by!(organization: taniwha, name: "PADI Open Water Diver") do |c|
  c.description = "Learn to dive in the stunning waters of Northland. Four days of theory, pool, and ocean dives."
  c.agency = "PADI"
  c.level = "Open Water"
  c.course_type = :certification
  c.min_age = 10
  c.max_students = 6
  c.duration_days = 4
  c.price_cents = 69_900
  c.price_currency = "NZD"
end

tw_aow = Course.find_or_create_by!(organization: taniwha, name: "PADI Advanced Open Water") do |c|
  c.description = "Five adventure dives including deep and navigation at the Poor Knights."
  c.agency = "PADI"
  c.level = "Advanced Open Water"
  c.course_type = :certification
  c.min_age = 12
  c.max_students = 8
  c.duration_days = 2
  c.price_cents = 59_900
  c.price_currency = "NZD"
end

tw_nitrox = Course.find_or_create_by!(organization: taniwha, name: "SSI Enriched Air Nitrox") do |c|
  c.description = "Extend your bottom time with enriched air. Theory plus two optional nitrox dives."
  c.agency = "SSI"
  c.level = "Specialty"
  c.course_type = :specialty
  c.max_students = 10
  c.price_cents = 29_900
  c.price_currency = "NZD"
end

tw_discover = Course.find_or_create_by!(organization: taniwha, name: "Discover Scuba Diving") do |c|
  c.description = "Try scuba for the first time in a sheltered bay. No experience needed."
  c.agency = "PADI"
  c.level = "Introductory"
  c.course_type = :non_certification
  c.max_students = 4
  c.duration_days = 1
  c.price_cents = 24_900
  c.price_currency = "NZD"
end

puts "  Courses: #{taniwha.courses.count}"

# --- Course Offerings ---
tw_ow_offering = CourseOffering.find_or_create_by!(
  course: tw_ow,
  organization: taniwha,
  start_date: Date.current + 10.days
) do |o|
  o.instructor = tw_owner
  o.end_date = Date.current + 14.days
  o.max_students = 6
  o.status = :published
end

tw_nitrox_offering = CourseOffering.find_or_create_by!(
  course: tw_nitrox,
  organization: taniwha,
  start_date: Date.current + 5.days
) do |o|
  o.instructor = tw_kiri
  o.end_date = Date.current + 5.days
  o.max_students = 8
  o.status = :published
end

tw_discover_offering = CourseOffering.find_or_create_by!(
  course: tw_discover,
  organization: taniwha,
  start_date: Date.current + 2.days
) do |o|
  o.instructor = tw_hemi
  o.end_date = Date.current + 2.days
  o.max_students = 4
  o.status = :published
  o.notes = "Weekend session"
end

puts "  Course offerings: #{taniwha.course_offerings.count}"

# --- Class Sessions ---
ClassSession.find_or_create_by!(course_offering: tw_ow_offering, scheduled_date: Date.current + 10.days, start_time: "09:00") do |s|
  s.session_type = :classroom
  s.title = "Module 1: Dive Theory & Planning"
  s.end_time = "13:00"
  s.location_description = "Taniwha Dive classroom, Tutukaka Marina"
end

ClassSession.find_or_create_by!(course_offering: tw_ow_offering, scheduled_date: Date.current + 11.days, start_time: "08:00") do |s|
  s.session_type = :confined_water
  s.title = "Confined Water Dives 1 & 2"
  s.end_time = "12:00"
  s.location_description = "Tutukaka heated pool"
end

ClassSession.find_or_create_by!(course_offering: tw_ow_offering, scheduled_date: Date.current + 13.days, start_time: "07:00") do |s|
  s.session_type = :open_water
  s.title = "Open Water Dives 1 & 2"
  s.end_time = "14:00"
  s.dive_site = tw_rikoriko
end

ClassSession.find_or_create_by!(course_offering: tw_ow_offering, scheduled_date: Date.current + 14.days, start_time: "07:00") do |s|
  s.session_type = :open_water
  s.title = "Open Water Dives 3 & 4"
  s.end_time = "14:00"
  s.dive_site = tw_knights
end

puts "  Class sessions: #{taniwha.course_offerings.sum { |o| o.class_sessions.count }}"

# --- Enrollments ---
Enrollment.find_or_create_by!(course_offering: tw_ow_offering, customer: tw_sam) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 5.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: tw_ow_offering, customer: tw_yuna) do |e|
  e.status = :pending
  e.enrolled_at = Time.current - 1.day
  e.paid = false
  e.notes = "Waiting on medical clearance"
end

Enrollment.find_or_create_by!(course_offering: tw_nitrox_offering, customer: tw_maia) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 3.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: tw_nitrox_offering, customer: tw_jack) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 2.days
  e.paid = true
end

Enrollment.find_or_create_by!(course_offering: tw_discover_offering, customer: tw_anika) do |e|
  e.status = :confirmed
  e.enrolled_at = Time.current - 1.day
  e.paid = true
end

puts "  Enrollments: #{taniwha.course_offerings.sum { |o| o.enrollments.count }}"

# --- Equipment Items ---
tw_bcd1 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-BCD-001") do |e|
  e.category = :bcd
  e.name = "Cressi Start BCD #1"
  e.size = "M"
  e.manufacturer = "Cressi"
  e.product_model = "Start"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 8.months
end

tw_bcd2 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-BCD-002") do |e|
  e.category = :bcd
  e.name = "Cressi Start BCD #2"
  e.size = "L"
  e.manufacturer = "Cressi"
  e.product_model = "Start"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 8.months
end

tw_reg1 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-REG-001") do |e|
  e.category = :regulator
  e.name = "Aqualung Calypso Reg #1"
  e.manufacturer = "Aqualung"
  e.product_model = "Calypso"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 1.year
end

tw_reg2 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-REG-002") do |e|
  e.category = :regulator
  e.name = "Aqualung Calypso Reg #2"
  e.manufacturer = "Aqualung"
  e.product_model = "Calypso"
  e.status = :in_service
  e.life_support = true
  e.purchase_date = Date.current - 1.year
  e.notes = "Sent for annual service"
end

tw_tank1 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-TANK-001") do |e|
  e.category = :tank
  e.name = "AL80 Tank #1"
  e.size = "AL80"
  e.manufacturer = "Luxfer"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 2.years
end

tw_tank2 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-TANK-002") do |e|
  e.category = :tank
  e.name = "AL80 Tank #2"
  e.size = "AL80"
  e.manufacturer = "Luxfer"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 2.years
end

tw_comp1 = EquipmentItem.find_or_create_by!(organization: taniwha, serial_number: "TW-COMP-001") do |e|
  e.category = :computer
  e.name = "Suunto Zoop Novo #1"
  e.manufacturer = "Suunto"
  e.product_model = "Zoop Novo"
  e.status = :available
  e.life_support = true
  e.purchase_date = Date.current - 6.months
end

4.times do |i|
  EquipmentItem.find_or_create_by!(organization: taniwha, name: "Fins M ##{i + 1}") do |e|
    e.category = :fins
    e.size = "M"
    e.manufacturer = "Mares"
    e.product_model = "Avanti Quattro"
    e.status = :available
    e.life_support = false
  end
end

4.times do |i|
  EquipmentItem.find_or_create_by!(organization: taniwha, name: "Wetsuit 7mm M ##{i + 1}") do |e|
    e.category = :wetsuit
    e.size = "M"
    e.manufacturer = "Aqualung"
    e.product_model = "AquaFlex 7mm"
    e.status = :available
    e.life_support = false
  end
end

puts "  Equipment items: #{taniwha.equipment_items.count}"

# --- Service Records ---
ServiceRecord.find_or_create_by!(equipment_item: tw_bcd1, service_date: Date.current - 2.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 10.months
  s.performed_by = "NZ Dive Service Centre"
  s.cost_cents = 18_000
  s.description = "Annual service and inspection"
end

ServiceRecord.find_or_create_by!(equipment_item: tw_reg1, service_date: Date.current - 4.months) do |s|
  s.service_type = :annual_service
  s.next_due_date = Date.current + 8.months
  s.performed_by = "Aqualung NZ Authorized"
  s.cost_cents = 22_000
  s.description = "Full regulator overhaul"
end

ServiceRecord.find_or_create_by!(equipment_item: tw_tank1, service_date: Date.current - 5.months) do |s|
  s.service_type = :visual_inspection
  s.next_due_date = Date.current + 7.months
  s.performed_by = "Dive NZ Inspector"
  s.description = "Annual VIP passed"
end

puts "  Service records: #{taniwha.equipment_items.sum { |e| e.service_records.count }}"

# --- Checklist Templates ---
tw_pre_dep = ChecklistTemplate.find_or_create_by!(organization: taniwha, title: "Pre-Departure Safety Check") do |t|
  t.description = "Safety items to verify before any boat departure from Tutukaka Marina."
  t.category = :safety
end

tw_post_trip = ChecklistTemplate.find_or_create_by!(organization: taniwha, title: "Post-Trip Gear Wash") do |t|
  t.description = "Equipment accounting and freshwater rinse after every trip."
  t.category = :safety
end

puts "  Checklist templates: #{taniwha.checklist_templates.count}"

# --- Checklist Items ---
[
  { title: "O2 kit onboard and pressure checked", position: 0, required: true },
  { title: "First aid kit stocked", position: 1, required: true },
  { title: "VHF radio charged and tested", position: 2, required: true },
  { title: "Dive flag onboard", position: 3, required: true },
  { title: "Emergency action plan posted", position: 4, required: true },
  { title: "Headcount matches manifest", position: 5, required: true },
  { title: "Weather and sea forecast reviewed", position: 6, required: true },
  { title: "Hot drinks and snacks stocked", position: 7, required: false }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: tw_pre_dep, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

[
  { title: "All tanks accounted for", position: 0, required: true },
  { title: "All rental gear returned and counted", position: 1, required: true },
  { title: "Freshwater rinse all equipment", position: 2, required: true },
  { title: "Hang BCDs and wetsuits to dry", position: 3, required: true },
  { title: "Log any equipment issues", position: 4, required: true }
].each do |attrs|
  ChecklistItem.find_or_create_by!(checklist_template: tw_post_trip, title: attrs[:title]) do |i|
    i.position = attrs[:position]
    i.required = attrs[:required]
  end
end

puts "  Checklist items: #{taniwha.checklist_templates.sum { |t| t.checklist_items.count }}"

puts "Done! Login with: aroha@taniwha.co.nz / password"
