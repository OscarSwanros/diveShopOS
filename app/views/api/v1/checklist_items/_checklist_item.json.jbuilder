json.extract! checklist_item, :id, :slug, :title, :description, :position, :required, :auto_check_key
json.checklist_template_id checklist_item.checklist_template_id
json.created_at checklist_item.created_at.iso8601
json.updated_at checklist_item.updated_at.iso8601
