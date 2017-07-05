require 'test_helper'

class DriveTest < ActiveSupport::TestCase
  include BookingHelper
  include DriveHelper

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

  test '.lack_exist? meterに欠けがあることを検出すること' do
    car = create(:car)
    create_continuous_drives(car, n: 10)

    assert_not car.drives.reload.lack_exist?

    target_drive = car.drives.order(:start_meter).drop(1).sample
    target_drive.start_meter = rand((target_drive.start_meter+1)..(target_drive.end_meter))
    target_drive.save!

    assert car.drives.reload.lack_exist?
  end
end
