class Term < ApplicationRecord
  has_many :fuels
  has_many :drives
  has_many :bills

  validates :name, presence: true

  def collect_records!
    Fuel.where(term_id: nil).update(term: self)
    Drive.where(term_id: nil).where.not(end_meter: nil).update(term: self)
  end

  def issue_bills!
    User.all.each do |user|
      supplied_fuel_amount = fuels.where(user: user).sum(:amount)
      used_fuel_amount = Car.all.map do |car|
        meter_sum = drives.where(car: car, user: user)
                          .sum { |drive| drive.end_meter - drive.start_meter }
        meter_sum * consumption(car.id)
      end.sum

      amount = used_fuel_amount - supplied_fuel_amount
      Bill.create(user: user, term: self, amount: amount)
    end
  end

  def consumption(car_id)
    @consumption_cache ||= {}

    unless @consumption_cache.has_key?(car_id)
      fuel_sum = fuels.where(car_id: car_id).sum(:amount)
      meter_sum = drives.where(car_id: car_id).map { |drive| drive.end_meter - drive.start_meter }.sum

      @consumption_cache[car_id] = fuel_sum.to_f / meter_sum.to_f
    end

    @consumption_cache[car_id]
  end
end
