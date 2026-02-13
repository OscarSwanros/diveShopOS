# frozen_string_literal: true

module Onboarding
  class ClearDemoData
    DEMO_TAG = "demo"

    def initialize(organization:)
      @org = organization
    end

    def call
      ActiveRecord::Base.transaction do
        # Destroy in dependency order: children before parents

        # Enrollments reference customers and course offerings
        Enrollment.joins(:course_offering)
          .where(course_offerings: { organization_id: @org.id })
          .where(course_offerings: { notes: DEMO_TAG })
          .destroy_all

        # Course offerings (have notes field)
        @org.course_offerings.where(notes: DEMO_TAG).destroy_all

        # Trip participants are on excursions (excursions have notes field)
        excursion_ids = @org.excursions.where(notes: DEMO_TAG).pluck(:id)
        TripParticipant.where(excursion_id: excursion_ids).destroy_all
        TripDive.where(excursion_id: excursion_ids).destroy_all
        @org.excursions.where(notes: DEMO_TAG).destroy_all

        # Medical records and certifications (notes field on customer)
        customer_ids = @org.customers.where(notes: DEMO_TAG).pluck(:id)
        MedicalRecord.where(customer_id: customer_ids).destroy_all
        Certification.where(customer_id: customer_ids).destroy_all
        @org.customers.where(notes: DEMO_TAG).destroy_all

        # Equipment (notes field)
        @org.equipment_items.where(notes: DEMO_TAG).destroy_all

        # Courses with no remaining offerings and demo names
        demo_course_names = [ "Open Water Diver", "Deep Diver Specialty" ]
        @org.courses.where(name: demo_course_names).where.not(
          id: CourseOffering.where(organization_id: @org.id).select(:course_id)
        ).destroy_all

        # Dive sites (location_description field used as tag)
        @org.dive_sites.where(location_description: DEMO_TAG).destroy_all

        # Staff (demo users have example.com emails, never the owner)
        demo_user_ids = @org.users.where.not(role: :owner).where("email_address LIKE ?", "%@example.com").pluck(:id)
        InstructorRating.where(user_id: demo_user_ids).destroy_all
        @org.users.where(id: demo_user_ids).destroy_all
      end
    end
  end
end
