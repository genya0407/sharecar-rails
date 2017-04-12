class User < ApplicationRecord
  has_many :user_drives
  has_many :drives, through: :user_drives
  has_many :user_bookings
  has_many :bookings, through: :user_bookings

  authenticates_with_sorcery!
  validates :password, confirmation: true
end
