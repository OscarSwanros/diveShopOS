# frozen_string_literal: true

require "test_helper"

class CertificationTest < ActiveSupport::TestCase
  test "valid certification" do
    cert = certifications(:jane_ow)
    assert cert.valid?
  end

  test "requires agency" do
    cert = Certification.new(
      customer: customers(:jane_diver),
      certification_level: "Open Water"
    )
    assert_not cert.valid?
    assert_includes cert.errors[:agency], "can't be blank"
  end

  test "requires certification_level" do
    cert = Certification.new(
      customer: customers(:jane_diver),
      agency: "PADI"
    )
    assert_not cert.valid?
    assert_includes cert.errors[:certification_level], "can't be blank"
  end

  test "kept scope excludes discarded" do
    kept = customers(:jane_diver).certifications.kept
    assert_includes kept, certifications(:jane_ow)
    assert_not_includes kept, certifications(:discarded_cert)
  end

  test "discarded scope includes only discarded" do
    discarded = customers(:jane_diver).certifications.discarded
    assert_includes discarded, certifications(:discarded_cert)
    assert_not_includes discarded, certifications(:jane_ow)
  end

  test "active scope excludes expired" do
    active = customers(:bob_bubbles).certifications.active
    assert_includes active, certifications(:bob_ow)
    assert_not_includes active, certifications(:expired_cert)
  end

  test "expired scope" do
    expired = customers(:bob_bubbles).certifications.expired
    assert_includes expired, certifications(:expired_cert)
    assert_not_includes expired, certifications(:bob_ow)
  end

  test "discard sets discarded_at" do
    cert = certifications(:jane_ow)
    assert_nil cert.discarded_at
    cert.discard
    assert_not_nil cert.reload.discarded_at
  end

  test "discarded?" do
    assert certifications(:discarded_cert).discarded?
    assert_not certifications(:jane_ow).discarded?
  end

  test "expired?" do
    assert certifications(:expired_cert).expired?
    assert_not certifications(:jane_ow).expired?
  end

  test "active?" do
    assert certifications(:jane_ow).active?
    assert_not certifications(:expired_cert).active?
    assert_not certifications(:discarded_cert).active?
  end

  test "generates UUID primary key" do
    cert = customers(:jane_diver).certifications.create!(
      agency: "NAUI",
      certification_level: "Scuba Diver"
    )
    assert_match(/\A[0-9a-f-]{36}\z/, cert.id)
  end
end
