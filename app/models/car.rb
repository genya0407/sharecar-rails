class Car < ApplicationRecord
  has_many :bookings
  has_many :drives, class_name: 'Drive'
  has_many :fuels

  enum status: { available: 0, repairing: 10, scrapped: 20 }

  STATUS_NAMES = {
    available: '使用可能',
    repairing: '使用禁止',
    scrapped: '廃車'
  }.freeze

  def status_jp
    STATUS_NAMES[status.to_sym]
  end

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
