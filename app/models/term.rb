class Term < ApplicationRecord
  has_many :fuels
  has_many :drives
  has_many :bills

  validates :name, presence: true
end
