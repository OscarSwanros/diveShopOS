# frozen_string_literal: true

require "test_helper"

class ApiTokenTest < ActiveSupport::TestCase
  setup do
    @user = users(:owner_maria)
  end

  test "generate_token_pair creates token and returns plain token" do
    token, plain = ApiToken.generate_token_pair(user: @user, name: "Test Token")

    assert token.persisted?
    assert_equal @user, token.user
    assert_equal "Test Token", token.name
    assert plain.present?
    assert_equal Digest::SHA256.hexdigest(plain), token.token_digest
  end

  test "find_by_plain_token finds active token" do
    found = ApiToken.find_by_plain_token("test-token-maria-0001")
    assert_equal api_tokens(:maria_token), found
  end

  test "find_by_plain_token returns nil for expired token" do
    assert_nil ApiToken.find_by_plain_token("test-token-expired-0002")
  end

  test "find_by_plain_token returns nil for revoked token" do
    assert_nil ApiToken.find_by_plain_token("test-token-revoked-0003")
  end

  test "find_by_plain_token returns nil for blank token" do
    assert_nil ApiToken.find_by_plain_token("")
    assert_nil ApiToken.find_by_plain_token(nil)
  end

  test "find_by_plain_token returns nil for unknown token" do
    assert_nil ApiToken.find_by_plain_token("nonexistent-token")
  end

  test "revoke! sets revoked_at" do
    token = api_tokens(:maria_token)
    assert token.active?

    token.revoke!
    assert token.revoked?
    refute token.active?
  end

  test "expired? returns true when expires_at is in the past" do
    assert api_tokens(:expired_token).expired?
  end

  test "expired? returns false when expires_at is nil" do
    refute api_tokens(:maria_token).expired?
  end

  test "active? returns false when revoked" do
    refute api_tokens(:revoked_token).active?
  end

  test "touch_last_used! updates last_used_at" do
    token = api_tokens(:maria_token)
    assert_nil token.last_used_at

    token.touch_last_used!
    assert token.last_used_at.present?
  end

  test "validates presence of token_digest" do
    token = ApiToken.new(user: @user, name: "Test")
    refute token.valid?
    assert token.errors[:token_digest].any?
  end

  test "validates presence of name" do
    token = ApiToken.new(user: @user, token_digest: "abc")
    refute token.valid?
    assert token.errors[:name].any?
  end

  test "validates uniqueness of token_digest" do
    existing = api_tokens(:maria_token)
    token = ApiToken.new(user: @user, name: "Dup", token_digest: existing.token_digest)
    refute token.valid?
    assert token.errors[:token_digest].any?
  end

  test "belongs to user" do
    token = api_tokens(:maria_token)
    assert_equal users(:owner_maria), token.user
  end

  test "user has_many api_tokens" do
    assert_includes @user.api_tokens, api_tokens(:maria_token)
  end

  test "destroying user destroys tokens" do
    user = users(:staff_ana)
    token, _ = ApiToken.generate_token_pair(user: user, name: "Ana Token")

    assert_difference "ApiToken.count", -1 do
      user.destroy!
    end
  end
end
