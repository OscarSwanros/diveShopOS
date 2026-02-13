# frozen_string_literal: true

class DashboardController < ApplicationController
  def show
    authorize :dashboard, :show?

    load_todays_schedule
    load_safety_alerts
    load_upcoming
    load_quick_stats
  end

  private

  def load_todays_schedule
    @todays_excursions = current_organization.excursions
      .where(scheduled_date: Date.current, status: :published)
      .includes(:trip_participants)
      .order(:departure_time)

    @todays_class_sessions = ClassSession
      .joins(course_offering: :course)
      .where(course_offerings: { organization_id: current_organization.id })
      .where(scheduled_date: Date.current)
      .includes(course_offering: [ :course, :instructor ])
      .by_date
  end

  def load_safety_alerts
    @equipment_overdue_count = current_organization.equipment_items
      .active.where(life_support: true)
      .where("next_service_due < ? OR next_service_due IS NULL", Date.current)
      .count

    @medical_pending_count = MedicalRecord
      .joins(:customer)
      .where(customers: { organization_id: current_organization.id })
      .kept.pending_review
      .count

    @ratings_expiring_count = InstructorRating
      .joins(:user)
      .where(users: { organization_id: current_organization.id })
      .active
      .where(expiration_date: Date.current..30.days.from_now.to_date)
      .count

    tanks = current_organization.customer_tanks
    @tanks_noncompliant_count = tanks.vip_expired.or(tanks.hydro_expired).count
  end

  def load_upcoming
    @upcoming_excursions = current_organization.excursions
      .where(scheduled_date: (Date.tomorrow)..(Date.current + 7.days))
      .where(status: [ :published, :draft ])
      .includes(:trip_participants)
      .order(:scheduled_date, :departure_time)
      .limit(5)

    base = current_organization.course_offerings
    @upcoming_offerings = base.where("start_date >= ?", Date.current)
      .or(base.where(status: :in_progress))
      .includes(:course, :instructor, :enrollments)
      .order(:start_date)
      .limit(5)
  end

  def load_quick_stats
    @active_customers_count = current_organization.customers.active.count
    @equipment_count = current_organization.equipment_items.active.count
    @life_support_count = current_organization.equipment_items.active.where(life_support: true).count

    @active_enrollments_count = Enrollment
      .joins(:course_offering)
      .where(course_offerings: { organization_id: current_organization.id })
      .active_enrollments
      .count

    @unpaid_trip_spots_count = TripParticipant
      .joins(:excursion)
      .where(excursions: { organization_id: current_organization.id, status: :published })
      .where("excursions.scheduled_date >= ?", Date.current)
      .where(paid: false)
      .count

    @unpaid_enrollments_count = Enrollment
      .joins(:course_offering)
      .where(course_offerings: { organization_id: current_organization.id })
      .active_enrollments
      .where(paid: false)
      .count
  end
end
