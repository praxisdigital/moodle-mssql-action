#!/bin/sh

sleep 30s

/opt/mssql-tools/bin/sqlcmd -U sa -P $INPUT_MSSQL_ROOT_PASSWORD -Q "CREATE DATABASE $INPUT_MSSQL_DATABASE;"