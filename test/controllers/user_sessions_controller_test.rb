require 'test_helper'

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'activateされていないユーザーでログインできないこと' do
    password = Faker::Internet.password(10, 20)
    user = create(:user_not_activated, password_trans: password)
    post user_sessions_path, params: { email: user.email, password: password }
    assert_response :forbidden
  end
end
