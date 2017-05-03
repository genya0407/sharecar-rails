FactoryGirl.define do
  factory :user do
    transient do
      password_trans { Faker::Internet.password(10, 20) }
    end

    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    password { password_trans }
    password_confirmation { password_trans }

    after(:create) do |user|
      user.activate!
    end
  end

  factory :user_not_activated, class: User do
    email { Faker::Internet.email }
  end
end