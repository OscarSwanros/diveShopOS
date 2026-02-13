# frozen_string_literal: true

require "test_helper"
require "resolv"

class FakeCnameRecord
  def initialize(target)
    @target = target
  end

  def name
    @target
  end
end

class FakeDnsResolverForVerifyTest
  def initialize(target: nil, error: nil)
    @target = target
    @error = error
  end

  def timeouts=(_value)
  end

  def getresources(_domain, _type)
    raise @error if @error

    if @target
      [ FakeCnameRecord.new(@target) ]
    else
      []
    end
  end

  def close
  end
end

class Settings::VerifyDnsTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:reef_divers)
    @organization.update!(subdomain: "reef-divers", custom_domain: "www.reefdivers.com")
  end

  test "returns no_domain when custom domain is blank" do
    @organization.update_columns(custom_domain: nil)
    result = Settings::VerifyDns.new(organization: @organization.reload).call
    assert_not result.success
    assert_equal :no_domain, result.status
  end

  test "returns verified when CNAME matches expected target" do
    expected_target = "#{@organization.subdomain}.#{platform_domain}"
    resolver = FakeDnsResolverForVerifyTest.new(target: expected_target)

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert result.success
    assert_equal :verified, result.status
  end

  test "returns verified with trailing dot on CNAME" do
    expected_target = "#{@organization.subdomain}.#{platform_domain}."
    resolver = FakeDnsResolverForVerifyTest.new(target: expected_target)

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert result.success
    assert_equal :verified, result.status
  end

  test "returns verified case-insensitively" do
    expected_target = "#{@organization.subdomain}.#{platform_domain}".upcase
    resolver = FakeDnsResolverForVerifyTest.new(target: expected_target)

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert result.success
    assert_equal :verified, result.status
  end

  test "returns cname_mismatch when CNAME points elsewhere" do
    resolver = FakeDnsResolverForVerifyTest.new(target: "wrong.example.com")

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert_not result.success
    assert_equal :cname_mismatch, result.status
    assert_includes result.message, "wrong.example.com"
  end

  test "returns not_found when no CNAME records exist" do
    resolver = FakeDnsResolverForVerifyTest.new

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert_not result.success
    assert_equal :not_found, result.status
  end

  test "returns error on DNS resolution failure" do
    resolver = FakeDnsResolverForVerifyTest.new(error: Resolv::ResolvError.new("DNS lookup failed"))

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert_not result.success
    assert_equal :error, result.status
    assert_includes result.message, "DNS lookup failed"
  end

  test "returns error on DNS timeout" do
    resolver = FakeDnsResolverForVerifyTest.new(error: Resolv::ResolvTimeout.new("DNS timeout"))

    result = Settings::VerifyDns.new(organization: @organization, resolver: resolver).call
    assert_not result.success
    assert_equal :error, result.status
  end

  private

  def platform_domain
    Rails.application.config.x.platform_domain
  end
end
