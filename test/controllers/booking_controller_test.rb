require 'controllers/base'
require 'helpers/booking'
require 'helpers/drive'

class BookingControllerTest < BaseControllerTest
  setup do
    login
  end

  test '#new その車の完遂されていない予約の一覧が表示されること' do
    car = create(:car)
    bookings_in_effect = Array.new(3) { |i| create(:booking, car: car, start_at: (i * 3).days.since, end_at: (i * 3 + 1).days.since) }

    get new_car_booking_path(car_id: car.id)

    assert_select '.booking', bookings_in_effect.size
  end

  test '#new 自分の作成した予約の数だけ削除ボタンが表示されること' do
    car = create(:car)
    my_bookings = Array.new(2) { |i| create(:booking, car: car, user: @user, start_at: (i * 3).days.since, end_at: (i * 3 + 1).days.since) }
    _others_bookings = Array.new(1) { create(:booking, car: car, start_at: 10.days.since, end_at: 11.days.since) }

    get new_car_booking_path(car_id: car.id)
    assert_select '.delete-booking', my_bookings.size
  end

  test '#destroy 自分の予約が削除できること' do
    booking = create(:booking, user: @user)

    assert_difference 'Booking.count', -1 do
      delete car_booking_path(car_id: booking.car.id, id: booking.id)
    end

    assert_response :redirect
  end

  test '#destroy 他人の予約が削除できないこと' do
    booking = create(:booking)

    assert_difference 'Booking.count', 0 do
      delete car_booking_path(car_id: booking.car.id, id: booking.id)
    end

    assert_response :unprocessable_entity
  end

  test '#create 予約が作成できること' do
    car = create(:car)
    start_at = Time.zone.now
    end_at = start_at + rand(2..5).hours

    assert_difference "Booking.where(car_id: #{car.id}).count", 1 do
      post car_bookings_path(car_id: car.id), params: {
        booking_form_create: {
          start_at_date: start_at.to_date,
          start_at_hour: start_at.hour,
          end_at_date: end_at.to_date,
          end_at_hour: end_at.hour
        }
      }
    end
  end

  test '#create 重複する予約がある時、予約は作成されず、エラーを表示すること' do
    car = create(:car)
    booking = build(:booking, car: car)
    # validation自体のテストはモデルのテストでやってるので、１つの重複パターンだけを試す
    _conflicted_booking = create(:booking, car: car, start_at: 1.day.ago(booking.start_at), end_at: 1.day.since(booking.end_at))

    assert_difference "Booking.where(car_id: #{car.id}).count", 0 do
      post car_bookings_path(car_id: booking.car.id), params: {
        booking_form_create: {
          start_at_date: booking.start_at.to_date,
          start_at_hour: booking.start_at.hour,
          end_at_date: booking.end_at.to_date,
          end_at_hour: booking.end_at.hour
        }
      }
    end
    assert_select '#errors'
  end

  test '#create 重複するdriveがある時、予約は作成されず、エラーを表示すること' do
    car = create(:car)
    booking = build(:booking, car: car)
    # validation自体のテストはモデルのテストでやってるので、１つの重複パターンだけを試す
    # end_meterがnon-nilだと重複判定されない
    _conflicted_drive = create(:drive, car: car, end_meter: nil, start_at: 1.day.ago(booking.start_at), end_at: 1.day.since(booking.end_at))

    assert_difference "Booking.where(car_id: #{car.id}).count", 0 do
      post car_bookings_path(car_id: car.id), params: {
        booking_form_create: {
          start_at_date: booking.start_at.to_date,
          start_at_hour: booking.start_at.hour,
          end_at_date: booking.end_at.to_date,
          end_at_hour: booking.end_at.hour
        }
      }
    end
    assert_select '#errors'
  end
end
