require 'test_helper'
require 'helpers/booking'

class BookingTest < ActiveSupport::TestCase
  include BookingHelper

  setup do
    Booking.delete_all
  end

  test 'car.bookings.in_effect 完遂されていないかもしれない予約を取得する' do
    car = create(:car)

    bookings_count_in_effect = create_in_effect(car)

    assert_equal car.bookings.in_effect.count, bookings_count_in_effect
  end

  test 'Booking#conflicted_bookings 重複する予約を取得する' do
    booking = build(:booking)
    assert booking.conflicted_bookings.empty?

    # 期間が重複する４パターンを試す
    with_conflicted_bookings booking do |conflict|
      assert booking.conflicted_bookings.exists?
    end
  end
end
