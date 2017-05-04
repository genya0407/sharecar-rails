class Term < ApplicationRecord
  has_many :fuels
  has_many :drives
  has_many :bills

  validation :name, presence: true
end
