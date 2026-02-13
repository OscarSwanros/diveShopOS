json.data @checklist_templates do |template|
  json.partial! "api/v1/checklist_templates/checklist_template", checklist_template: template
end
json.partial! "api/v1/shared/pagination"
