require 'controllers/base'

class DrivesControllerTest < BaseControllerTest
  setup do
    login
    @car = create(:car)
    @drive = create(:drive, car: @car)    
  end

  test '#new 前の人の終了メーターが表示されること' do
    get new_car_drive_path(car_id: @car.id)

    assert_select 'input#drive_form_create_start_meter', { value: @drive.end_meter }
  end

  test '#create driveが作成できること' do
    assert_difference "Drive.where(car_id: #{@car.id}).count", 1 do
      post car_drives_path(car_id: @car.id), params: {
        drive_form_create: {
          start_meter: @drive.end_meter,
          using_hours: rand(2..10) 
        }
      }
    end
  end

  test '#edit driveが終了できること' do
    drive = create(:drive_not_end, car: @car, user: @user)
    end_meter = drive.start_meter + rand(5..100)

    assert Drive.find(drive.id).end_meter.nil?

    put car_drive_path(car_id: drive.car_id, id: drive.id), params: {
      drive_form_update: {
        end_meter: end_meter
      }
    }

    assert_equal Drive.find(drive.id).end_meter, end_meter
  end
end
