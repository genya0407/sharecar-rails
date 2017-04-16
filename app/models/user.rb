class User < ApplicationRecord
  has_many :drives
  has_many :bookings

  authenticates_with_sorcery!
  validates :password, confirmation: true
end
