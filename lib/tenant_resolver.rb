# frozen_string_literal: true

class TenantResolver
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
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

  private

  def resolve_organization(host)
    Rails.cache.fetch("tenant:#{host}", expires_in: 5.minutes) do
      # Try custom domain first
      org = Organization.find_by(custom_domain: host)
      return org if org

      # Try subdomain
      subdomain = extract_subdomain(host)
      Organization.find_by(subdomain: subdomain) if subdomain.present?
    end
  end

  def extract_subdomain(host)
    parts = host.split(".")
    return nil if parts.length <= 2

    parts.first
  end
end
