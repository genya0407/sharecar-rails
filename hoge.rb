Car.all.each do |car|
  Consumption.create(
    car: car,
    start_at: Time.zone.local(2017, 10, 1, 0, 0, 0),
    end_at: Time.zone.local(2017, 3, 31, 23, 59, 59),
    price: 0
  )
end
