#!/bin/sh

_sa_pass=${INPUT_MSSQL_ROOT_PASSWORD}
_db_user=${INPUT_MSSQL_USER}
_db_password=${INPUT_MSSQL_PASSWORD}
_db_name=${INPUT_MSSQL_DATABASE}
_version=${INPUT_VERSION:-2022-latest}
_container_port=${INPUT_CONTAINER_PORT:-1433}
_host_port=${INPUT_HOST_PORT:-1433}

# Validate inputs
if [ -z "${_version}" ]; then
    echo "Version not set (), exiting"
    exit 1
fi

if [ -z "${_sa_pass}" ]; then
    echo "SA password not set, exiting"
    exit 1
fi

if [ -z "${_db_user}" ]; then
    echo "Database user not set, exiting"
    exit 1
fi

if [ -z "${_db_password}" ]; then
    echo "Database password not set, exiting"
    exit 1
fi

if [ -z "${_db_name}" ]; then
    echo "Database name not set, exiting"
    exit 1
fi

id=$(tr -dc a-z0-9 </dev/urandom | head -c 10)
container_name="mssql-server-$id"

# Run the container
command="docker run -d \
    --name $container_name \
    -e ACCEPT_EULA='Y' \
    -e SA_PASSWORD=${_sa_pass} \
    -e INPUT_MSSQL_ROOT_PASSWORD=${_sa_pass} \
    -e INPUT_MSSQL_PASSWORD=${_db_password} \
    -e INPUT_MSSQL_USER=${_db_user} \
    -e INPUT_MSSQL_DATABASE=${_db_name} \
    mcr.microsoft.com/mssql/server:${_version}"

sh -c "$command"
    
# # Wait for the container to be available
