require 'test_helper'

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'activateされていないユーザーでログインできないこと' do
    user = create(:user_not_activated)
    post user_sessions_path, params: { email: user.email, password: '' }
    assert_response :forbidden
  end
end
