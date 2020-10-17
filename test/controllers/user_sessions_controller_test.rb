require 'test_helper'

class UserSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'activateされていないユーザーでログインできないこと' do
    user = create(:user_not_activated)
    post user_sessions_path, params: { email: user.email, password: '' }
    assert_response :forbidden
  end

  test '退会させられたユーザーがログインできなくなること' do
    password = Faker::Internet.password(min_length: 10, max_length: 20)
    user = create(:user, password_trans: password)

    post user_sessions_path, params: { email: user.email, password: password }
    assert_response :found

    user.activation_state = :pending
    user.save!

    post user_sessions_path, params: { email: user.email, password: password }
    assert_response :forbidden
  end
end
