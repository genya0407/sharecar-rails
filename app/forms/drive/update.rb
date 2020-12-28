class DriveForm
  class Update < ApplicationForm
    attribute :end_meter, Integer

    validates :end_meter, presence: true
    validate :end_meter_gt_start_meter
    validate :car_should_be_available

    attr_reader :drive

    def initialize(drive, args = {})
      super(args)
      @drive = drive
    end

    private

    def end_meter_gt_start_meter
      errors.add(:end_meter, '降車時のメーターは、乗車時のメーター以上の値でなければいけません') unless end_meter >= drive.start_meter
    end

    def car_should_be_available
      errors.add(:end_meter, "#{@drive.car.name}は使用禁止です") unless @drive.car.available?
    end
  end
end
