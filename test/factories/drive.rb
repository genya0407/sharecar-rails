FactoryGirl.define do
  factory :drive do
    transient do
      start_meter_transient  { rand(100...100000) }
    end

    start_at { Time.zone.now - 1.hour }
    end_at { Time.zone.now + 2.hour }
    start_meter { start_meter_transient }
    end_meter { start_meter_transient + rand(10..100) }
    association :user, factory: :user
    association :car, factory: :car

    factory :drive_not_end do
      end_meter { nil }
    end
  end
end