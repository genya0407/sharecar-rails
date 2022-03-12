require 'controllers/base'

class HomeControllerTest < BaseControllerTest
  setup do
    login
  end

  test 'require login' do
    logout
    assert_require_login :get, root_path
  end

  test 'carの数だけcardが表示されること' do
    cars = create_list(:car, rand(3))

    get root_path
    assert_select '.card', cars.size
  end

  test '使用不可能なcarの数だけunavailableな要素があること' do
    _cars = create_list(:car, 2)
    unavailable_car_count = rand(1..3)
    create_list(:car, unavailable_car_count, status: :repairing)

    get root_path
    assert_select '.unavailable', unavailable_car_count
  end

  test '自分が使用中のdriveの数だけ乗車終了ボタンが表示されること' do
    create_list(:drive_not_end, rand(1..3), user: @user)
    create_list(:drive, rand(3), user: create(:user))

    get root_path
    assert_select '.Card--Action--FAB--Icon', {
      count: Drive.where(end_meter: nil, user: @user).count,
      text: 'done'
    }
  end

  test '使用中のdriveの数だけ終了時刻と使用者が表示されること' do
    create_list(:drive_not_end, rand(1..3), user: @user)
    create_list(:drive, rand(3), user: create(:user))

    get root_path
    assert_select 'p.current-drive', Drive.where(end_meter: nil).count
  end
end
