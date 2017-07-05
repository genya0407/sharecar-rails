class Admin::CarsController < ApplicationController
  before_action :should_be_admin

  def index
    @cars = Car.all
  end
end
