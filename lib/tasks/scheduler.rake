desc "This task is called by the Heroku scheduler add-on"
task wake_up: :environment do
  require 'net/http'
  require 'uri'

  url = URI.parse("https://#{Rails.application.secrets.site_domain}")
  Net::HTTP.start(url.host, url.port) { |http| http.get('/') }
end