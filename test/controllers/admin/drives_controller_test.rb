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
end
