# sharecar-rails

## Setup

Please install docker first.

```shell-session
$ ./launch_db.sh
$ bundle install --path vendor/bin
$ bundle exec rake db:setup
$ bundle exec rails s
```

Go to [http://localhost:3000](http://localhost:3000).

This webapp is for smartphone's web browser.

## Restore from heroku

```shell-session
pg_restore e538a47b-9b70-4e8d-9844-2d6706bd3330 --clean --no-acl --no-owner -d sharecar -h 127.0.0.1 -U sharecar
```

## Start Aggregation

```ruby
Car.all.each do |car|
  Consumption.create(
    car: car,
    start_at: Time.zone.local(2017, 7, 1, 0, 0, 0),
    end_at: Time.zone.local(2017, 9, 30, 23, 59, 59),
    price: 0
  )
end
```