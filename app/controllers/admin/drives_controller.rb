class Admin::DrivesController < ApplicationController
  before_action :should_be_admin

  def index
    drives = Drive.where(car_id: params[:car_id]).order(:start_meter)
    @card_elements = drives.zip(drives.drop(1)).map do |current_drive, next_drive|
      if next_drive.nil? || current_drive.end_at.nil? || current_drive.end_meter == next_drive.start_meter
        current_drive
      else
        form = DriveForm::CreateAdmin.new(
          car_id: params[:car_id],
          start_meter: current_drive.end_meter,
          end_meter: next_drive.start_meter
        )

        [current_drive, form]
      end
    end.flatten
  end

  def new
  end

  def create
  end

  def update
  end
end
