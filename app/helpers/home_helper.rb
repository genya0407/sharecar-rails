module HomeHelper
  def simple_datetime(datetime)
    return '???' if datetime.nil?

    if Time.zone.now.to_date == datetime.to_date
      '本日 ' + (datetime.in_time_zone.to_s :time_only)
    else
      datetime.in_time_zone.to_s :ja
    end
  end 
end