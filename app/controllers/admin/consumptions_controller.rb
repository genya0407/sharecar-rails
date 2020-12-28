class Admin::ConsumptionsController < ApplicationController
  before_action :should_be_admin

  def index
    @consumptions = Consumption.all
  end

  def recalculate
    Consumption.transaction do
      Consumption.where(id: params[:ids]).each(&:recalculate)
    end

    redirect_to action: :index
  rescue StandardError
    flash[:recalculate_error] = true

    redirect_to action: :index
  end

  def new; end

  def create
    start_at = Time.zone.parse(params[:start_date])
    end_at = Time.zone.parse(params[:end_date]).change(hour: 23, min: 59, sec: 59)

    Consumption.transaction do
      Car.all.select do |car|
        car.fuels.in(start_at, end_at).exists?
      end.each do |car|
        Consumption.create(
          car: car,
          start_at: start_at,
          end_at: end_at,
          price: 0
        )
      end
    end

    redirect_to action: :index
  end

  def destroy_multiple
    Consumption.where(id: params[:ids]).destroy_all

    redirect_to action: :index
  end
end
