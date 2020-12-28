require 'csv'

task analyze: :environment do
  csv_string = CSV.generate do |csv|
    csv << %w[username hours km ratio]
    Drive.only_checked.group_by { |drive| drive.user_id }.map do |user_id, drives|
      complete_drives = drives.select { |drive| !drive.end_at.nil? && !drive.end_meter.nil? }
      total_seconds = complete_drives.map { |drive| drive.end_at - drive.start_at }.sum
      total_hours = total_seconds / 3600
      total_kms = complete_drives.map { |drive| drive.end_meter - drive.start_meter }.sum
      ratio = total_kms / total_hours
      [user_id, total_hours, total_kms, ratio]
    end.sort_by { |_, _, _, ratio| ratio }.each do |user_id, total_hours, total_kms, ratio|
      csv << [User.find(user_id).name, total_hours.round, total_kms.round, ratio.round(3)]
    end
  end
  puts csv_string
end
