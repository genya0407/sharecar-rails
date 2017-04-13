class DriveForm
  class Create < ApplicationForm
    attribute :car_id, Integer
    attribute :start_at, DateTime, default: Time.zone.now
    attribute :end_at, DateTime, default: Time.zone.now
    attribute :start_meter, Integer, default: Drive.maximum(:end_meter)
    attribute :end_meter, Integer
    attribute :driver_ids, Array[Integer]

    attr_reader :drive, :user_drives

    validate :drive_valid?, :drivers_exist?

    private
      def persist!
        ActiveRecord::Base.transaction do
          @drive.save!
          @user_drives.each do |user_drive|
            user_drive.drive_id = @drive.id
            user_drive.save!
          end
        end
      end

      def drive_valid?
        @drive = Drive.new(
          start_at: start_at,
          end_at: end_at,
          start_meter: start_meter,
          end_meter: end_meter,
          car_id: car_id
        )

        unless drive.valid?
          drive.errors.each do |key, message|
            errors.add(key, message)
          end
        end
      end

      def drivers_exist?
        nil_user_ids = driver_ids.reject do |driver_id|
          User.exists?(id: driver_id)
        end

        if nil_user_ids.empty?
          @user_drives = driver_ids.map do |driver_id|
            UserDrive.new(user_id: driver_id)
          end
        else
          errors.add(:driver_ids, "User #{nil_user_ids.join(',')} does not exist.")
        end
      end
  end
end