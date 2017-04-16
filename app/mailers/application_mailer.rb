class ApplicationMailer < ActionMailer::Base
  default from: ('noreply@' + Rails.application.secrets.domain)
  layout 'mailer'
end
