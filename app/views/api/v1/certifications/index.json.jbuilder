json.data @certifications do |certification|
  json.partial! "api/v1/certifications/certification", certification: certification
end
json.partial! "api/v1/shared/pagination"
