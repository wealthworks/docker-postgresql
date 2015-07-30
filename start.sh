#!/bin/bash
set -e

if [ "$1" = 'postgres' ]; then
	chown -R postgres "$PGDATA"

	# chmod g+s /var/run/postgresql
	# chown -R postgres:postgres /var/run/postgresql

	if [ -z "$(ls -A "$PGDATA")" ]; then
		# sudo -u postgres initdb
		sudo -u postgres -H "initdb" -D "${PGDATA}" -U postgres $PG_INITDB_OPTS

		sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

		# check password first so we can ouptut the warning before postgres
		# messes it up
		if [ "$DB_PASS" ]; then
			pass="PASSWORD '$DB_PASS'"
			authMethod=md5
		else
			# The - option suppresses leading tabs but *not* spaces. :)
			cat >&2 <<-'EOWARN'
				****************************************************
				WARNING: No password has been set for the database.
				         This will allow anyone with access to the
				         Postgres port to access your database. In
				         Docker's default configuration, this is
				         effectively any other container on the same
				         system.

				         Use "-e DB_PASS=password" to set
				         it in "docker run".
				****************************************************
			EOWARN

			pass=
			authMethod=trust
		fi

		: ${DB_USER:=postgres}
		: ${DB_NAME:=$DB_USER}
		: ${DB_SCHEMA:=$DB_USER}

		if [ -n "$DB_USER" -a "$DB_USER" != 'postgres' ]; then
			echo "Creating user \"${DB_USER}\"..."
			echo "CREATE ROLE ${DB_USER} with LOGIN CREATEDB $pass ;" |
				sudo -u postgres -H postgres --single -D "$PGDATA"  >/dev/null

		fi

		if [ -n "$DB_NAME" -a "$DB_NAME" != 'postgres' ]; then
			echo "Creating database \"${DB_NAME}\"..."
			echo "CREATE DATABASE $DB_NAME WITH OWNER = ${DB_USER} ENCODING = 'UTF8' ;" |
				sudo -u postgres -H postgres --single -D "$PGDATA"  >/dev/null

			echo "Granting access to database \"${DB_NAME}\" for user \"${DB_USER}\"..."
			echo "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME to ${DB_USER};" |
				sudo -u postgres -H postgres --single -D "$PGDATA"  >/dev/null

			if [ -n "$DB_SCHEMA" -a "$DB_SCHEMA" != 'public' ]; then
				echo "CREATE SCHEMA ${DB_SCHEMA} for DB ${DB_NAME}"
				echo "CREATE SCHEMA ${DB_SCHEMA} AUTHORIZATION ${DB_USER};" |
					sudo -u postgres -H postgres --single -D "$PGDATA" ${DB_NAME} >/dev/null
			fi
		fi


		{ echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf

		if [ -d /docker-entrypoint-initdb.d ]; then
			for f in /docker-entrypoint-initdb.d/*.sh; do
				[ -f "$f" ] && . "$f"
			done
		fi
	fi

	echo "Starting PostgreSQL server..."
	sudo -u postgres -H postgres -D "$PGDATA"
fi

exec "$@"
