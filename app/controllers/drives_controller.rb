class DrivesController < ApplicationController
  def new
    start_meter = Drive.last_meter(params[:car_id])
    drive = Drive.new(car_id: params[:car_id], user_id: current_user.id)
    @form = DriveForm::Create.new(drive, start_meter: start_meter)
    @bookings_in_effect = Car.find(params[:car_id]).bookings.in_effect
  end

  def create
    drive = Drive.new(car_id: params[:car_id], user_id: current_user.id)
    @form = DriveForm::Create.new(drive, drive_start_params)

    if @form.valid?
      @form.drive.save!
      redirect_to :root
    else
      @bookings_in_effect = Car.find(params[:car_id]).bookings.in_effect
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
            .permit(:start_meter, :using_hours).to_h
    end

    def drive_end_params
      params.require(:drive_form_update)
            .permit(:end_meter).to_h
    end
end
