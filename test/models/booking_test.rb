require 'test_helper'
require 'helpers/booking'
require 'helpers/drive'

class BookingTest < ActiveSupport::TestCase
  include BookingHelper
  include DriveHelper

  test 'car.bookings.in_effect 完遂されていないかもしれない予約を取得する' do
    car = create(:car)
    bookings_in_effect = Array.new(2) { |i| create(:booking, car: car, start_at: (i * 2).days.since, end_at: (i * 2 + 1).days.since) }
    _bookings_not_in_effect = create(:booking, car: car, start_at: 2.days.ago, end_at: 1.day.ago)

    assert_equal car.bookings.in_effect.count, bookings_in_effect.size
  end

  test 'Booking#conflicted_bookings 重複する予約を取得する' do
    booking = build(:booking)
    assert booking.conflicted_bookings.empty?

    # 期間が重複する４パターンを試す
    with_conflicted_bookings booking do
      assert booking.conflicted_bookings.exists?
    end
  end

  test '重複する予約がある時作成できない' do
    booking = build(:booking)

    with_conflicted_bookings booking do
      assert_not booking.valid?
      assert booking.errors.present?
    end
  end

  test '重複するdriveがある時作成できない' do
    booking = build(:booking)

    with_conflicted_drives booking do
      assert_not booking.valid?
      assert booking.errors.present?
    end
  end
end
