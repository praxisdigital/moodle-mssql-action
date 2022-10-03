#!/bin/sh

if [ -z "$INPUT_MSSQL_ROOT_PASSWORD" ]; then
    INPUT_MSSQL_ROOT_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
fi

if [ -z "$INPUT_MSSQL_DATABASE" ]; then
    INPUT_MSSQL_DATABASE=test
fi

if [ -z "$INPUT_CONTAINER_PORT" ]; then
    INPUT_CONTAINER_PORT=1433
fi
if [ -z "$INPUT_HOST_PORT" ]; then
    INPUT_HOST_PORT=1433
fi

if [ -z "$INPUT_MSSQL_VERSION" ]; then
    INPUT_MSSQL_VERSION=2022-latest
fi

./initialize.sh & /opt/mssql/bin/sqlservr