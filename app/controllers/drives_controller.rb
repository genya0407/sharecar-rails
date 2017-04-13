class DrivesController < ApplicationController
  def new
    @form = DriveForm::Create.new(driver_ids: [current_user.id], car_id: params[:car_id])
  end

  def create
    @form = DriveForm::Create.new(drive_params.to_h)

    if @form.save
      redirect_to :root
    else
      render :new
    end
  end

  private
    def drive_params
      params.require(:drive_form_create)
            .permit(:car_id, :start_at, :end_at, :start_meter, :end_meter, driver_ids: [])
    end
end
