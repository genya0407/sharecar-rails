class Car < ApplicationRecord
  has_many :bookings
  has_many :drives, class_name: 'Drive'

  def occupied?
    now = Time.zone.now
    drives.where("start_at < ? AND ? <= end_at", now, now).exists?
  end
end
