class Car < ApplicationRecord
  has_many :bookings
  has_many :drives, class_name: 'Drive'

  def occupied?
    drives.where(end_meter: nil).exists?
  end

  def using_drive(user_id)
    @using_drive ||= drives.find_by(end_meter: nil, user_id: user_id)
  end

  def using?(user_id)
    using_drive(user_id).present?
  end
end
