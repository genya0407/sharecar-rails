class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true
  validate :end_should_be_greater_than_start
  validate :conflicted_bookings_should_not_exist
  validate :conflicted_drives_should_not_exist

  def self.in_effect
    where('end_at > ?', Time.zone.now).order('start_at')
  end

  def self.between(start_at, end_at)
    where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  private

  def end_should_be_greater_than_start
    return unless car.present? && start_at.present? && end_at.present?

    errors.add(:end_at, '終了時刻は開始時刻より後に設定してください') unless start_at < end_at
  end

  def conflicted_bookings_should_not_exist
    return unless car.present? && start_at.present? && end_at.present?

    errors.add(:start_at, "その期間は#{conflicted_bookings.first.user.name}が車を予約しています") if conflicted_bookings.exists?
  end

  def conflicted_drives_should_not_exist
    return unless car.present? && start_at.present? && end_at.present?

    errors.add(:start_at, "その期間は#{conflicted_drives.first.user.name}が車を使用しています") if conflicted_drives.exists?
  end

  def conflicted_drives
    car.drives.not_end.between(start_at, end_at)
  end

  def conflicted_bookings
    car.bookings.where.not(id: id).between(start_at, end_at)
  end
end
