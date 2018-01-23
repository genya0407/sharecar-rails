task check_drive_lack: :environment do
  cars_with_lack = Car.all.select do |car|
    car.drives.only_checked.lack_exist?
  end

  unless cars_with_lack.empty?
    NotifyLackMailer.lack_exist_email(cars_with_lack).deliver_now
  end
end
