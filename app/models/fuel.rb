class Fuel < ApplicationRecord
  belongs_to :user
  belongs_to :car
  belongs_to :term

  validates :amount, presence: true
  validates :user, presence: true
  validates :car, presence: true
end
