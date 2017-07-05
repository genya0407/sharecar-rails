task check_drive_lack: :environment do
  check_start_at = Time.zone.local(2017, 7, 1)

  cars_with_lack = Car.all.select do |car|
    car.drives.where('created_at >= ?', check_start_at).lack_exist?
  end

  User.admin.each do |user|
    NotifyLackMailer.lack_exist_email(user, cars_with_lack).deliver_now
  end
end