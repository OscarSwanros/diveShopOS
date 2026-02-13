# frozen_string_literal: true

module Onboarding
  class SeedDemoData
    DEMO_TAG = "demo"

    def initialize(organization:)
      @org = organization
    end

    def call
      ActiveRecord::Base.transaction do
        seed_dive_sites
        seed_staff
        seed_customers
        seed_equipment
        seed_courses
        seed_excursions
      end

      @org.update!(onboarding_dismissed: false)
    end

    private

    def seed_dive_sites
      @reef = @org.dive_sites.create!(
        name: "Coral Gardens Reef",
        difficulty_level: :beginner,
        max_depth_meters: 12,
        description: "Shallow reef with colorful coral formations. Great for beginners and snorkelers.",
        location_description: DEMO_TAG
      )

      @wall = @org.dive_sites.create!(
        name: "Blue Wall",
        difficulty_level: :advanced,
        max_depth_meters: 40,
        description: "Dramatic wall dive starting at 15m. Strong currents possible. Advanced certification required.",
        location_description: DEMO_TAG
      )

      @cenote = @org.dive_sites.create!(
        name: "Cenote Cristal",
        difficulty_level: :intermediate,
        max_depth_meters: 22,
        description: "Crystal-clear cenote with cavern entrance. Stunning light effects in the morning.",
        location_description: DEMO_TAG
      )
    end

    def seed_staff
      @instructor = @org.users.create!(
        name: "Maria Torres",
        email_address: "maria@example.com",
        password: "password123",
        password_confirmation: "password123",
        role: :staff
      )

      InstructorRating.create!(
        user: @instructor,
        agency: "PADI",
        rating_level: "Open Water Instructor",
        rating_number: "PADI-384729",
        expiration_date: 8.months.from_now.to_date,
        active: true
      )

      @divemaster = @org.users.create!(
        name: "Jake Morrison",
        email_address: "jake@example.com",
        password: "password123",
        password_confirmation: "password123",
        role: :staff
      )

      InstructorRating.create!(
        user: @divemaster,
        agency: "SSI",
        rating_level: "Dive Guide",
        rating_number: "SSI-109283",
        expiration_date: 1.year.from_now.to_date,
        active: true
      )
    end

    def seed_customers
      @sarah = create_customer(
        first_name: "Sarah", last_name: "Chen",
        email: "sarah.chen@example.com",
        date_of_birth: 30.years.ago.to_date,
        phone: "555-0101"
      )
      add_certification(@sarah, agency: "PADI", level: "Advanced Open Water")
      add_medical_clearance(@sarah, status: :cleared, expiration_date: 6.months.from_now.to_date)

      @expired_medical = create_customer(
        first_name: "Tom", last_name: "Baker",
        email: "tom.baker@example.com",
        date_of_birth: 45.years.ago.to_date,
        phone: "555-0102"
      )
      add_certification(@expired_medical, agency: "SSI", level: "Open Water")
      add_medical_clearance(@expired_medical, status: :expired, expiration_date: 3.months.ago.to_date)

      @minor = create_customer(
        first_name: "Alex", last_name: "Rodriguez",
        email: "alex.parent@example.com",
        date_of_birth: 13.years.ago.to_date,
        phone: "555-0103",
        emergency_contact_name: "Carlos Rodriguez",
        emergency_contact_phone: "555-0104"
      )

      @uncertified = create_customer(
        first_name: "Emily", last_name: "Park",
        email: "emily.park@example.com",
        date_of_birth: 28.years.ago.to_date,
        phone: "555-0105"
      )

      @experienced = create_customer(
        first_name: "Marcus", last_name: "Williams",
        email: "marcus.w@example.com",
        date_of_birth: 35.years.ago.to_date,
        phone: "555-0106"
      )
      add_certification(@experienced, agency: "PADI", level: "Rescue Diver")
      add_medical_clearance(@experienced, status: :cleared, expiration_date: 10.months.from_now.to_date)
    end

    def seed_equipment
      @org.equipment_items.create!(
        name: "Reg Set Alpha",
        category: :regulator,
        serial_number: "REG-2024-001",
        status: :available,
        life_support: true,
        manufacturer: "Aqualung",
        product_model: "Core Supreme",
        last_service_date: 2.years.ago.to_date,
        next_service_due: 3.months.ago.to_date,
        notes: DEMO_TAG
      )

      @org.equipment_items.create!(
        name: "BCD Explorer Pro",
        category: :bcd,
        serial_number: "BCD-2024-001",
        status: :available,
        life_support: true,
        manufacturer: "ScubaPro",
        product_model: "Hydros Pro",
        last_service_date: 6.months.ago.to_date,
        next_service_due: 6.months.from_now.to_date,
        notes: DEMO_TAG
      )

      @org.equipment_items.create!(
        name: "Computer Zoop",
        category: :computer,
        serial_number: "CMP-2024-001",
        status: :available,
        life_support: true,
        manufacturer: "Suunto",
        product_model: "Zoop Novo",
        last_service_date: 3.months.ago.to_date,
        next_service_due: 9.months.from_now.to_date,
        notes: DEMO_TAG
      )

      @org.equipment_items.create!(
        name: "Wetsuit 5mm #3",
        category: :wetsuit,
        size: "L",
        status: :available,
        life_support: false,
        notes: DEMO_TAG
      )
    end

    def seed_courses
      ow_course = @org.courses.create!(
        name: "Open Water Diver",
        agency: "PADI",
        level: "Open Water",
        course_type: :certification,
        max_students: 6,
        min_age: 15,
        duration_days: 4,
        price_cents: 45000,
        price_currency: "USD",
        description: "The world's most popular entry-level scuba certification. Learn to dive to 18 meters.",
        active: true
      )

      offering = @org.course_offerings.create!(
        course: ow_course,
        instructor: @instructor,
        start_date: 5.days.from_now.to_date,
        end_date: 9.days.from_now.to_date,
        max_students: 6,
        status: :published,
        notes: DEMO_TAG
      )

      Enrollment.create!(
        course_offering: offering,
        customer: @uncertified,
        status: :confirmed,
        enrolled_at: 2.days.ago
      )

      @org.courses.create!(
        name: "Deep Diver Specialty",
        agency: "PADI",
        level: "Deep Diver",
        course_type: :specialty,
        max_students: 4,
        min_age: 18,
        duration_days: 2,
        price_cents: 30000,
        price_currency: "USD",
        description: "Learn the techniques for deep diving between 18m and 40m safely.",
        active: true
      )
    end

    def seed_excursions
      tomorrow_trip = @org.excursions.create!(
        title: "Morning Reef Dive",
        scheduled_date: Date.tomorrow,
        departure_time: "08:00",
        return_time: "12:30",
        capacity: 8,
        status: :published,
        price_cents: 12000,
        price_currency: "USD",
        description: "Two-tank reef dive at Coral Gardens. Suitable for all certification levels.",
        notes: DEMO_TAG
      )

      tomorrow_trip.trip_dives.create!(
        dive_number: 1,
        dive_site: @reef,
        planned_max_depth_meters: 12,
        planned_bottom_time_minutes: 50
      )

      tomorrow_trip.trip_participants.create!(
        name: @sarah.full_name,
        email: @sarah.email,
        customer: @sarah,
        role: :diver,
        paid: true,
        certification_level: "Advanced Open Water",
        certification_agency: "PADI"
      )

      tomorrow_trip.trip_participants.create!(
        name: @expired_medical.full_name,
        email: @expired_medical.email,
        customer: @expired_medical,
        role: :diver,
        paid: false,
        certification_level: "Open Water",
        certification_agency: "SSI"
      )

      tomorrow_trip.trip_participants.create!(
        name: @experienced.full_name,
        email: @experienced.email,
        customer: @experienced,
        role: :diver,
        paid: true,
        certification_level: "Rescue Diver",
        certification_agency: "PADI"
      )

      next_week_trip = @org.excursions.create!(
        title: "Wall Dive Adventure",
        scheduled_date: 7.days.from_now.to_date,
        departure_time: "07:00",
        return_time: "14:00",
        capacity: 6,
        status: :published,
        price_cents: 18000,
        price_currency: "USD",
        description: "Advanced wall dive for certified divers. Two dives with surface interval.",
        notes: DEMO_TAG
      )

      next_week_trip.trip_dives.create!(
        dive_number: 1,
        dive_site: @wall,
        planned_max_depth_meters: 35,
        planned_bottom_time_minutes: 30
      )
    end

    def create_customer(first_name:, last_name:, email:, date_of_birth:, phone:, emergency_contact_name: nil, emergency_contact_phone: nil)
      @org.customers.create!(
        first_name: first_name,
        last_name: last_name,
        email: email,
        date_of_birth: date_of_birth,
        phone: phone,
        emergency_contact_name: emergency_contact_name,
        emergency_contact_phone: emergency_contact_phone,
        notes: DEMO_TAG
      )
    end

    def add_certification(customer, agency:, level:)
      customer.certifications.create!(
        agency: agency,
        certification_level: level,
        issued_date: 2.years.ago.to_date,
        notes: DEMO_TAG
      )
    end

    def add_medical_clearance(customer, status:, expiration_date:)
      customer.medical_records.create!(
        status: status,
        clearance_date: 1.year.ago.to_date,
        expiration_date: expiration_date,
        physician_name: "Dr. Smith",
        notes: DEMO_TAG
      )
    end
  end
end
