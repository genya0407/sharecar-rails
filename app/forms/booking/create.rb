class BookingForm
  class Create
    include Virtus.model
    include ActiveModel::Model

    attribute :start_at, DateTime
    attribute :end_at, DateTime
    attribute :car_id, Integer
    attribute :driver_ids, Array[Integer]

    attr_reader :booking, :user_bookings

    validate :booking_valid?, :drivers_exist?

    def save
      if valid?
        persist!
        true
      else
        false
      end
    end

    private
      def persist!
        ActiveRecord::Base.transaction do
          @booking.save!
          @user_bookings.each do |user_booking|
            user_booking.booking_id = @booking.id
            user_booking.save!
          end
        end
      end

      def booking_valid?
        @booking = Booking.new(
          start_at: start_at,
          end_at: end_at,
          car_id: car_id
        )

        unless booking.valid?
          @booking.errors.each do |key, message|
            errors.add(key, message)
          end
        end
      end

      def drivers_exist?
        nil_user_ids = driver_ids.reject do |driver_id|
          User.exists?(id: driver_id)
        end

        if nil_user_ids.empty?
          @user_bookings = driver_ids.map do |driver_id|
            UserBooking.new(user_id: driver_id)
          end
        else
          errors.add(:fellow_ids, "User #{nil_user_ids.join(',')} does not exist.")
        end
      end
  end
end