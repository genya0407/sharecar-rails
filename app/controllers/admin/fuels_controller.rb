class Admin::FuelsController < ApplicationController
  before_action :should_be_admin

  def index
    @car = Car.find(params[:car_id])
    @checked_fuels = @car.fuels.where(checked: true).order('created_at DESC')
    @not_checked_fuels = @car.fuels.where(checked: false).order(:created_at)
  end

  def new
    car = Car.find(params[:car_id])
    @fuel = Fuel.new(car: car)
  end

  def create
    fuel = Fuel.new(create_params)
    fuel.save!

    redirect_to action: :index
  end

  def destroy
    Fuel.find(params[:id]).destroy!

    redirect_to action: :index
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

  private

  def create_params
    params.require(:fuel)
          .permit(:user_id, :car_id, :amount, :created_at)
  end
end
