# frozen_string_literal: true

module Public
  class CancellationsController < Public::BaseController
    before_action :require_customer_authentication

    def cancel_enrollment
    end

    def cancel_join
    end
  end
end
