FactoryGirl.define do
  factory :fuel do
    amount { rand(1000..5000) }
    association :user, factory: :user
    association :car, factory: :car
  end
end