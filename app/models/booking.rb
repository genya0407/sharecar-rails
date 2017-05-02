class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  with_options if: 'car.present? && start_at.present? && end_at.present?' do |basically_valid|
    basically_valid.validate :end_should_be_greater_than_start
    basically_valid.validate :conflicted_bookings_should_not_exist
    basically_valid.validate :conflicted_drives_should_not_exist 
  end

  def self.in_effect
    where('end_at > ?', Time.zone.now).order('start_at')
  end

  def self.between(start_at, end_at)
    where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  def conflicted_bookings
    self.car.bookings.where.not(id: id).between(start_at, end_at)
  end

  def conflicted_drives
    self.car.drives.not_end.between(start_at, end_at)
  end

  private
  def end_should_be_greater_than_start
    unless start_at < end_at
      errors.add(:end_at, '終了時刻は開始時刻より後に設定してください')
    end
  end

  def conflicted_bookings_should_not_exist
    if conflicted_bookings.exists?
      errors.add(:start_at, "その期間は#{conflicted_bookings.first.user.name}が車を予約しています")
    end
  end

  def conflicted_drives_should_not_exist
    if conflicted_drives.exists?
      errors.add(:start_at, "その期間は#{conflicted_drives.first.user.name}が車を使用しています")
    end
  end
end
