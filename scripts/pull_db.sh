LOCAL_DATABASE_URL=postgres://sharecar:sharecar@127.0.0.1:5432/sharecar
#PGSSLMODE=disable heroku pg:pull DATABASE_URL $LOCAL_DATABASE_URL --app kumacar
heroku pg:backups --app kumacar | grep DATABASE | head -n1 | awk '{ print $1 }' | xargs -I{} heroku pg:backups:download {} --app kumacar
pg_restore --no-privileges --no-owner -d $LOCAL_DATABASE_URL latest.dump
rm latest.dump
