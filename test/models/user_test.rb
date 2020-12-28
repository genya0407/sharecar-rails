require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'パスワードを設定せずにUserを作成できること' do
    user = User.new(email: Faker::Internet.email)
    assert user.save
  end

  test 'パスワードを設定してUserを作成するとき、confirmationがあってるかどうかチェックすること' do
    user = User.new(
      email: Faker::Internet.email,
      password: Faker::Internet.password,
      password_confirmation: Faker::Internet.password
    )
    assert_not user.save
  end

  test 'パスワードを設定することができること' do
    user = User.new(email: Faker::Internet.email)
    user.save!

    password = Faker::Internet.password
    assert user.update(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: password,
      password_confirmation: password
    )
  end

  test 'パスワードを設定するとき、confirmationがあっているかチェックすること' do
    user = User.new(email: Faker::Internet.email)
    user.save!

    password = Faker::Internet.password
    assert_not user.update(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: Faker::Internet.password,
      password_confirmation: Faker::Internet.password
    )
  end

  test 'パスワードを変更できること' do
    user = create(:user)
    new_password = Faker::Internet.password
    assert user.update(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: new_password,
      password_confirmation: new_password
    )
  end

  test 'パスワードを変更する時、confirmationがあっているかどうかチェックすること' do
    user = create(:user)
    assert_not user.update(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: Faker::Internet.password,
      password_confirmation: Faker::Internet.password
    )
  end

  test '#should_pay' do
    consumption_count = 3
    stubbed_fee = 1000
    payment_amount = 1000
    new_fuel_amount = 1000
    user = create(:user)
    cars = create_list(:car, consumption_count)
    consumptions = cars.map do |car|
      build(
        :consumption,
        car: car,
        price: 0,
        start_at: Time.zone.now - 10.days,
        end_at: Time.zone.now + 10.days
      )
    end

    stub_all_consumptions_for_calc_fee_of(consumptions, stubbed_fee) do
      # no payment
      expected_fee = consumption_count * stubbed_fee
      assert_equal expected_fee, user.reload.should_pay(all_consumptions: consumptions)

      # after pay
      create(:payment, user: user, amount: payment_amount)
      expected_fee -= payment_amount
      assert_equal User.find(user.id).reload.should_pay(all_consumptions: consumptions), expected_fee

      # one more pay
      create(:payment, user: user, amount: payment_amount)
      expected_fee -= payment_amount
      assert_equal User.find(user.id).reload.should_pay(all_consumptions: consumptions), expected_fee

      # 新しく給油したらその分feeが減ること
      create(:fuel, user: user, amount: new_fuel_amount, car: cars.first)
      expected_fee -= new_fuel_amount
      assert_equal User.find(user.id).reload.should_pay(all_consumptions: consumptions), expected_fee
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
