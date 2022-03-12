require 'test_helper'

class DriveFormCreateTest < ActiveSupport::TestCase
  test '期間が重複する他人の予約がある時、作成できない' do
    drive = build(:drive)
    form = DriveForm::Create.from_drive(drive)
    _conflicting_booking = create(:booking, car: drive.car, start_at: 1.day.ago(drive.start_at), end_at: 1.day.since(drive.end_at))

    assert_not form.valid?
  end

  test '期間が重複する自分の予約がある時、作成できる' do
    drive = build(:drive)
    form = DriveForm::Create.from_drive(drive)
    _conflicting_my_booking = create(:booking, car: drive.car, user: drive.user, start_at: 1.day.ago(drive.start_at), end_at: 1.day.since(drive.end_at))

    assert form.valid?
  end

  test '車が使用可能でないとき、作成できない' do
    car = create(:car, status: :repairing)
    drive = build(:drive, car:)
    form = DriveForm::Create.from_drive(drive)

    assert_not form.valid?
  end
end
