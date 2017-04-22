FactoryGirl.define do
  factory :user do
    transient do
      pass { Faker::Internet.password }
    end

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { pass }
    password_confirmation { pass }
  end
end