require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'csv'

drives = Drive.where('start_at > ?', Time.zone.local(2017, 10, 1)).eager_load(:user)
csv_string = CSV.generate do |csv|
  csv << ['car', 'name', 'distance', 'time_distance']
  drives.each do |drive|
    csv << [drive.car.name, drive.user.name, drive.distance || 0, drive.end_at - drive.start_at]
  end
end
puts csv_string
