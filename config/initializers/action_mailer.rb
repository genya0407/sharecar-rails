ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: Rails.application.credentials.sendgrid_api_key,
  domain: Rails.application.credentials.domain,
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
