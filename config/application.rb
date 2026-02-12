require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DiveShopOS
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Use UUIDs as primary keys for all models
    config.generators do |g|
      g.orm :active_record, primary_key_type: :string
    end

    # Tenant resolution middleware (loaded before autoloader)
    require_relative "../lib/tenant_resolver"
    config.middleware.use TenantResolver
  end
end
