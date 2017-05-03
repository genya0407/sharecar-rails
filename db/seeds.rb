# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(
  name: 'Test User',
  email: 'example@example.com',
  password: 'password',
  password_confirmation: 'password'
)
user.save!
user.activate!

Car.create!((1..5).map { { name: Faker::Cat.name } })
car = Car.first

start_meter = 0
end_meter = rand(10..100)
start_at = Time.zone.now
end_at = start_at + rand(2..10).hours
drive_params = 100.times.map do
  params = {
    user: user,
    car: car,
    start_meter: start_meter,
    end_meter: end_meter,
    start_at: start_at,
    end_at: end_at
  }
  start_meter = end_meter
  end_meter = start_meter + rand(10..100)
  start_at = end_at + rand(5..20).hours
  end_at = start_at + rand(2..10).hours
  params
end
Drive.create(drive_params)
