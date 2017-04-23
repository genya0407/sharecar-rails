require 'test_helper'
require 'helpers/booking'

class BookingTest < ActiveSupport::TestCase
  include BookingHelper

  test 'car.bookings.in_effect 完遂されていないかもしれない予約を取得する' do
    car = create(:car)

    bookings_count_in_effect = create_in_effect(car)

    assert_equal car.bookings.in_effect.count, bookings_count_in_effect
  end
end
