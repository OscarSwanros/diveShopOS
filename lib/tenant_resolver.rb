# frozen_string_literal: true

class TenantResolver
  PLATFORM_PATHS = %w[/start /up /caddy/ask].freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    # Platform-level paths bypass tenant resolution entirely
    if platform_path?(request.path)
      @app.call(env)
    else
      host = request.host
      organization = resolve_organization(host)

      if organization
        Current.organization = organization
        @app.call(env)
      else
        # In development, allow requests without tenant resolution
        # In production, return 404 for unresolved domains
        if Rails.env.development? || Rails.env.test?
          @app.call(env)
        else
          [ 404, { "content-type" => "text/html" }, [ "Organization not found" ] ]
        end
      end
    end
  end

  private

  def resolve_organization(host)
    # Try custom domain first
    org = Organization.find_by(custom_domain: host)
    return org if org

    # Try subdomain match (e.g., shop.diveshopos.com)
    subdomain = extract_subdomain(host)
    org = Organization.find_by(subdomain: subdomain) if subdomain.present?
    return org if org

    # In development, match by subdomain = "localhost" for bare localhost access
    Organization.find_by(subdomain: host) if Rails.env.development?
  end

  def extract_subdomain(host)
    parts = host.split(".")
    return nil if parts.length <= 2

    parts.first
  end

  def platform_path?(path)
    PLATFORM_PATHS.any? { |p| path.start_with?(p) }
  end
end
