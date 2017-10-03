class Consumption < ApplicationRecord
  belongs_to :car

  def self.unfinished
    where(finished: false)
  end

  def self.calc_consumption(target_fuels, target_drives)
    target_fuels.sum(&:amount) / target_drives.sum(&:distance).to_f
  end

  def calc_fee_of(user)
    drives = target_drives_of(user)
    total_distance = drives.sum(&:distance)
    total_distance * price
  end

  private
  def target_drives_of(user)
    user.drives.where(car_id: car_id).in(start_at, end_at)
  end
end
