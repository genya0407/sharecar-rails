class Drive < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :start_meter, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true

  def self.last_meter(car_id)
    where(car_id: car_id).maximum(:end_meter)
  end
end