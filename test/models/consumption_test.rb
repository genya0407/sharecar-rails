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

  test '.calc_consumption' do
    FUEL_AMOUNT = 2000
    FUEL_COUNT = 10

    DRIVE_COUNT = 20
    DRIVE_DISTANCE = 20
    START_METER = rand(2000..3000)
    TOTAL_DISTANCE = DRIVE_COUNT * DRIVE_DISTANCE

    CONSUMPTION_START_AT = Time.zone.now - 10.days
    CONSUMPTION_END_AT = Time.zone.now

    fuels = build_list(:fuel, FUEL_COUNT, 
      amount: FUEL_AMOUNT,
      created_at: Faker::Time.between(CONSUMPTION_START_AT, CONSUMPTION_END_AT)
    )

    meters = (DRIVE_COUNT + 1).times.map { |i| START_METER + DRIVE_DISTANCE * i }
    drives = meters.drop(1).zip(meters).map do |end_meter, start_meter|
      build(:drive,
        start_meter: start_meter,
        end_meter: end_meter,
        created_at: Faker::Time.between(CONSUMPTION_START_AT, CONSUMPTION_END_AT)
      )
    end

    assert Consumption.calc_consumption(fuels, drives) == (FUEL_AMOUNT * FUEL_COUNT) / (DRIVE_DISTANCE * DRIVE_COUNT).to_f
  end
end
