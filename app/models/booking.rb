class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :user

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :car_id, presence: true
  validates :user_id, presence: true
end
