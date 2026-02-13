json.extract! checklist_run, :id, :slug, :status, :notes
json.checklist_template_id checklist_run.checklist_template_id
json.started_by_id checklist_run.started_by_id
json.started_by_name checklist_run.started_by.name
json.checkable_type checklist_run.checkable_type
json.checkable_id checklist_run.checkable_id

progress = checklist_run.progress
json.progress do
  json.checked progress[:checked]
  json.total progress[:total]
  json.percentage progress[:percentage]
end

json.completed_at checklist_run.completed_at&.iso8601
json.created_at checklist_run.created_at.iso8601
json.updated_at checklist_run.updated_at.iso8601
