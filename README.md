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