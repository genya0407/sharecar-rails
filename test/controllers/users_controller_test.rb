require 'test_helper'

class UsersControllerTest < BaseControllerTest
  test "ユーザー登録の一連の処理が正常に動作すること" do
    # invite
    login
    email = Faker::Internet.email
    assert_difference 'User.count', 1 do
      invite_user(email)
    end
    logout
    assert User.find_by(email: email).activation_state == 'pending'

    # activate
    token = User.find_by(email: email).activation_token
    get activate_user_path(id: token)
    assert_response :success

    # confirm
    password = Faker::Internet.password(10, 20)
    put confirm_user_path(id: token), params: {
      user: {
        password: password,
        password_confirmation: password,
        name: Faker::Name.name
      }
    }
    assert User.find_by(email: email).activation_state == 'active'
    logout # confirmしたとき勝手にログインするようになっているため

    # login
    post user_sessions_path, params: { email: email, password: password }
    assert_response :redirect
  end

  test '存在しないtokenでactivateしようとした時、弾くように' do
    login
    invite_user(Faker::Internet.email)
    logout

    get activate_user_path(id: Faker::Crypto.md5)
    assert_response :redirect
  end

  test 'password_confirmationが間違っていた場合に弾くように' do
    login
    email = Faker::Internet.email
    invite_user(email)
    logout

    token = User.find_by(email: email).activation_token
    put confirm_user_path(id: token), params: {
      user: {
        password: Faker::Internet.email,
        password_confirmation: Faker::Internet.email,
        name: Faker::Name.name
      }
    }
    assert_response :unprocessable_entity
    assert User.find_by(email: email).activation_state == 'pending'    
  end

  def invite_user(invite_email)
    @user.permission = :admin
    @user.save!(validate: false)
    post users_path, params: {
      user: { email: invite_email }
    }
  end
end
