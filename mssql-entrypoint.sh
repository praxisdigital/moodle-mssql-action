#!/bin/sh

/mssql-init.sh &

exec "$@"