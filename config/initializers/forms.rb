Dir.glob("app/forms/*.rb") do |f|
  require_dependency Rails.root.join(f)
end