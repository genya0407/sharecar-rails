class BookingsController < ApplicationController
  before_action :set_bookings_in_effect, only: [:new, :create]

  def new
    @form = BookingForm::Create.initial
  end

  def create
    @form = BookingForm::Create.new(booking_form_params)

    if @form.valid?
      booking = Booking.new(
        @form.attrs.merge(
          user_id: current_user.id,
          car_id: params[:car_id]
        )
      )

      if booking.save
        redirect_to action: :new
      else
        booking.errors.each { |k, v| @form.errors.add(k, v) }

        render :new
      end
    else
      render :new
    end
  end

  def destroy
    booking = current_user.bookings.find_by(id: params[:id])
    if booking.present?
      booking.destroy!
      redirect_to new_car_booking_path(car_id: booking.car.id)
    else
      @form = BookingForm::Create.initial
      render :new, status: :unprocessable_entity
    end
  end

  private
    def booking_form_params
      params.require(:booking_form_create)
            .permit(:start_at_date, :start_at_hour, :end_at_date, :end_at_hour).to_h
    end

    def set_bookings_in_effect
      @bookings_in_effect = Car.find(params[:car_id]).bookings.in_effect
    end
end
