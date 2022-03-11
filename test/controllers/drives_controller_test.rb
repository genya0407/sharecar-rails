require 'controllers/base'

class DrivesControllerTest < BaseControllerTest
  setup do
    login
  end

  test '#index 直近10件のdriveが表示されること' do
    car = create(:car)
    user = create(:user)
    _drives = create_list(:drive, 11, user: user, car: car)

    get car_drives_path(car_id: car.id)
    assert_select '.drive', 10
  end

  test '#new 前の人の終了メーターが表示されること' do
    car = create(:car)
    drive = create(:drive, car: car)

    get new_car_drive_path(car_id: car.id)
    assert_select 'input#drive_form_create_start_meter', { value: drive.end_meter }
  end

  test '#new in_effectな予約が表示されること' do
    car = create(:car)
    effective_bookings = [
      create(:booking, car: car, start_at: 1.day.since, end_at: 2.day.since),
      create(:booking, car: car, start_at: 3.day.since, end_at: 4.day.since),
    ]
    _ineffective_booking = create(:booking, car: car, start_at: 2.days.ago, end_at: 1.day.ago)

    get new_car_drive_path(car_id: car.id)
    assert_select '.booking', effective_bookings.size
  end

  test '#new 自分の作成した予約の数だけ削除ボタンが表示されること' do
    car = create(:car)
    my_effective_bookings = [
      create(:booking, car: car, user: @user, start_at: 1.day.since, end_at: 2.day.since),
      create(:booking, car: car, user: @user, start_at: 3.day.since, end_at: 4.day.since),
    ]
    _others_effective_booking = create(:booking, car: car, start_at: 10.day.since, end_at: 10.day.since)

    get new_car_drive_path(car_id: car.id)
    assert_select 'a.booking-delete', my_effective_bookings.size
  end

  test '#create driveが作成できること' do
    car = create(:car)
    drive = create(:drive, car: car)
    end_at = Time.zone.now + rand(2..5).hour

    assert_difference "Drive.where(car_id: #{car.id}).count", 1 do
      post car_drives_path(car_id: car.id), params: {
        drive_form_create: {
          start_meter: drive.end_meter,
          end_at_date: end_at.to_date,
          end_at_hour: end_at.hour
        }
      }
    end
  end

  test '#create 他人の重複するbookingがあるとき作成できず、エラーが表示される' do
    car = create(:car)
    _conflicted_booking = create(:booking, car: car, start_at: 1.day.ago, end_at: 10.days.since)

    assert_difference "Drive.where(car_id: #{car.id}).count", 0 do
      post car_drives_path(car_id: car.id), params: {
        drive_form_create: {
          start_meter: 100,
          end_at_date: Date.tomorrow,
          end_at_hour: 23,
        }
      }
    end
    assert_select '#errors'
  end

  test '#create 自分の重複するbookingがあるとき作成できる' do
    car = create(:car)
    _my_conflicted_booking = create(:drive, car: car, start_at: 1.day.ago, end_at: 10.days.since)

    assert_difference "Drive.where(car_id: #{car.id}).count", 1 do
      post car_drives_path(car_id: car.id), params: {
        drive_form_create: {
          start_meter: 100,
          end_at_date: Date.tomorrow,
          end_at_hour: 22,
        }
      }
    end
  end

  test '#edit driveが終了できること' do
    car = create(:car)
    drive = create(:drive_not_end, car: car, user: @user)
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
