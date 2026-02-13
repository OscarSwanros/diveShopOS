# frozen_string_literal: true

module Onboarding
  class CreateShop
    Result = Data.define(:success, :organization, :user, :error)

    def initialize(shop_name:, owner_name:, email:, password:, password_confirmation:)
      @shop_name = shop_name.to_s.strip
      @owner_name = owner_name.to_s.strip
      @email = email.to_s.strip.downcase
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      if @shop_name.blank? || @owner_name.blank? || @email.blank?
        return Result.new(success: false, organization: nil, user: nil,
          error: I18n.t("onboarding.registration.errors.fields_required"))
      end

      if @password != @password_confirmation
        return Result.new(success: false, organization: nil, user: nil,
          error: I18n.t("onboarding.registration.errors.password_mismatch"))
      end

      slug = generate_unique_slug(@shop_name)

      ActiveRecord::Base.transaction do
        organization = Organization.create!(
          name: @shop_name,
          slug: slug,
          locale: "en",
          time_zone: "UTC"
        )

        user = User.create!(
          organization: organization,
          name: @owner_name,
          email_address: @email,
          password: @password,
          password_confirmation: @password_confirmation,
          role: :owner
        )

        Result.new(success: true, organization: organization, user: user, error: nil)
      end
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, organization: nil, user: nil, error: e.record.errors.full_messages.join(", "))
    end

    private

    def generate_unique_slug(name)
      base_slug = name.parameterize
      base_slug = "shop" if base_slug.blank?

      slug = base_slug
      counter = 1

      while Organization.exists?(slug: slug) || Organization::RESERVED_SUBDOMAINS.include?(slug)
        slug = "#{base_slug}-#{counter}"
        counter += 1
      end

      slug
    end
  end
end
