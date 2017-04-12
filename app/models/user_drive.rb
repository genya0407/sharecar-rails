class UserDrive < ApplicationRecord
  belongs_to :user
  belongs_to :drive
end
