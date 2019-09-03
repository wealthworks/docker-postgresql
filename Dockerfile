FROM alpine:3.6
MAINTAINER Eagle Liut <eagle@dantin.me>

ENV PG_MAJOR="9.6" \
    PG_HOME="/var/lib/postgresql" \
    LANG="en_US.utf8" \
    PG_INITDB_OPTS="--encoding=UTF8 --locale=en_US.UTF-8 --auth=trust"

ENV PGDATA $PG_HOME/$PG_MAJOR/data

RUN apk add --update bash gzip su-exec postgresql postgresql-contrib postgresql-client \
  && rm -rf /var/cache/apk/*

VOLUME ["$PG_HOME", "/docker-entrypoint-initdb.d"]

ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 5432

CMD ["/start.sh", "postgres"]
