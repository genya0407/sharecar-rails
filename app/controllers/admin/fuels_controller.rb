class Admin::FuelsController < ApplicationController
  before_action :should_be_admin

  def index
    @car = Car.find(params[:car_id])
    @checked_fuels = @car.fuels.where(checked: true).order('created_at DESC')
    @not_checked_fuels = @car.fuels.where(checked: false).order(:created_at)
  end

  def update
    fuel = Fuel.find(params[:id])
    if fuel.checked?
      fuel.update(checked: false)
    else
      fuel.update(checked: true)
    end

    redirect_to action: :index
  end
end
