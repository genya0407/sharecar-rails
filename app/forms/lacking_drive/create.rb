class LackingDriveForm
  class Create < ApplicationForm
    attribute :start_meter, Integer
    attribute :end_meter, Integer
    attribute :car_id, Integer
    attribute :user_id, Integer

    validates :start_meter, presence: true
    validates :end_meter,   presence: true
    validates :user_id,     presence: true
    validates :car_id,      presence: true

    validate :end_meter_gt_start_meter

    def save!
      Drive.new(attributes).save!
    end

    private

    def end_meter_gt_start_meter
      errors.add(:end_meter, '降車時のメーターは、乗車時のメーター以上の値でなければいけません') unless end_meter >= start_meter
    end
  end
end
