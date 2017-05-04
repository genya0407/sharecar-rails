require 'test_helper'
require 'helpers/drive'

class TermTest < ActiveSupport::TestCase
  include DriveHelper

  test '#collect_records!' do
    old_term = create(:term)
    rand(5..10).times { create(:drive, term: old_term) }
    rand(2..5).times { create(:fuel, term: old_term) }

    drive_count = rand(5..10)
    fuel_count = rand(2..5)

    drive_count.times { create(:drive, term: nil) }
    fuel_count.times { create(:fuel, term: nil) }
    rand(2..5).times { create(:drive, term: nil, end_meter: nil) }

    new_term = create(:term)
    assert_difference 'new_term.drives.count', drive_count do
      assert_difference 'new_term.fuels.count', fuel_count do
        new_term.collect_records!
      end
    end
  end

  test '#consumption' do
    car = create(:car)
    drives = create_continuous_drives(car)
    fuels = rand(3..6).times.map { create(:fuel, term: nil, car: car) }
    meter_sum = drives.sum { |drive| drive.end_meter - drive.start_meter }
    fuel_sum = fuels.sum(&:amount)

    term = create(:term)
    term.collect_records!

    assert term.consumption(car.id) == (fuel_sum.to_f / meter_sum.to_f)
  end

  test '#issue_bills!' do
    car = create(:car)
    users = rand(3..10).times.map { create(:user) }
    drives = create_continuous_drives(car)
    fuels = rand(3..6).times.map { create(:fuel, term: nil, car: car) }
    term = create(:term)
    term.collect_records!
    term.issue_bills!

    # Billのamountの型はIntegerなので、saveするときに誤差が出る。
    # 誤差は、１レコードにつき高々１円なので、以下のように誤差を評価する。
    assert term.bills.sum(:amount).between?(-(users.count), users.count)
  end
end
