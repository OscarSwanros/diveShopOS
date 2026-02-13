# frozen_string_literal: true

require "test_helper"

class ServiceRecordTest < ActiveSupport::TestCase
  test "valid service record" do
    record = ServiceRecord.new(
      equipment_item: equipment_items(:bcd_medium),
      service_type: :annual_service,
      service_date: Date.current,
      next_due_date: Date.current + 1.year,
      performed_by: "Test Tech"
    )
    assert record.valid?
  end

  test "requires service_type" do
    record = service_records(:bcd_annual)
    record.service_type = nil
    assert_not record.valid?
  end

  test "requires service_date" do
    record = service_records(:bcd_annual)
    record.service_date = nil
    assert_not record.valid?
  end

  test "requires performed_by" do
    record = service_records(:bcd_annual)
    record.performed_by = nil
    assert_not record.valid?
  end

  test "updates equipment item service dates after save" do
    item = equipment_items(:regulator_no_service)
    service_date = Date.current
    next_due = Date.current + 1.year

    item.service_records.create!(
      service_type: :annual_service,
      service_date: service_date,
      next_due_date: next_due,
      performed_by: "Test Tech"
    )

    item.reload
    assert_equal service_date, item.last_service_date
    assert_equal next_due, item.next_service_due
  end
end
