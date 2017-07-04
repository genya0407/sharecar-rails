require 'helpers/range'

module DriveHelper
  include RangeHelper

  def with_conflicted_drives(has_range, is_mine: false)
    strategies = [:end_in_range, :start_in_range, :cover_range, :in_range]
    strategies.each do |strategy_method_name|
      conflict = create(:drive, drive_params(strategy_method_name, has_range, is_mine))
      yield conflict
      conflict.destroy!
    end
  end

  def create_continuous_drives(car, users: nil, n: 30)
    users ||= rand(3..5).times.map { create(:user) }
    start_meter = 0
    end_meter = rand(10..100)
    start_at = Time.zone.now
    end_at = start_at + rand(2..10).hours
    drive_params = n.times.map do
      params = {
        user: users.sample,
        car: car,
        start_meter: start_meter,
        end_meter: end_meter,
        start_at: start_at,
        end_at: end_at
      }
      start_meter = end_meter
      end_meter = start_meter + rand(10..100)
      start_at = end_at + rand(5..20).hours
      end_at = start_at + rand(2..10).hours
      params
    end
    Drive.create(drive_params)
  end

  private
  def drive_params(strategy_method_name, has_range, is_mine)
    start_at, end_at = send(strategy_method_name, has_range)
    {
      start_at: start_at,
      end_at: end_at,
      car: has_range.car,
      end_meter: nil,
      user: is_mine ? has_range.user : create(:user)
    }
  end
end