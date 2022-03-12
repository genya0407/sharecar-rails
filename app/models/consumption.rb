class Consumption < ApplicationRecord
  belongs_to :car

  def self.unfinished
    where(finished: false)
  end

  def calc_fee_of(user)
    drives = target_drives_of(user)
    total_distance = drives.sum(&:distance)
    total_distance * price
  end

  def recalculate
    target_fuels = car.fuels.in(start_at, end_at)
    target_drives = car.drives.in(start_at, end_at)

    new_price = target_fuels.sum(&:amount) / target_drives.sum(&:distance).to_f
    update(price: new_price)
  end

  private

  def target_drives_of(user)
    user.drives.where(car_id:).in(start_at, end_at)
  end
end
