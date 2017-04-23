class BookingsController < ApplicationController
  def new
    @booking = Booking.new(start_at: Time.zone.now, end_at: Time.zone.now)
  end

  def create
    @booking = Booking.new(booking_params)

    if @booking.save
      redirect_to :root
    else
      render :new
    end
  end

  private
    def booking_params
      params.require(:booking)
            .permit(:start_at, :end_at).to_h
            .merge(user_id: current_user.id, car_id: params[:car_id])
    end
end
