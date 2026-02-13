json.extract! checklist_response, :id, :checked, :auto_verified, :notes
json.checklist_run_id checklist_response.checklist_run_id
json.checklist_item_id checklist_response.checklist_item_id
json.completed_by_id checklist_response.completed_by_id
json.completed_by_name checklist_response.completed_by&.name
json.checked_at checklist_response.checked_at&.iso8601
json.created_at checklist_response.created_at.iso8601
json.updated_at checklist_response.updated_at.iso8601
