class LackingDrivesController < ApplicationController
  def new
    @form = LackingDriveForm::Create.new(new_params)
  end

  def create
    @form = LackingDriveForm::Create.new(create_params)

    if @form.valid?
      @form.save!

      redirect_to :root
    else
      render :new
    end
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
    params.require(:lacking_drive_form_create)
          .permit(:start_meter, :end_meter).to_h
          .merge(
            car_id: params[:car_id],
            user_id: current_user.id
          )
  end
end
