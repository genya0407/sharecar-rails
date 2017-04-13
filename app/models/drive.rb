class Drive < ApplicationRecord
  belongs_to :car
  has_many :user_drives
  has_many :users, through: :user_drives

  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :start_meter, presence: true
  validates :car_id, presence: true
end