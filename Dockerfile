FROM alpine:3.2
MAINTAINER Eagle Liut <eagle@dantin.me>

RUN apk add --update bash sudo postgresql postgresql-contrib postgresql-client \
  && rm -rf /var/cache/apk/*

ENV LANG en_US.utf8
ENV PG_HOME "/var/lib/postgresql"
ENV PG_MAJOR 9.4
ENV PGDATA $PG_HOME/$PG_MAJOR/data
ENV PG_INITDB_OPTS "--encoding=UTF8 --locale=en_US.UTF-8 --auth=trust"

RUN mkdir /docker-entrypoint-initdb.d

RUN mkdir -p "$PGDATA" && chown -R postgres:postgres $PG_HOME

VOLUME /var/lib/postgresql

ADD start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 5432

CMD ["/start.sh","postgres"]
