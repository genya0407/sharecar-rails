class Drive < ApplicationRecord
  belongs_to :car
  belongs_to :user
  belongs_to :term

  validates :start_meter, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  def self.last_meter(car_id)
    (where(car_id: car_id).maximum(:end_meter) || 0)
  end

  def self.between(start_at, end_at)
    where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  def self.not_end
    where(end_meter: nil)
  end

  def self.lack_exist?
    target_drive = order(:start_meter)
    target_drive.zip(target_drive.drop(1))
                .reverse.drop(1).reverse
                .any? { |drive1, drive2| drive1.end_meter != drive2.start_meter }
  end

  def conflicted_drives
    self.car.drives.where.not(id: id).not_end.between(start_at, end_at)
  end
end