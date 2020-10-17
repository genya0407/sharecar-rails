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
    password = Faker::Internet.password(min_length: 10, max_length: 20)
    put confirm_user_path(id: token), params: {
      user: {
        password: password,
        password_confirmation: password,
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.phone_number
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

  test '招待メールをもう一度送信すること' do
    login
    @user.admin!
    target_user = create(:user_not_activated)

    assert_difference '$sent_cnt', +1 do
      post resend_invitation_user_path(target_user)
    end
  end

  test '退会させること' do
    login
    @user.admin!

    target_user = create(:user)
    assert target_user.activation_state == 'active'

    post deactivate_user_path(id: target_user.id)
    assert target_user.reload.activation_state == 'pending'
  end

  test '復帰させること' do
    login
    @user.admin!

    # 退会させる
    target = create(:user)
    assert target.activation_state == 'active'
    post deactivate_user_path(id: target.id)
    assert target.reload.activation_state == 'pending'

    # 復帰させる
    post resend_invitation_user_path(target)
    assert !target.reload.activation_token.nil?
    token = target.activation_token
    get activate_user_path(id: token)
    assert_response :success

    # confirm
    password = Faker::Internet.password(min_length: 10, max_length: 20)
    put confirm_user_path(id: token), params: {
      user: {
        password: password,
        password_confirmation: password,
        name: target.name,
        phone_number: target.phone_number
      }
    }
    assert target.reload.activation_state == 'active'
    logout # confirmしたとき勝手にログインするようになっているため

    # login
    post user_sessions_path, params: { email: target.reload.email, password: password }
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
        password: Faker::Internet.password,
        password_confirmation: Faker::Internet.password,
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.phone_number
      }
    }
    assert_response :unprocessable_entity
    assert User.find_by(email: email).activation_state == 'pending'    
  end

  def invite_user(invite_email)
    @user.admin!
    post users_path, params: {
      user: { email: invite_email }
    }
  end
end
