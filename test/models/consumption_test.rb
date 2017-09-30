require 'test_helper'
require 'helpers/drive'

class ConsumptionTest < ActiveSupport::TestCase
  include DriveHelper

  CONSUMPTION_PRICE_0 = 10
  CONSUMPTION_PRICE_1 = 20

  test '#calc_fee_of' do
    users = create_list(:user, 2)
    me = users[0]
    other = users[2]
    cars = create_list(:car, 2)

    my_total_fee = 0.0
    my_total_fee += CONSUMPTION_PRICE_0 * create_continuous_drives(cars[0], users: [me], n: 5).sum(&:distance)
    my_total_fee += CONSUMPTION_PRICE_1 * create_continuous_drives(cars[1], users: [me], n: 5).sum(&:distance)
    create(:consumption,
      car: cars[0],
      price: CONSUMPTION_PRICE_0,
      start_at: Time.zone.now - 10.hours,
      end_at: Time.zone.now + 100.hours
    )
    create(:consumption,
      car: cars[1],
      price: CONSUMPTION_PRICE_1,
      start_at: Time.zone.now - 10.hours,
      end_at: Time.zone.now + 100.hours
    )

    # 他のユーザーの乗車記録が混ざらないことを確認するため
    create_continuous_drives(cars[0], users: [other], n: 5)
    create_continuous_drives(cars[1], users: [other], n: 5)

    assert my_total_fee == Consumption.all.sum { |cons| cons.calc_fee_of(me) }
  end
end
