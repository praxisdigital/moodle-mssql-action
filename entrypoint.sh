#!/bin/sh

if [ -z "$INPUT_MSSQL_ROOT_PASSWORD" ]; then
    INPUT_MSSQL_ROOT_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
fi

if [ -z "$INPUT_MSSQL_DATABASE" ]; then
    INPUT_MSSQL_DATABASE=test
fi

sh -c "docker run --name mssql -p $INPUT_HOST_PORT:$INPUT_CONTAINER_PORT -d mcr.microsoft.com/mssql/server:$INPUT_MSSQL_VERSION -e MSSQL_SA_PASSWORD=$INPUT_MSSQL_ROOT_PASSWORD -e ACCEPT_EULA=y"
sh -c "docker exec mssql /opt/mssql-tools/bin/sqlcmd -U sa -P $INPUT_MSSQL_ROOT_PASSWORD -Q 'CREATE DATABASE $INPUT_MSSQL_DATABASE'"