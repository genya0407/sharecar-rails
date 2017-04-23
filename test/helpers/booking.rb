module BookingHelper
  # creates bookings in effect and bookings not in effect
  # returns number of bookings in effect
  def create_in_effect(car)
    # current: start_at < now < end_at
    current_count = rand(2..5)
    current_count.times { create(:booking, car: car) }

    # future: now < start_at < end_at
    future_count = rand(2..5)
    future_count.times do
      start_at = Time.zone.now + rand(2..5).hours
      end_at = start_at + rand(2..5).hours
      create(:booking, car: car, start_at: start_at, end_at: end_at)
    end

    # past: start_at < end_at < now
    end_at = Time.zone.now - rand(1..3).hours
    start_at = end_at - rand(3..10).hours
    rand(2..5).times { create(:booking, car: car, start_at: start_at, end_at: end_at) }

    # another car
    rand(2..5).times { create(:booking) }

    current_count + future_count
  end
end