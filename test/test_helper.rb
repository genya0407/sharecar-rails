ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'
require 'faker'
require 'email_spec'

FactoryGirl.find_definitions
User.sorcery_config.activation_mailer_disabled = true

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end