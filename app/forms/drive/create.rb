class DriveForm
  class Create < ApplicationForm
    attribute :start_meter, Integer
    attribute :using_hours, Integer

    validates :start_meter, presence: true
    validates :using_hours, presence: true

    def attributes_for_drive
      start_at = Time.zone.now
      end_at = start_at + using_hours.hours

      { start_at: start_at, end_at: end_at, start_meter: start_meter }
    end
  end
end