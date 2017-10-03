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
    assert user.update_attributes(
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
    assert_not user.update_attributes(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: Faker::Internet.password,
      password_confirmation: Faker::Internet.password
    )
  end

  test 'パスワードを変更できること' do
    user = create(:user)
    new_password = Faker::Internet.password
    assert user.update_attributes(
      name: Faker::Name.name,
      phone_number: Faker::PhoneNumber.phone_number,
      password: new_password,
      password_confirmation: new_password
    )
  end

  test 'パスワードを変更する時、confirmationがあっているかどうかチェックすること' do
    user = create(:user)
    assert_not user.update_attributes(
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

    # no payment
    consumptions = CONSUMPTIONS_COUNT.times.map { MiniTest::Mock.new.expect(:calc_fee_of, FEE, [User]) }
    expected_fee = CONSUMPTIONS_COUNT * FEE
    assert user.should_pay(all_consumptions: consumptions) == expected_fee

    # after pay
    create(:payment, user: user, amount: PAYMENT_AMOUNT)
    consumptions = CONSUMPTIONS_COUNT.times.map { MiniTest::Mock.new.expect(:calc_fee_of, FEE, [User]) }
    expected_fee -= PAYMENT_AMOUNT
    assert user.reload.should_pay(all_consumptions: consumptions) == expected_fee

    # one more pay
    create(:payment, user: user, amount: PAYMENT_AMOUNT)
    consumptions = CONSUMPTIONS_COUNT.times.map { MiniTest::Mock.new.expect(:calc_fee_of, FEE, [User]) }
    expected_fee -= PAYMENT_AMOUNT
    assert user.reload.should_pay(all_consumptions: consumptions) == expected_fee

    # 新しく給油したらその分feeが減ること
    create(:fuel, user: user, amount: NEW_FUEL_AMOUNT, car: create(:car))
    consumptions = CONSUMPTIONS_COUNT.times.map { MiniTest::Mock.new.expect(:calc_fee_of, FEE, [User]) }
    expected_fee -= NEW_FUEL_AMOUNT
    assert user.reload.should_pay(all_consumptions: consumptions) == expected_fee
  end
end