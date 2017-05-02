class FuelsController < ApplicationController
  def new
    @fuels = Fuel.where(car_id: params[:car_id])
    @fuel = Fuel.new
  end

  def create
    @fuel = Fuel.new(fuel_params)
    if @fuel.save
      redirect_to action: :new
    else
      render :new
    end
  end

  private
  def fuel_params
    params.require(:fuel).permit(:amount).to_h
          .merge(car_id: params[:car_id], user: current_user)
  end
end
