class Drive < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :start_meter, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  validate :conflicted_bookings_should_not_exist,
           if: 'car.present? && user.present? && start_at.present? && end_at.present?'

  def self.last_meter(car_id)
    (where(car_id: car_id).maximum(:end_meter) || 0)
  end

  def self.between(start_at, end_at)
    where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  def conflicted_drives
    self.car.drives.between(start_at, end_at)
  end

  private
  def conflicted_bookings_should_not_exist
    if self.car.bookings.between(start_at, end_at).exists?
      errors.add(:end_at, "その期間、#{self.car.name}は予約されています")
    end
  end
end