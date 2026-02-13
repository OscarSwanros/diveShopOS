# frozen_string_literal: true

module Public
  class CreateCustomerAccount
    Result = Data.define(:success, :customer_account, :error)

    def initialize(organization:, email:, password:, password_confirmation:, first_name:, last_name:)
      @organization = organization
      @email = email.to_s.strip.downcase
      @password = password
      @password_confirmation = password_confirmation
      @first_name = first_name
      @last_name = last_name
    end

    def call
      existing_customer = @organization.customers.find_by(email: @email)

      if existing_customer&.customer_account
        return Result.new(
          success: false,
          customer_account: nil,
          error: I18n.t("public.registrations.already_registered")
        )
      end

      ActiveRecord::Base.transaction do
        customer = existing_customer || @organization.customers.create!(
          first_name: @first_name,
          last_name: @last_name,
          email: @email,
          active: true
        )

        account = @organization.customer_accounts.build(
          customer: customer,
          email: @email,
          password: @password,
          password_confirmation: @password_confirmation
        )

        if account.save
          Result.new(success: true, customer_account: account, error: nil)
        else
          Result.new(success: false, customer_account: account, error: account.errors.full_messages.join(", "))
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Result.new(success: false, customer_account: nil, error: e.record.errors.full_messages.join(", "))
    end
  end
end
