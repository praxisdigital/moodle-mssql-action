#!/bin/bash

_version=${INPUT_VERSION:-2019}
_sa_pass=${INPUT_MSSQL_ROOT_PASSWORD}
_db_user=${INPUT_MSSQL_USER}
_db_password=${INPUT_MSSQL_PASSWORD}
_db_name=${INPUT_MSSQL_DATABASE}
_container_port=${INPUT_CONTAINER_PORT:-1433}
_host_port=${INPUT_HOST_PORT:-1433}

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

docker run \
    -e 'ACCEPT_EULA=Y' \
    -e 'SA_PASSWORD='"${_sa_pass}" \
    -p ${_host_port}:${_container_port} \
    -d mcr.microsoft.com/mssql/server:2019-latest
    --entrypoint ./mssql-entrypoint.sh
    