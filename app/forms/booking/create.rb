class BookingForm
  class Create < ApplicationForm
    attribute :start_at_date, Date
    attribute :start_at_hour, Integer
    attribute :end_at_date, Date
    attribute :end_at_hour, Integer

    validates :start_at_date, presence: true
    validates :start_at_hour, presence: true
    validates :end_at_date, presence: true
    validates :end_at_hour, presence: true
    validates :start_at_hour, inclusion: { in: 0..23 }
    validates :end_at_hour, inclusion: { in: 0..23 }

    validate :end_should_be_greater_than_begin

    def attrs
      {
        start_at: start_at,
        end_at: end_at
      }
    end

    private
    def end_should_be_greater_than_begin
      unless end_at > start_at
        errors.add(:end_at, '終了時刻は開始時刻より後にしてください')
      end
    end

    def start_at
      start_at_date.at_beginning_of_day
                   .change(hour: start_at_hour)
    end

    def end_at
      end_at_date.at_beginning_of_day
                 .change(hour: end_at_hour)
    end
  end
end