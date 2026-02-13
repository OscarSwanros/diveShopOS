# frozen_string_literal: true

module Public
  class JoinWaitlist
    Result = Data.define(:success, :waitlist_entry, :error)

    def initialize(customer:, waitlistable:)
      @customer = customer
      @waitlistable = waitlistable
    end

    def call
      organization = @waitlistable.organization

      existing = WaitlistEntry.waiting.find_by(
        customer: @customer,
        waitlistable: @waitlistable
      )
      return Result.new(success: false, waitlist_entry: nil, error: I18n.t("public.waitlist.already_on_list")) if existing

      next_position = @waitlistable.waitlist_entries.maximum(:position).to_i + 1

      entry = WaitlistEntry.new(
        organization: organization,
        customer: @customer,
        waitlistable: @waitlistable,
        position: next_position
      )

      if entry.save
        Result.new(success: true, waitlist_entry: entry, error: nil)
      else
        Result.new(success: false, waitlist_entry: nil, error: entry.errors.full_messages.join(", "))
      end
    end
  end
end
