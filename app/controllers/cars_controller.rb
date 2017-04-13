class CarsController < ApplicationController
  def show
    @car = Car.find(params[:id]).join(:user_drives, :drives)
  end
end
