ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ApiTestHelper
  def api_token_for(user)
    plain_token = SecureRandom.hex(32)
    digest = Digest::SHA256.hexdigest(plain_token)
    user.api_tokens.create!(token_digest: digest, name: "Test Token #{plain_token.first(8)}")
    plain_token
  end

  def api_headers(token)
    { "Authorization" => "Bearer #{token}", "Accept" => "application/json" }
  end

  def parsed_response
    JSON.parse(response.body)
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  include ApiTestHelper
end
