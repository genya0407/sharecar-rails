require 'test_helper'
require 'helpers/drive'
require 'controllers/base'

class Admin::DrivesControllerTest < BaseControllerTest
  include DriveHelper

  setup do
    login
    @user.admin!
  end

  test '乗車記録の一覧の中に空白の部分があれば、作成画面へのリンクが現れること' do
    all_drives_count = rand(10..20)
    lacking_drive_count = rand(2...all_drives_count)

    car = create(:car)
    create_continuous_drives(car, n: all_drives_count)

    # メーターの値が一番うしろのdriveをいじってしまうと、「空白の部分」の数が変わってしまうので、
    # 一番最後のdrive以外のdriveを編集するように
    car.drives.order(:start_meter)
      .reverse.drop(1).reverse
      .sample(lacking_drive_count).each do |drive|
        drive.end_meter = rand((drive.start_meter)...(drive.end_meter))
        drive.save!
    end

    get admin_car_drives_path(car.id)
    assert_select '.drive', all_drives_count
    assert_select '.drive-form-create-admin', lacking_drive_count
  end

  test 'create 乗車記録を作成できること' do
    car = create(:car)
    drive_params = build(:drive, car: car).attributes.slice('user_id', 'start_meter', 'end_meter')

    assert_difference 'Drive.count', +1 do
      post admin_car_drives_path(car_id: car.id), params: { drive_form_admin: drive_params }
    end
  end

  test 'update 乗車記録を編集できること' do
    drive = create(:drive)
    new_start_meter = rand((drive.start_meter)...(drive.end_meter))
    new_end_meter = rand((new_start_meter)...(drive.end_meter))
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
    car = create(:car)
    create_continuous_drives(car, n: 10)

    assert_difference 'Drive.count', -1 do
      delete admin_car_drive_path(car_id: car.id, id: car.drives.all.sample.id)
    end
  end
end
