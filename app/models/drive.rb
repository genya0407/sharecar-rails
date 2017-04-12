class Drive < ApplicationRecord
  belongs_to :car
  has_many :user_drives
  has_many :users, through: :user_drives
end