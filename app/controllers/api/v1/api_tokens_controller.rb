# frozen_string_literal: true

module Api
  module V1
    class ApiTokensController < BaseController
      def index
        @api_tokens = current_user.api_tokens.order(created_at: :desc)
      end

      def create
        @api_token, @plain_token = ApiToken.generate_token_pair(
          user: current_user,
          name: params[:name] || "API Token",
          expires_at: params[:expires_at]
        )
        render :create, status: :created
      end

      def destroy
        token = current_user.api_tokens.find(params[:id])
        token.revoke!
        head :no_content
      end
    end
  end
end
