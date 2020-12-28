require 'test_helper'

class BookingConflictingBookingTest < ActiveSupport::TestCase
  # new_booking:      [......]
  # existing_booking:      [...............]
  test '自身のstart_atとend_atの間にstart_atが入るようなbookingがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    middle_of_booking_range = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) / 2)
    _exsiting_booking = create(:booking, car: car, start_at: middle_of_booking_range, end_at: 1.day.since(booking.end_at))

    assert_not booking.valid?
  end

  # new_booking:                   [......]
  # existing_booking: [...............]
  test '自身のstart_atとend_atの間にend_atが入るようなbookingがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    middle_of_booking_range = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) / 2)
    _exsiting_booking = create(:booking, car: car, start_at: 1.day.ago(booking.start_at), end_at: middle_of_booking_range)

    assert_not booking.valid?
  end

  # new_booking:          [......]
  # existing_booking: [...............]
  test '自身のstart_atとend_atの範囲をカバーするような範囲のbookingがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    _exsiting_booking = create(:booking, car: car, start_at: 1.day.ago(booking.start_at), end_at: 1.day.since(booking.end_at))

    assert_not booking.valid?
  end

  # new_booking:      [........................]
  # existing_booking:      [..........]
  test '自身のstart_atとend_atの範囲に収まるような範囲のbookingがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    one_third_of_booking = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) * (1.0 / 3))
    two_third_of_booking = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) * (2.0 / 3))
    _exsiting_booking = create(:booking, car: car, start_at: one_third_of_booking, end_at: two_third_of_booking)

    assert_not booking.valid?
  end
end
