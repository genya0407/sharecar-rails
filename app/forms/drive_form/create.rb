module DriveForm
  class Create < ApplicationForm
    attribute :start_meter, Integer
    attribute :end_at_date, Date
    attribute :end_at_hour, Integer
    attribute :car_id, Integer
    attribute :user_id, Integer

    validates :start_meter, presence: true
    validates :end_at_date, presence: true
    validates :end_at_hour, presence: true
    validates :user_id,     presence: true
    validates :car_id,      presence: true

    validates :end_at_hour, inclusion: { in: 0..23 }
    validate :end_should_be_greater_than_start
    validate :car_should_be_available

    validate :conflicted_bookings_should_not_exist,
             if: -> { car_id.present? && user_id.present? && end_at.present? }

    def self.from_drive(drive)
      params = drive.attributes.symbolize_keys.slice(:start_meter, :car_id, :user_id)
      params.merge!(end_at_date: drive.end_at.to_date, end_at_hour: drive.end_at.hour)

      new(params)
    end

    def save!
      params = {
        start_at: start_at,
        end_at: end_at,
        start_meter: start_meter,
        car_id: car_id,
        user_id: user_id
      }
      Drive.new(params).save!
    end

    private

    def end_at
      end_at_date.at_beginning_of_day
                 .change(hour: end_at_hour)
    end

    def start_at
      @start_at = Time.zone.now
    end

    def end_should_be_greater_than_start
      errors.add(:end_at, '終了時刻を現在時刻よりも後にしてください') unless end_at > start_at
    end

    def conflicted_bookings_should_not_exist
      @car ||= Car.find(car_id)
      errors.add(:end_at, "その期間、#{@car.name}は予約されています") if @car.bookings.where.not(user_id: user_id).between(start_at, end_at).exists?
    end

    def car_should_be_available
      @car ||= Car.find(car_id)
      errors.add(:car_id, "#{@car.name}は使用禁止です") unless @car.available?
    end
  end
end
