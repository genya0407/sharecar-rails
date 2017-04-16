class Car < ApplicationRecord
  has_many :bookings
  has_many :drives, class_name: 'Drive'

  def occupied?
    drives.where(end_meter: nil).exists?
  end
end
