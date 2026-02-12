# frozen_string_literal: true

require "test_helper"

class MedicalRecordTest < ActiveSupport::TestCase
  test "valid medical record" do
    record = medical_records(:jane_cleared)
    assert record.valid?
  end

  test "requires status" do
    record = MedicalRecord.new(customer: customers(:jane_diver))
    record.status = nil
    assert_not record.valid?
  end

  test "status enum" do
    assert medical_records(:bob_pending).pending_review?
    assert medical_records(:jane_cleared).cleared?
    assert medical_records(:bob_expired).expired?
  end

  test "kept scope excludes discarded" do
    kept = customers(:jane_diver).medical_records.kept
    assert_includes kept, medical_records(:jane_cleared)
    assert_not_includes kept, medical_records(:discarded_medical)
  end

  test "discarded scope includes only discarded" do
    discarded = customers(:jane_diver).medical_records.discarded
    assert_includes discarded, medical_records(:discarded_medical)
    assert_not_includes discarded, medical_records(:jane_cleared)
  end

  test "current_clearance scope" do
    current = customers(:jane_diver).medical_records.kept.current_clearance
    assert_includes current, medical_records(:jane_cleared)
  end

  test "valid_clearance? returns true for cleared with future expiration" do
    assert medical_records(:jane_cleared).valid_clearance?
  end

  test "valid_clearance? returns false for expired" do
    assert_not medical_records(:bob_expired).valid_clearance?
  end

  test "valid_clearance? returns false for pending_review" do
    assert_not medical_records(:bob_pending).valid_clearance?
  end

  test "discard sets discarded_at" do
    record = medical_records(:jane_cleared)
    assert_nil record.discarded_at
    record.discard
    assert_not_nil record.reload.discarded_at
  end

  test "discarded?" do
    assert medical_records(:discarded_medical).discarded?
    assert_not medical_records(:jane_cleared).discarded?
  end

  test "generates UUID primary key" do
    record = customers(:jane_diver).medical_records.create!(status: :pending_review)
    assert_match(/\A[0-9a-f-]{36}\z/, record.id)
  end
end
