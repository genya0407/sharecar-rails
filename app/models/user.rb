class User < ApplicationRecord
  has_many :drives
  has_many :bookings

  authenticates_with_sorcery!
  validates :password, confirmation: true

  enum permission: { admin: 0, member: 5 }
end