docker kill $(docker ps | grep -v CONTAINER | awk '{ print $1 }')
./scripts/launch_db.sh
