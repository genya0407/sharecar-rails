require 'controllers/base'
require 'helpers/booking'

class BookingControllerTest < BaseControllerTest
  include BookingHelper

  setup do
    login
    Booking.delete_all
    @car = create(:car)
  end

  test '#new 完遂されていない予約の一覧が表示されること' do
    create_in_effect(@car)

    get new_car_booking_path(car_id: @car.id)

    assert_select '#bookings > .card > .card-content > .collection > .collection-item',
                  @car.bookings.in_effect.count
  end

  test '#create 予約が作成できること' do
    start_at = Time.zone.now
    end_at = start_at + rand(2..5).hours

    assert_difference "Booking.where(car_id: #{@car.id}).count", 1 do
      post car_bookings_path(car_id: @car.id), params: {
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
    booking = build(:booking)
    create_booking_end_in_range(booking)

    assert_difference "Booking.where(car_id: #{@car.id}).count", 0 do
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
end
