FactoryGirl.define do
  factory :drive do
    transient do
      start_meter_transient { rand(100...100000) }
    end

    start_at { Time.zone.now }
    end_at { (Time.zone.now + 20.hour).change(minute: 0, second: 0) }
    start_meter { start_meter_transient }
    end_meter { start_meter_transient + rand(10..100) }
    association :user, factory: :user
    association :car, factory: :car

    factory :drive_not_end do
      end_meter { nil }
    end

    factory :drive_from_start_at do
      transient do
        start_at_transient { Time.zone.now }
      end

      start_at { start_at_transient }
      end_at { start_at_transient + rand(2..5).hours }
    end

    factory :drive_from_end_at do
      transient do
        end_at_transient { Time.zone.now }
      end

      start_at { end_at_transient - rand(2..5).hours }
      end_at { end_at_transient }
    end
  end
end