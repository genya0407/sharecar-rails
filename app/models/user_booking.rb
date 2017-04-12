class UserBooking < ApplicationRecord
  belongs_to :user
  belongs_to :booking

  validates :user_id, presence: true
  validates :booking_id, presence: true
end
