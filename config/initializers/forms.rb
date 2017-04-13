require_dependency Rails.root.join("app/forms/application_form.rb")

Dir.glob("app/forms/**/*.rb") do |f|
  require_dependency Rails.root.join(f)
end