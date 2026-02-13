# frozen_string_literal: true

class OnboardingChecklist
  Step = Data.define(:key, :title, :description, :path, :completed)

  attr_reader :organization, :steps

  def initialize(organization:)
    @organization = organization
    @steps = build_steps
  end

  def complete?
    @steps.all?(&:completed)
  end

  def progress_percentage
    return 0 if @steps.empty?
    (completed_count.to_f / @steps.size * 100).round
  end

  def completed_count
    @steps.count(&:completed)
  end

  def total_count
    @steps.size
  end

  private

  def build_steps
    [
      Step.new(
        key: :add_dive_site,
        title: I18n.t("onboarding.checklist.steps.add_dive_site.title"),
        description: I18n.t("onboarding.checklist.steps.add_dive_site.description"),
        path: :new_dive_site_path,
        completed: organization.dive_sites.exists?
      ),
      Step.new(
        key: :add_staff,
        title: I18n.t("onboarding.checklist.steps.add_staff.title"),
        description: I18n.t("onboarding.checklist.steps.add_staff.description"),
        path: :new_user_path,
        completed: organization.users.where.not(role: :owner).exists?
      ),
      Step.new(
        key: :schedule_excursion,
        title: I18n.t("onboarding.checklist.steps.schedule_excursion.title"),
        description: I18n.t("onboarding.checklist.steps.schedule_excursion.description"),
        path: :new_excursion_path,
        completed: organization.excursions.exists?
      ),
      Step.new(
        key: :create_course,
        title: I18n.t("onboarding.checklist.steps.create_course.title"),
        description: I18n.t("onboarding.checklist.steps.create_course.description"),
        path: :new_course_path,
        completed: organization.courses.exists?
      ),
      Step.new(
        key: :add_customer,
        title: I18n.t("onboarding.checklist.steps.add_customer.title"),
        description: I18n.t("onboarding.checklist.steps.add_customer.description"),
        path: :new_customer_path,
        completed: organization.customers.exists?
      ),
      Step.new(
        key: :invite_team,
        title: I18n.t("onboarding.checklist.steps.invite_team.title"),
        description: I18n.t("onboarding.checklist.steps.invite_team.description"),
        path: :new_user_invitation_path,
        completed: UserInvitation.where(organization_id: organization.id).exists?
      ),
      Step.new(
        key: :set_branding,
        title: I18n.t("onboarding.checklist.steps.set_branding.title"),
        description: I18n.t("onboarding.checklist.steps.set_branding.description"),
        path: :settings_domain_path,
        completed: organization.brand_primary_color.present?
      )
    ]
  end
end
