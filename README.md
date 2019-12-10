

````
docker run --name foobar-db -e DB_NAME=foobar -e DB_USER=foobar -e DB_PASS=foobar -e PG_AUTOVACUUM=1 --rm -it lcgc/postgresql:9.6

docker create --name foobar-db-data -v /var/lib/postgresql busybox:1 echo test db data
docker run --name foobar-db -e DB_NAME=foobar -e DB_USER=foobar -e DB_PASS=foobar --volumes-from=foobar-db-data -d lcgc/postgresql:9.6

````
