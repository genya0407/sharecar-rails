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
    CONSUMPTIONS_COUNT = 3
    FEE = 1000
    PAYMENT_AMOUNT = 1000
    NEW_FUEL_AMOUNT = 1000
    user = create(:user)
    cars = create_list(:car, CONSUMPTIONS_COUNT)
    consumptions = cars.map do |car|
      build(
        :consumption,
        car: car,
        price: 0,
        start_at: Time.zone.now - 10.days,
        end_at: Time.zone.now + 10.days
      )
    end

    stub_all_consumptions_for_calc_fee_of(consumptions, FEE) do
      # no payment
      expected_fee = CONSUMPTIONS_COUNT * FEE
      assert_equal expected_fee, user.reload.should_pay(all_consumptions: consumptions)

      # after pay
      create(:payment, user: user, amount: PAYMENT_AMOUNT)
      expected_fee -= PAYMENT_AMOUNT
      assert_equal User.find(user.id).reload.should_pay(all_consumptions: consumptions), expected_fee

      # one more pay
      create(:payment, user: user, amount: PAYMENT_AMOUNT)
      expected_fee -= PAYMENT_AMOUNT
      assert_equal User.find(user.id).reload.should_pay(all_consumptions: consumptions), expected_fee

      # 新しく給油したらその分feeが減ること
      create(:fuel, user: user, amount: NEW_FUEL_AMOUNT, car: cars.first)
      expected_fee -= NEW_FUEL_AMOUNT
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
