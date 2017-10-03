task cc: :environment do
  Consumption.unfinished.all.each do |consumption|
    start_at = consumption.start_at
    end_at = consumption.end_at
    target_fuels = consumption.car.fuels.in(start_at, end_at)
    target_drives = consumption.car.drives.in(start_at, end_at)

    cons_value = Consumption.calc_consumption(target_fuels, target_drives)
    consumption.update(price: cons_value)
  end
end