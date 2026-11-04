FROM alpine:3.23

RUN apk update && apk add --no-cache postgresql postgresql-contrib su-exec

RUN mkdir -p /var/lib/postgresql/data /run/postgresql && \
    chown -R postgres:postgres /var/lib/postgresql /run/postgresql

COPY ./tools/postgres.sh /usr/local/bin/postgres.sh

RUN chmod +x /usr/local/bin/postgres.sh

EXPOSE 5432

ENTRYPOINT ["postgres.sh"]

