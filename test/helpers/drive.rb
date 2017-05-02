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

  private
  def drive_params(strategy_method_name, has_range, is_mine)
    start_at, end_at = send(strategy_method_name, has_range)
    {
      start_at: start_at,
      end_at: end_at,
      car: has_range.car,
      user: is_mine ? has_range.user : create(:user)
    }
  end
end