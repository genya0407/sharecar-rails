class Car < ApplicationRecord
  has_many :bookings
  has_many :drives, class_name: 'Drive'

  def occupied?
    drives.where(end_meter: nil).exists?
  end

  def current_drive
    drives.order(created_at: :desc).find_by(end_meter: nil)
  end

  def current_driver
    current_drive&.user
  end

  def using_drive(user_id)
    @using_drive ||= drives.find_by(end_meter: nil, user_id: user_id)
  end

  def using?(user_id)
    using_drive(user_id).present?
  end
end
