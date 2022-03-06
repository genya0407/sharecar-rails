require 'test_helper'

class BookingTest < ActiveSupport::TestCase
  test 'car.bookings.in_effect 完遂されていないかもしれない予約を取得する' do
    car = create(:car)
    bookings_in_effect = Array.new(2) { |i| create(:booking, car: car, start_at: (i * 2).days.since, end_at: ((i * 2) + 1).days.since) }
    _bookings_not_in_effect = create(:booking, car: car, start_at: 2.days.ago, end_at: 1.day.ago)

    assert_equal car.bookings.in_effect.count, bookings_in_effect.size
  end
end
