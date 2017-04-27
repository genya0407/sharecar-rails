class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  validate :end_should_be_greater_than_start
  validate :conflict_should_not_exist

  def self.in_effect
    where('end_at > ?', Time.zone.now).order('start_at')
  end

  def conflicted_bookings
    self.car.bookings.where.not('end_at <= ? OR ? <= start_at', start_at, end_at)
  end

  private
  def end_should_be_greater_than_start
    unless start_at < end_at
      errors.add(:end_at, '終了時刻は開始時刻より後に設定してください')
    end
  end

  def conflict_should_not_exist
    if conflicted_bookings.exists?
      errors.add(:start_at, '期間が重なる予約があります')
    end
  end
end
