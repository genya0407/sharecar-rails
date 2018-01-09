LOCAL_DATABASE_URL=postgres://sharecar:sharecar@127.0.0.1:5432/sharecar
PGSSLMODE=disable heroku pg:pull DATABASE_URL $LOCAL_DATABASE_URL --app kumacar
