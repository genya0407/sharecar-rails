task cc: :environment do # calculate consumption
  check_start_at = Time.zone.local(2017, 7, 1) # ちゃんと使い始めた日

  car_and_consumptions = Car.all.map do |car|
    total_gas_yen = car.fuels.where('created_at >= ?', check_start_at).sum(:amount)
    total_meter = car.drives.where('created_at >= ?', check_start_at)
                            .where.not(end_meter: nil)
                            .sum('end_meter - start_meter')
    consumption = total_gas_yen.to_f / total_meter.to_f
    [car, consumption]
  end

  car_and_consumptions.each do |car, consumption|
    puts "#{car.name}：#{consumption.round(1)} (yen/km)"
  end  
end