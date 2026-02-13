json.data @checklist_runs do |run|
  json.partial! "api/v1/checklist_runs/checklist_run", checklist_run: run
end
json.partial! "api/v1/shared/pagination"
