json.extract! checklist_template, :id, :slug, :title, :description, :category, :active
json.items_count checklist_template.checklist_items.size
json.created_at checklist_template.created_at.iso8601
json.updated_at checklist_template.updated_at.iso8601
