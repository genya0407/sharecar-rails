FactoryGirl.define do
  factory :booking do
    start_at { Time.zone.now - 3.hour }
    end_at { Time.zone.now + 3.hour }
    association :user, factory: :user
    association :car, factory: :car
  end
end