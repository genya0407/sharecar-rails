class Consumption < ApplicationRecord
  belongs_to :car

  def calc_fee_of(user)
    drives = target_drives_of(user)
    total_distance = drives.sum(&:distance)
    total_distance * price
  end

  private
  def target_drives_of(user)
    user.drives.where(car_id: car_id).where('? <= start_at AND start_at < ?', start_at, end_at)
  end
end
