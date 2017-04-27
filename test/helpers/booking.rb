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

  def create_end_in_range(booking)
    end_at = Faker::Time.between(booking.start_at, booking.end_at)
    create(:booking, car: booking.car, start_at: booking.start_at - rand(2..5).hour, end_at: end_at)
  end

  def create_start_in_range(booking)
    start_at = Faker::Time.between(booking.start_at, booking.end_at)
    create(:booking, car: booking.car, start_at: start_at, end_at: booking.end_at + rand(2..5).hour)
  end

  def create_cover_range(booking)
    create(:booking,
           car: booking.car,
           start_at: booking.start_at - rand(2..5).hour,
           end_at: booking.end_at + rand(2..5).hour)
  end

  def create_in_range(booking)
    middle = Faker::Time.between(booking.start_at, booking.end_at)
    start_at = Faker::Time.between(booking.start_at, middle)
    end_at = Faker::Time.between(middle, booking.end_at)
    create(:booking,
            car: booking.car,
            start_at: start_at,
            end_at: end_at)
  end
end