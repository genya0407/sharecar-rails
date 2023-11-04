class ApplicationMailer < ActionMailer::Base
  default from: "noreply@#{Rails.application.credentials.domain}"
  layout 'mailer'
end
