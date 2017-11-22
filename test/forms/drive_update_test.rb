require 'test_helper'
require 'helpers/booking'
require 'helpers/drive'

class DriveFormUpdateTest < ActiveSupport::TestCase
  test '降車時のメーターが乗車時のメーター以上の値であること' do
    drive = create(:drive_not_end)

    assert DriveForm::Update.new(drive, end_meter: drive.start_meter).valid?
    assert DriveForm::Update.new(drive, end_meter: drive.start_meter + rand(1..100)).valid?
    assert_not DriveForm::Update.new(drive, end_meter: drive.start_meter - rand(1..100)).valid?
  end

  test '車が使用可能でないとき、end_meterを設定できない' do
    car = create(:car, available: false)
    drive = create(:drive_not_end, car: car)

    assert_not DriveForm::Update.new(drive, end_meter: drive.start_meter + rand(1..100)).valid?
  end
end