#!/bin/sh

# Set default values

# SA password
INPUT_MSSQL_ROOT_PASSWORD=${INPUT_MSSQL_ROOT_PASSWORD:-123qweASD}
# Database user
INPUT_MSSQL_USER=${INPUT_MSSQL_USER:-test}
# Database password
INPUT_MSSQL_PASSWORD=${INPUT_MSSQL_PASSWORD:-test}
# Database name
INPUT_MSSQL_DATABASE=${INPUT_MSSQL_DATABASE:-test}
# Container port
INPUT_CONTAINER_PORT=${INPUT_CONTAINER_PORT:-1433}
# Host port
INPUT_HOST_PORT=${INPUT_HOST_PORT:-1433}

/initialize.sh & /opt/mssql/bin/sqlservr &
