json.extract! customer_tank, :id, :slug, :serial_number, :manufacturer, :material, :size,
  :last_vip_date, :vip_due_date, :last_hydro_date, :hydro_due_date, :notes
json.customer_id customer_tank.customer_id
json.organization_id customer_tank.organization_id
json.vip_current customer_tank.vip_current?
json.hydro_current customer_tank.hydro_current?
json.fill_compliant customer_tank.fill_compliant?
json.created_at customer_tank.created_at.iso8601
json.updated_at customer_tank.updated_at.iso8601
