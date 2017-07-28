class Admin::DrivesController < ApplicationController
  before_action :should_be_admin

  def index
    drives = Drive.where(car_id: params[:car_id]).order(:start_meter)
    @card_elements = drives.zip(drives.drop(1)).map do |current_drive, next_drive|
      if next_drive.nil? || current_drive.end_meter.nil? || current_drive.end_meter == next_drive.start_meter
        current_drive
      else
        form = DriveForm::Admin.new(
          car_id: params[:car_id],
          start_meter: current_drive.end_meter,
          end_meter: next_drive.start_meter
        )

        [current_drive, form]
      end
    end.flatten.reverse
  end

  def new
    @form = DriveForm::Admin.new(new_params)
  end

  def create
    @form = DriveForm::Admin.new(create_params)

    if @form.valid?
      @form.save!

      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @drive = Drive.find(params[:id])
    @form = DriveForm::Admin.from_drive(@drive)
  end

  def update
    @form = DriveForm::Admin.new(create_params)

    if @form.valid?
      drive = Car.find(params[:car_id]).drives.find(params[:id])
      drive.attributes = @form.attributes
      drive.save!

      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    Car.find(params[:car_id]).drives.find(params[:id]).destroy

    redirect_to action: :index
  end

  private
  def new_params
    {
      start_meter: params[:start_meter],
      end_meter: params[:end_meter],
      car_id: params[:car_id]
    }
  end

  def create_params
    params.require(:drive_form_admin)
          .permit(:user_id, :start_meter, :end_meter).to_h
          .merge(car_id: params[:car_id])
  end
end
