module HomeHelper
  def simple_datetime(datetime)
    if Time.zone.now.to_date == datetime.to_date
      datetime.in_time_zone.to_s :time_only
    else
      datetime.in_time_zone.to_s :ja
    end
  end 
end