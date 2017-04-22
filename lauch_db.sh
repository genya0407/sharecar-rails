docker run --rm -v /var/lib/postgresql/data -e POSTGRES_USER=sharecar -e POSTGRES_PASSWORD=sharecar -p 5432:5432 --name sharecar-rails-postgres -d postgres:9.6-alpine
