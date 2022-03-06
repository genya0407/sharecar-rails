require 'test_helper'

class UserShouldPayTest < ActiveSupport::TestCase
  def stubbed_fee
    1000
  end

  def cars
    @cars ||= create_list(:car, 3)
  end

  def user
    @user ||= create(:user)
  end

  def consumptions
    @consumptions ||= cars.map do |car|
      build(
        :consumption,
        car: car,
        price: 0,
        start_at: Time.zone.now - 10.days,
        end_at: Time.zone.now + 10.days
      )
    end
  end

  test '#should_pay paymentがないとき、calc_fee_ofの合計値を返す' do
    expected_fee = consumptions.size * stubbed_fee

    stub_all_consumptions_for_calc_fee_of(consumptions, stubbed_fee) do
      assert_equal expected_fee, user.reload.should_pay(all_consumptions: consumptions)
    end
  end

  test '#should_pay paymentが2つあるとき、calc_fee_ofの合計値 - payment.amountの合計値を返す' do
    payment1 = create(:payment, user: user, amount: 700)
    payment2 = create(:payment, user: user, amount: 800)
    expected_fee = (consumptions.size * stubbed_fee) - (payment1.amount + payment2.amount)

    stub_all_consumptions_for_calc_fee_of(consumptions, stubbed_fee) do
      assert_equal expected_fee, User.find(user.id).reload.should_pay(all_consumptions: consumptions)
    end
  end

  test '#should_pay fuelが2つあるとき、calc_fee_ofの合計値 - fuel.amountの合計値を返す' do
    fuel1 = create(:fuel, user: user, amount: 300, car: cars.first)
    fuel2 = create(:fuel, user: user, amount: 400, car: cars.second)
    expected_fee = (consumptions.size * stubbed_fee) - (fuel1.amount + fuel2.amount)

    stub_all_consumptions_for_calc_fee_of(consumptions, stubbed_fee) do
      assert_equal expected_fee, User.find(user.id).reload.should_pay(all_consumptions: consumptions)
    end
  end

  def stub_all_consumptions_for_calc_fee_of(consumptions, fee, &blk)
    consumption = consumptions.first
    if consumption
      consumption.stub(:calc_fee_of, fee) do
        stub_all_consumptions_for_calc_fee_of(consumptions.drop(1), fee, &blk)
      end
    else
      blk.call
    end
  end
end
