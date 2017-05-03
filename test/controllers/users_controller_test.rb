require 'test_helper'

class UsersControllerTest < BaseControllerTest
  setup do
    login
    @user.admin!
  end

  test "ユーザー登録ができること" do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: attributes_for(:user)
      }
    end
  end

  test 'activationできること' do
    logout

    user = create(:user_not_activated)
    assert User.find(user.id).activation_state == 'pending'
    get activate_user_path(id: user.activation_token)
    assert User.find(user.id).activation_state == 'active'
  end
end
