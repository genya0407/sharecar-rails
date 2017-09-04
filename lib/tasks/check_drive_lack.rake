task check_drive_lack: :environment do
  cars_with_lack = Car.all.select do |car|
    car.drives.only_checked.lack_exist?
  end

  User.admin.each do |user|
    NotifyLackMailer.lack_exist_email(user, cars_with_lack).deliver_now
  end
end