require 'test_helper'
require 'controllers/base'

class Admin::DrivesControllerTest < BaseControllerTest
  setup do
    login
    @user.admin!
  end

  test '乗車記録の一覧の中に空白の部分があれば、作成画面へのリンクが現れること' do
    car = create(:car)
    # drive1とdrive2の間に空白がある
    _drive1 = create(:drive, car: car, start_meter: 100, end_meter: 200)
    _drive2 = create(:drive, car: car, start_meter: 300, end_meter: 400)
    _drive3 = create(:drive, car: car, start_meter: 400, end_meter: 500)

    get admin_car_drives_path(car.id)
    assert_select '.drive', 3
    assert_select '.drive-form-create-admin', 1
  end

  test 'create 乗車記録を作成できること' do
    car = create(:car)
    drive_params = build(:drive, car: car).attributes.slice('user_id', 'start_meter', 'end_meter')

    assert_difference 'Drive.count', +1 do
      post admin_car_drives_path(car_id: car.id), params: { drive_form_admin: drive_params }
    end
  end

  test 'update 乗車記録を編集できること' do
    drive = create(:drive, start_meter: 100, end_meter: 200)
    new_start_meter = 1000
    new_end_meter = 2000
    new_user_id = create(:user).id

    put admin_car_drive_path(car_id: drive.car.id, id: drive.id),
        params: {
          drive_form_admin: {
            start_meter: new_start_meter,
            end_meter: new_end_meter,
            user_id: new_user_id
          }
        }

    drive.reload
    assert_equal new_start_meter, drive.start_meter
    assert_equal new_end_meter, drive.end_meter
    assert_equal new_user_id, drive.user_id
  end

  test 'destroy 乗車記録を削除できること' do
    drive = create(:drive)

    assert_difference 'Drive.count', -1 do
      delete admin_car_drive_path(car_id: drive.car.id, id: drive.id)
    end
  end
end
