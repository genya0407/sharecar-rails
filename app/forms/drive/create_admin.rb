class DriveForm
  class Admin < ApplicationForm
    attribute :start_meter, Integer
    attribute :end_meter, Integer
    attribute :car_id, Integer
    attribute :user_id, Integer

    validates :start_meter, presence: true
    validates :end_meter,   presence: true
    validates :user_id,     presence: true
    validates :car_id,      presence: true

    def self.from_drive(drive)
      params = drive.attributes.symbolize_keys.slice(
        :start_meter,
        :end_meter,
        :car_id,
        :user_id
      )

      self.new(params)
    end

    def save!
      Drive.new(attributes).save!
    end
  end
end