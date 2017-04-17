class HomeController < ApplicationController
  def index
    @cars = Car.joins(:drives).all
  end
end
