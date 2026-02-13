json.data @checklist_items do |item|
  json.partial! "api/v1/checklist_items/checklist_item", checklist_item: item
end
