class Booking < ApplicationRecord
  belongs_to :car
  has_many :user_bookings
  has_many :users, through: :user_bookings

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :car_id, presence: true
end
