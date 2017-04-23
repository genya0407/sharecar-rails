require 'controllers/base'
require 'helpers/booking'

class BookingControllerTest < BaseControllerTest
  include BookingHelper

  setup do
    login
    @car = create(:car)
  end

  test '#new 完遂されていない予約の一覧が表示されること' do
    create_in_effect(@car)

    get new_car_booking_path(car_id: @car.id)

    assert_select '#bookings > .card > .card-content > .collection > .collection-item',
                  @car.bookings.in_effect.count
  end
end
