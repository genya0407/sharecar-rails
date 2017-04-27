module BookingHelper
  class Faker::Time
    def self.between(from, to)
      rand(from..to)
    end
  end

  # creates bookings in effect and bookings not in effect
  # returns number of bookings in effect
  def create_in_effect(car)
    # current: start_at < now < end_at
    current_count = 1
    current_start_at = Time.zone.now - rand(2..5).hours
    current_end_at = Time.zone.now + rand(2..5).hours
    create(:booking, car: car, start_at: current_start_at, end_at: current_end_at)

    # future: now < start_at < end_at
    # 期間が重ならないように、前に作ったbookingのend_atを覚えておいて、
    # それよりも後ろに次のbookingを作るようにしている
    future_count = rand(2..5)
    end_at = current_end_at
    future_count.times do
      start_at = end_at + rand(2..5).hours
      end_at = start_at + rand(2..5).hours
      create(:booking, car: car, start_at: start_at, end_at: end_at)
    end

    # past: start_at < end_at < now
    # 期間が重ならないように、前に作ったbookingのstart_atを覚えておいて、
    # それよりも前に次のbookingを作るようにしている
    start_at = current_start_at
    rand(2..5).times do
      end_at = start_at - rand(2..5).hours
      start_at = end_at - rand(2..5).hours
      create(:booking, car: car, start_at: start_at, end_at: end_at)
    end

    # another car
    create(:booking)

    current_count + future_count
  end

  # has_range: start_atとend_atと*car*を持つオブジェクト
  def with_conflicted_bookings(has_range)
    conflict = create_booking_end_in_range(has_range)
    yield conflict
    conflict.destroy!

    conflict = create_booking_start_in_range(has_range)
    yield conflict
    conflict.destroy!

    conflict = create_booking_cover_range(has_range)
    yield conflict
    conflict.destroy!

    conflict = create_booking_in_range(has_range)
    yield conflict
    conflict.destroy!
  end

  private
  def create_booking_end_in_range(has_range)
    end_at = Faker::Time.between(has_range.start_at, has_range.end_at)
    create(:booking, car: has_range.car, start_at: has_range.start_at - rand(2..5).hour, end_at: end_at)
  end

  def create_booking_start_in_range(has_range)
    start_at = Faker::Time.between(has_range.start_at, has_range.end_at)
    create(:booking, car: has_range.car, start_at: start_at, end_at: has_range.end_at + rand(2..5).hour)
  end

  def create_booking_cover_range(has_range)
    create(:booking,
           car: has_range.car,
           start_at: has_range.start_at - rand(2..5).hour,
           end_at: has_range.end_at + rand(2..5).hour)
  end

  def create_booking_in_range(has_range)
    middle = Faker::Time.between(has_range.start_at, has_range.end_at)
    start_at = Faker::Time.between(has_range.start_at, middle)
    end_at = Faker::Time.between(middle, has_range.end_at)
    create(:booking,
            car: has_range.car,
            start_at: start_at,
            end_at: end_at)
  end
end