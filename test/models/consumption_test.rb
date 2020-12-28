require 'test_helper'

class ConsumptionTest < ActiveSupport::TestCase
  test '#calc_fee_of' do
    me, other_user = create_list(:user, 2)
    car1, car2 = create_list(:car, 2)

    # 合計で20km走る
    _my_drives_for_car1 = [
      create(:drive, car: car1, user: me, start_meter: 10, end_meter: 20, start_at: 1.day.ago, end_at: 1.day.since),
      create(:drive, car: car1, user: me, start_meter: 20, end_meter: 30, start_at: 1.day.ago, end_at: 1.day.since)
    ]
    # 他の車の値が混ざらないことを確認するため
    _my_drive_for_car2 = create(:drive, car: car2, user: me, start_meter: 100, end_meter: 200)
    # 他のユーザーの値が混ざらないことを確認するため
    _others_drive_for_car1 = create(:drive, car: car1, user: other_user, start_meter: 100, end_meter: 200)

    consumption = create(:consumption, car: car1, price: 13, start_at: 10.days.ago, end_at: 10.days.since)

    assert_equal 13 * 20, consumption.calc_fee_of(me)
  end
end
