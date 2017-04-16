class DriveForm
  class Create < ApplicationForm
    attribute :start_meter, Integer
    attribute :using_hours, Integer

    validates :start_meter, presence: true
    validates :using_hours, presence: true

    validate :biggest_meter

    attr_reader :drive

    def initialize(drive, args)
      super(args)
      @drive = drive
    end

    def valid?
      if super
        @drive.attributes = attributes_for_drive
      end
    end

    def attributes_for_drive
      start_at = Time.zone.now
      end_at = start_at + using_hours.hours

      { start_at: start_at, end_at: end_at, start_meter: start_meter }
    end

    private
      def biggest_meter
        return true if drive.car_id.nil?

        unless start_meter >= Drive.last_meter(drive.car_id)
          errors.add(:start_meter, '乗車時のメーターが、過去のメーターよりも小さいです')
        end
      end
  end
end