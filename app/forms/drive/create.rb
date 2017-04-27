class DriveForm
  class Create < ApplicationForm
    attribute :start_meter, Integer
    attribute :end_at_date, Date
    attribute :end_at_hour, Integer

    validates :start_meter, presence: true
    validates :end_at_date, presence: true
    validates :end_at_hour, presence: true

    validates :end_at_hour, inclusion: { in: 0..23 }
    validate :end_should_be_greater_than_start

    def attrs
      { start_at: start_at, end_at: end_at, start_meter: start_meter }
    end

    private
    def end_at
      end_at_date.at_beginning_of_day
                 .change(hour: end_at_hour)
    end

    def start_at
      Time.zone.now
    end

    def end_should_be_greater_than_start
      unless end_at > start_at
        errors.add(:end_at, '終了時刻を現在時刻よりも後にしてください')
      end
    end
  end
end