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
end