class Fuel < ApplicationRecord
  belongs_to :user
  belongs_to :car

  validates :amount, presence: true
  validates :user, presence: true
  validates :car, presence: true

  include OnlyChecked

  def self.in(start_at, end_at)
    where('? <= created_at AND created_at < ?', start_at, end_at)
  end
end
