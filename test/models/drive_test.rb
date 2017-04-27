require 'test_helper'

class DriveTest < ActiveSupport::TestCase
  include BookingHelper

  test '.last_meter 最後に終了したメーターの値が取得できること' do
    car = create(:car)
    drive = create(:drive, car: car)

    assert_equal Drive.last_meter(car), drive.end_meter
  end

  test 'last_meterよりも小さい値をstart_meterに指定して作成できること' do
    last_drive = create(:drive)
    drive = build(:drive_from_start_at,
                  start_at: last_drive.end_at + rand(2..5).hours,
                  start_meter: rand(0..(last_drive.end_meter)),
                  end_meter: nil,
                  car: last_drive.car)
    assert drive.valid?
  end

  test '期間が重複する予約がある時、作成できない' do
    drive = build(:drive)

    with_conflicted_bookings drive do
      assert_not drive.valid?
    end
  end
end
