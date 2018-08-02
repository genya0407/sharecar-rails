class Admin::CarsController < ApplicationController
  before_action :should_be_admin

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(create_params)

    if @car.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def index
    @cars = Car.all
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    @car.update(update_params)

    redirect_to action: :index
  end

  private
  def update_params
    params
      .require(:car)
      .permit(:status, :note)
  end

  def create_params
    params
      .require(:car)
      .permit(:name)
  end
end
