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
end