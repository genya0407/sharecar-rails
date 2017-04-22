require 'test_helper'

class DriveTest < ActiveSupport::TestCase
  # last_meter
  test '最後に終了したメーターの値が取得できること' do
    car = create(:car)
    drive = create(:drive, car: car)

    assert_equal Drive.last_meter(car), drive.end_meter
  end
end
