require 'helpers/range'

module BookingHelper
  include RangeHelper

  # creates bookings in effect and bookings not in effect
  # returns number of bookings in effect
  def create_in_effect(car)
    # current: start_at < now < end_at
    current_start_at = Time.zone.now - rand(2..5).hours
    current_end_at = Time.zone.now + rand(2..5).hours
    current = create(:booking, car: car, start_at: current_start_at, end_at: current_end_at)

    # future: now < start_at < end_at
    # 期間が重ならないように、前に作ったbookingのend_atを覚えておいて、
    # それよりも後ろに次のbookingを作るようにしている
    future_count = rand(2..5)
    end_at = current_end_at
    futures = future_count.times.map do
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

    return (futures + [current])
  end

  # has_range: start_atとend_atと*car*を持つオブジェクト
  # my: trueの時、作成するbookingのuserはhas_rangeのuserになる
  def with_conflicted_bookings(has_range, is_mine: false)
    strategies = [:end_in_range, :start_in_range, :cover_range, :in_range]
    strategies.each do |strategy_method_name|
      conflict = create(:booking, booking_params(strategy_method_name, has_range, is_mine))
      yield conflict
      conflict.destroy!
    end
  end

  private
  def booking_params(strategy_method_name, has_range, is_mine)
    start_at, end_at = send(strategy_method_name, has_range)
    {
      start_at: start_at,
      end_at: end_at,
      car: has_range.car,
      user: is_mine ? has_range.user : create(:user)
    }
  end
end