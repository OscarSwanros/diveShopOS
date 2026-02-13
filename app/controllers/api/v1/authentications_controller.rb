# frozen_string_literal: true

module Api
  module V1
    class AuthenticationsController < BaseController
      skip_before_action :authenticate_api_token!, only: [ :create ]

      def create
        user = User.find_by(email_address: params[:email])

        if user&.authenticate(params[:password])
          @api_token, @plain_token = ApiToken.generate_token_pair(
            user: user,
            name: params[:name] || "API Token"
          )
          render :create, status: :created
        else
          render json: {
            error: { code: "invalid_credentials", message: I18n.t("api.errors.invalid_credentials") }
          }, status: :unauthorized
        end
      end
    end
  end
end
