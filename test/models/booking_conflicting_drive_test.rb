require 'test_helper'

class BookingConflictingDriveTest < ActiveSupport::TestCase
  # new_booking:      [......]
  # existing_drive:        [...............]
  test '自身のstart_atとend_atの間にstart_atが入るような未完了のdriveがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    middle_of_booking_range = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) / 2)
    _exsiting_drive = create(:drive, car: car, end_meter: nil, start_at: middle_of_booking_range, end_at: 1.day.since(booking.end_at))

    assert_not booking.valid?
  end

  # new_booking:                   [......]
  # existing_drive:   [...............]
  test '自身のstart_atとend_atの間にend_atが入るような未完了のdriveがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    middle_of_booking_range = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) / 2)
    _exsiting_drive = create(:drive, car: car, end_meter: nil, start_at: 1.day.ago(booking.start_at), end_at: middle_of_booking_range)

    assert_not booking.valid?
  end

  # new_booking:          [......]
  # existing_drive:   [...............]
  test '自身のstart_atとend_atの範囲をカバーするような範囲の未完了のdriveがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    _exsiting_drive = create(:drive, car: car, end_meter: nil, start_at: 1.day.ago(booking.start_at), end_at: 1.day.since(booking.end_at))

    assert_not booking.valid?
  end

  # new_booking:      [........................]
  # existing_drive:        [..........]
  test '自身のstart_atとend_atの範囲に収まるような範囲の未完了のdriveがあるとき、invalidになる' do
    car = create(:car)
    booking = build(:booking, car: car)
    one_third_of_booking = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) * (1.0 / 3))
    two_third_of_booking = Time.zone.at((booking.start_at.to_i + booking.end_at.to_i) * (2.0 / 3))
    _exsiting_drive = create(:drive, car: car, end_meter: nil, start_at: one_third_of_booking, end_at: two_third_of_booking)

    assert_not booking.valid?
  end
end