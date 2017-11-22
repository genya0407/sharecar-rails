require 'controllers/base'

class HomeControllerTest < BaseControllerTest
  setup do
    login
    rand(2..5).times { create(:drive_not_end, user: @user) } # Carも生成される
    rand(2..5).times { create(:drive, user: @user) } # Carも生成される
    rand(2..5).times { create(:drive_not_end) } # Carも生成される
    rand(2..5).times { create(:drive) } # Carも生成される
    get root_path
  end

  test 'require login' do
    logout
    assert_require_login :get, root_path
  end

  test 'carの数だけcardが表示されること' do
    assert_select '.Card', Car.count
  end

  test '使用不可能なcarの数だけunavailableな要素があること' do
    unavailable_car_count = rand(1..3)
    create_list(:car, unavailable_car_count, available: false)

    get root_path
    assert_select '.unavailable', unavailable_car_count
  end

  test '自分が使用中のdriveの数だけ乗車終了ボタンが表示されること' do
    assert_select '.Card--Action--FAB--Icon', { 
      count: Drive.where(end_meter: nil, user: @user).count,
      text: 'done'
    }
  end

  test '使用中のdriveの数だけ終了時刻と使用者が表示されること' do
    assert_select 'p.current-drive', Drive.where(end_meter: nil).count
  end
end
