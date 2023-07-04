

build
---

```bash
make main && make main-tag
make v13 && make v13-tag
make v14 && make v14-tag
make v15 && make v15-tag

```

example
---

````bash


docker run --name foobar-db -e DB_NAME=foobar -e DB_USER=foobar -e DB_PASS=foobar -e PG_AUTOVACUUM=1 -e PG_EXTENSIONS='pg_trgm postgis' --rm -it fhyx/postgresql:12-gis

docker create --name foobar-db-data -v /var/lib/postgresql busybox:1 echo test db data
docker run --name foobar-db -e DB_NAME=foobar -e DB_USER=foobar -e DB_PASS=foobar --volumes-from=foobar-db-data -d fhyx/postgresql:12-gis

````
