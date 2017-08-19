require 'rbplotly'

class Metrics::DrivesController < ApplicationController
  before_action :should_be_admin

  def index
    traces = Car.all.map do |car|
      data = car.drives.group(:user).sum('end_meter - start_meter').map { |user, km| [user.name, km] }.to_h
      {
        x: data.keys,
        y: data.values,
        name: car.name,
        type: 'bar'
      }
    end

    @plot = Plotly::Plot.new(data: traces, layout: { barmode: :group })
    render layout: false
  end
end
