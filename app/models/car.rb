class Car < ApplicationRecord
  has_many :bookings
  has_many :drives
end
