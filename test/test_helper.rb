ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_bot'
require 'faker'
require 'email_spec'
require 'minitest/mock'
require 'minitest/test_profile'
require 'rblineprof'
require 'rblineprof-report'

FactoryBot.find_definitions
User.sorcery_config.activation_mailer_disabled = true

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

Minitest::TestProfile.use!(count: 3)

DatabaseCleaner.strategy = :transaction

# テストを早くするためにメールの送信をスキップする
class User
  def send_activation_needed_email!
    $sent_cnt = $sent_cnt.to_i + 1
  end
end