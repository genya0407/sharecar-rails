require File.expand_path(File.dirname(__FILE__) + '/../config/environment')

drives = Drive.where('start_at > ?', Time.zone.local(2017, 10, 1)).eager_load(:user)
user_and_distance = drives.group_by(&:user).map do |user, drives|
  [
    user,
    drives.map(&:distance).select { |d| !d.nil? }.sum,
    drives.count
  ]
end.sort_by { |_, d, _| d }

class String
  def mb_ljust(width, padding = ' ')
    output_width = each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.reduce(0, &:+)
    padding_size = [0, width - output_width].max
    self + padding * padding_size
  end
end

user_and_distance.each do |user, distance, count|
  puts "#{user.name.mb_ljust(20)}:#{distance.to_s.ljust(5)}km,   #{count.to_s.ljust(4)}回"
end
