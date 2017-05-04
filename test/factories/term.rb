FactoryGirl.define do
  factory :term do
    name { Faker::Name.name }
  end
end