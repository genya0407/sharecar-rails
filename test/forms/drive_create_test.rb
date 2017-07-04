require 'test_helper'
require 'helpers/booking'
require 'helpers/drive'

class DriveFormCreateTest < ActiveSupport::TestCase
  include BookingHelper

  test '期間が重複する他人の予約がある時、作成できない' do
    drive = build(:drive)
    form = DriveForm::Create.from_drive(drive)

    with_conflicted_bookings drive do
      assert_not form.valid?
    end
  end

  test '期間が重複する自分の予約がある時、作成できる' do
    drive = build(:drive)
    form = DriveForm::Create.from_drive(drive)

    with_conflicted_bookings drive, is_mine: true do
      assert form.valid?
    end
  end

end