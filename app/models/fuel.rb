class Fuel < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :amount, presence: true
  validates :user, presence: true
  validates :car, presence: true

  include OnlyChecked
end
