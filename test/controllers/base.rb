require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  include Sorcery::TestHelpers::Rails::Integration
  include Sorcery::TestHelpers::Rails::Controller

  def assert_require_login(method, path)
    send(method, path)

    assert_redirected_to login_path
  end

  def login(user: nil)
    user = create(:user) if user.nil?
    @user = user
    post user_sessions_path, params: { email: user.email, password: 'password' }
  end

  def logout
    post logout_path
  end
end