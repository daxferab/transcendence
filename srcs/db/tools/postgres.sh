#!/bin/sh
# Exit immediately if a command exits with a non-zero status
set -e

# ==============================================================================
# 1. Environment Variable Guards
# ==============================================================================
# Fail early with a clear error message if any required variable is unset/empty
: "${DB_NAME:?Error: DB_NAME is not set in .env}"
: "${DB_USER:?Error: DB_USER is not set in .env}"
: "${DB_PASSWORD:?Error: DB_PASSWORD is not set in .env}"

# Standard PostgreSQL data directory inside the container
PGDATA="/var/lib/postgresql/data"

# ==============================================================================
# 2. Filesystem & Permissions Preparation
# ==============================================================================
# Create the directory for the PostgreSQL Unix domain socket (.s.PGSQL.5432)
mkdir -p /run/postgresql
chown -R postgres:postgres /run/postgresql
chmod 0775 /run/postgresql

# PostgreSQL strictly requires the data directory permissions to be 0700 (drwx------).
# If permissions are too open (e.g. 0755 or 0777), PostgreSQL refuses to start.
mkdir -p "$PGDATA"
chown -R postgres:postgres "$PGDATA"
chmod 0700 "$PGDATA"

# ==============================================================================
# 3. First-Run Cluster Initialization
# ==============================================================================
# We check if the 'base' folder exists. If it doesn't, this is a fresh container
# mount and we need to initialize the database cluster and create the user/tables.
if [ ! -d "$PGDATA/base" ]; then
    echo "Initializing new PostgreSQL database cluster in $PGDATA..."

    # initdb initializes a new PostgreSQL database cluster (data files and system catalogs)
    # We run it as user 'postgres' via su-exec (PostgreSQL refuses to run as root)
    su-exec postgres initdb -D "$PGDATA"

    # Configure PostgreSQL to listen on all container network interfaces (0.0.0.0),
    # not just localhost, so other containers (like the NestJS backend) can reach it.
    echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

    # Configure Client Authentication (pg_hba.conf):
    # Allow connections from any IP on the Docker network using scram-sha-256 password auth.
    echo "host all all 0.0.0.0/0 scram-sha-256" >> "$PGDATA/pg_hba.conf"

    echo "Starting temporary PostgreSQL server for initial provisioning..."
    # Start PostgreSQL in the background and wait (-w) until it is fully ready.
    # We restrict listen_addresses to empty ('') during setup so outside requests are blocked.
    su-exec postgres pg_ctl -D "$PGDATA" -o "-c listen_addresses=''" -w start

    echo "Provisioning application user and database..."
    # Execute SQL commands to create the application user and database
    # -v ON_ERROR_STOP=1 ensures psql exits with an error if any SQL command fails
    su-exec postgres psql -v ON_ERROR_STOP=1 <<-EOSQL
        -- Create the application user with encrypted password
        CREATE USER "$DB_USER" WITH PASSWORD '$DB_PASSWORD';

        -- Create the database owned by our application user
        CREATE DATABASE "$DB_NAME" OWNER "$DB_USER";

        -- Grant full privileges on the database to our user
        GRANT ALL PRIVILEGES ON DATABASE "$DB_NAME" TO "$DB_USER";
EOSQL

    # In PostgreSQL 15+, public schema permissions require explicit grants
    su-exec postgres psql -v ON_ERROR_STOP=1 --dbname="$DB_NAME" <<-EOSQL
        GRANT ALL ON SCHEMA public TO "$DB_USER";
EOSQL

    echo "Initial provisioning complete. Stopping temporary PostgreSQL server..."
    # Cleanly stop the temporary server before handing over to PID 1
    # -m fast: fast shutdown (does not wait for clients to disconnect)
    # -w: wait until shutdown is complete
    su-exec postgres pg_ctl -D "$PGDATA" -m fast -w stop

    echo "PostgreSQL initialization finished successfully!"
else
    echo "PostgreSQL cluster already exists in $PGDATA. Skipping initialization."
fi

# ==============================================================================
# 4. Start PostgreSQL as PID 1
# ==============================================================================
# exec replaces the current shell with the postgres process.
# su-exec drops privileges from root to the 'postgres' user.
# Being PID 1 ensures PostgreSQL directly receives SIGTERM/SIGINT signals from Docker
# when running 'make down', preventing database corruption on shutdown.
echo "Starting PostgreSQL daemon as PID 1..."
exec su-exec postgres postgres -D "$PGDATA"
