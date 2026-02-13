# frozen_string_literal: true

require "resolv"

module Settings
  class VerifyDns
    Result = Data.define(:success, :status, :message)

    DNS_TIMEOUT = 5

    def initialize(organization:, resolver: nil)
      @organization = organization
      @resolver = resolver
    end

    def call
      domain = @organization.custom_domain
      return Result.new(success: false, status: :no_domain, message: I18n.t("settings.domain.verify.no_domain")) if domain.blank?

      expected_target = "#{@organization.subdomain}.#{platform_domain}"

      resolver = @resolver || Resolv::DNS.new
      resolver.timeouts = DNS_TIMEOUT

      begin
        cname_records = resolver.getresources(domain, Resolv::DNS::Resource::IN::CNAME)

        if cname_records.any?
          actual_target = cname_records.first.name.to_s.chomp(".")
          if actual_target.downcase == expected_target.downcase
            Result.new(success: true, status: :verified, message: I18n.t("settings.domain.verify.verified"))
          else
            Result.new(success: false, status: :cname_mismatch,
              message: I18n.t("settings.domain.verify.cname_mismatch", expected: expected_target, actual: actual_target))
          end
        else
          Result.new(success: false, status: :not_found, message: I18n.t("settings.domain.verify.not_found", target: expected_target))
        end
      rescue Resolv::ResolvError, Resolv::ResolvTimeout => e
        Result.new(success: false, status: :error, message: I18n.t("settings.domain.verify.error", details: e.message))
      ensure
        resolver.close
      end
    end

    private

    def platform_domain
      Rails.application.config.x.platform_domain
    end
  end
end
