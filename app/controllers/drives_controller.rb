class DrivesController < ApplicationController
  before_action :set_bookings_in_effect, only: [:new, :create]

  def new
    @form = DriveForm::Create.new(
      start_meter: Drive.last_meter(params[:car_id]),
      end_at_date: Time.zone.now.to_date,
      end_at_hour: Time.zone.now.hour,
      car_id: params[:car_id],
      user_id: current_user.id
    )
  end

  def create
    @form = DriveForm::Create.new(
      drive_start_params.merge(
        car_id: params[:car_id],
        user_id: current_user.id
      )
    )

    if @form.valid?
      @form.save!

      redirect_to :root
    else
      render :new
    end
  end

  def edit
    drive = current_user.drives.find(params[:id])
    @form = DriveForm::Update.new(drive)
  end

  def update
    drive = current_user.drives.find(params[:id])
    @form = DriveForm::Update.new(drive, drive_end_params)

    if @form.valid?
      drive.update!(end_meter: @form.end_meter)
      redirect_to :root
    else
      render :edit
    end
  end

  private
    def drive_start_params
      params.require(:drive_form_create)
            .permit(:start_meter, :end_at_date, :end_at_hour).to_h
    end

    def drive_end_params
      params.require(:drive_form_update)
            .permit(:end_meter).to_h
    end

    def set_bookings_in_effect
      @bookings_in_effect = Car.find(params[:car_id]).bookings.in_effect
    end
end
