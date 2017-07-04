class DriveForm
  class Update < ApplicationForm
    attribute :end_meter, Integer

    validates :end_meter, presence: true
    validate :end_meter_gt_start_meter

    attr_reader :drive

    def initialize(drive, args={})
      super(args)
      @drive = drive
    end

    private
      def end_meter_gt_start_meter
        unless end_meter >= drive.start_meter
          errors.add(:end_meter, '降車時のメーターは、乗車時のメーター以上の値でなければいけません')
        end
      end
  end
end