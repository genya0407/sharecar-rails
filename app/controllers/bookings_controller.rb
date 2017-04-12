class BookingsController < ApplicationController
  def new
    @form = CreateBookingForm.new(driver_ids: [current_user.id])
  end

  def create
    @form = CreateBookingForm.new(booking_params.to_h)

    if @form.save
      redirect_to :root
    else
      render :new
    end
  end

  private
    def booking_params
      params.require(:create_booking_form).permit(:start_at, :end_at, :car_id, driver_ids: [])
    end
end
