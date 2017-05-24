require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  def assert_require_login(method, path)
    send(method, path)

    assert_redirected_to login_path
  end

  def login
    password = Faker::Internet.password
    user = create(:user, password_trans: password)
    post user_sessions_path, params: { email: user.email, password: password }

    @user = user
  end

  def logout
    post logout_path
    @user = nil
  end
end