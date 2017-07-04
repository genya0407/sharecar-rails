require 'controllers/base'
require 'helpers/booking'
require 'helpers/drive'

class DrivesControllerTest < BaseControllerTest
  include BookingHelper

  setup do
    login
    Drive.delete_all
    Booking.delete_all
  end

  test '#new 前の人の終了メーターが表示されること' do
    car = create(:car)
    drive = create(:drive, car: car)
    get new_car_drive_path(car_id: car.id)

    assert_select 'input#drive_form_create_start_meter', { value: drive.end_meter }
  end

  test '#new in_effectな予約が表示されること' do
    car = create(:car)
    create_in_effect(car)

    get new_car_drive_path(car_id: car.id)

    assert_select '.booking', car.bookings.in_effect.count
  end

  test '#new 自分の作成した予約の数だけ削除ボタンが表示されること' do
    car = create(:car)
    effectives = create_in_effect(car)

    my_bookings_count = rand(1..(effectives.count))
    effectives.sample(my_bookings_count).each do |booking|
      booking.user = @user
      booking.save!
    end

    get new_car_drive_path(car_id: car.id)
    assert_select '.booking-delete', my_bookings_count
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
    user = create(:user)
    drive = build(:drive, car: car, user: user)

    with_conflicted_bookings drive do
      assert_difference "Drive.where(car_id: #{car.id}).count", 0 do
        post car_drives_path(car_id: car.id), params: {
          drive_form_create: {
            start_meter: drive.start_meter,
            end_at_date: drive.end_at.to_date,
            end_at_hour: drive.end_at.hour
          }
        }
      end
      assert_select '#errors'
    end
  end

  test '#create 自分の重複するbookingがあるとき作成できる' do
    car = create(:car)
    drive = build(:drive, car: car, user: @user)

    with_conflicted_bookings drive, is_mine: true do
      assert_difference "Drive.where(car_id: #{car.id}).count", 1 do
        post car_drives_path(car_id: car.id), params: {
          drive_form_create: {
            start_meter: drive.start_meter,
            end_at_date: drive.end_at.to_date,
            end_at_hour: drive.end_at.hour
          }
        }
      end
      Drive.delete_all
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
