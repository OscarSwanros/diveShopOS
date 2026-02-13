# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Pundit::Authorization

      before_action :authenticate_api_token!

      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
      rescue_from Pundit::NotAuthorizedError, with: :render_forbidden
      rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

      private

      def authenticate_api_token!
        token_string = extract_bearer_token
        api_token = ApiToken.find_by_plain_token(token_string)

        if api_token
          api_token.touch_last_used!
          Current.user = api_token.user
          Current.organization = api_token.user.organization
        else
          render json: { error: { code: "unauthorized", message: I18n.t("api.errors.unauthorized") } }, status: :unauthorized
        end
      end

      def extract_bearer_token
        header = request.headers["Authorization"]
        header&.match(/\ABearer (.+)\z/)&.captures&.first
      end

      def current_user
        Current.user
      end

      def current_organization
        Current.organization
      end

      def pundit_user
        current_user
      end

      def render_not_found(exception)
        render json: { error: { code: "not_found", message: I18n.t("api.errors.not_found") } }, status: :not_found
      end

      def render_record_invalid(exception)
        render json: {
          error: {
            code: "validation_failed",
            message: I18n.t("api.errors.validation_failed"),
            details: exception.record.errors.full_messages
          }
        }, status: :unprocessable_entity
      end

      def render_forbidden(_exception)
        render json: { error: { code: "forbidden", message: I18n.t("api.errors.forbidden") } }, status: :forbidden
      end

      def render_parameter_missing(exception)
        render json: {
          error: {
            code: "parameter_missing",
            message: I18n.t("api.errors.parameter_missing", param: exception.param)
          }
        }, status: :bad_request
      end

      def render_validation_errors(record)
        render json: {
          error: {
            code: "validation_failed",
            message: I18n.t("api.errors.validation_failed"),
            details: record.errors.full_messages
          }
        }, status: :unprocessable_entity
      end

      def render_safety_gate_failure(result)
        render json: {
          error: {
            code: "safety_gate_failed",
            message: result.reason
          }
        }, status: :unprocessable_entity
      end
    end
  end
end
