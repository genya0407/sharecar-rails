class User < ApplicationRecord
  has_many :drives
  has_many :bookings

  authenticates_with_sorcery!
  validates :password, presence: true, confirmation: true, on: :update

  before_create :setup_activation
  after_create :send_activation_needed_email!

  enum permission: { admin: 0, member: 5 }
end