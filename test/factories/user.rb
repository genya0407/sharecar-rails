FactoryGirl.define do
  factory :user do
    transient do
      password_trans { Faker::Internet.password(10, 20) }
    end

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { password_trans }
    password_confirmation { password_trans }

    after(:create) do |user|
      user.activate!
    end

    factory :user_not_activated do
      after(:create) do |user|
        user.setup_activation
        user.save!
      end
    end
  end
end