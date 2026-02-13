json.data @checklist_responses do |response|
  json.partial! "api/v1/checklist_responses/checklist_response", checklist_response: response
end
