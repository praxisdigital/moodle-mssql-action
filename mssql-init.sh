SA_PASSWORD=${INPUT_MSSQL_PASSWORD}
MSSQL_USER=${INPUT_MSSQL_USER}
MSSQL_PASSWORD=${INPUT_MSSQL_PASSWORD}
MSSQL_DATABASE=${INPUT_MSSQL_DATABASE}

if [ -z "$SA_PASSWORD" ]; then
    echo "SA password not set, exiting"
    exit 1
fi
if [ -z "$MSSQL_USER" ]; then
    echo "Database user not set, exiting"
    exit 1
fi
if [ -z "$MSSQL_PASSWORD" ]; then
    echo "Database password not set, exiting"
    exit 1
fi
if [ -z "$MSSQL_DATABASE" ]; then
    echo "Database name not set, exiting"
    exit 1
fi

sqlcmd="/opt/mssql-tools18/bin/sqlcmd"

isreadycmd () {
    isReady=`${sqlcmd} -C -l 5 -h-1 -V1 -W -U SA -P ${SA_PASSWORD} -Q "SET NOCOUNT ON; SELECT 1"`

    if [[ $isReady != "1" ]]; then
        return 1
    fi

    return 0
}

printf "...Create root username: ${MSSQL_USER}\n"
printf "...Create root password: ${MSSQL_PASSWORD}\n"

# Wait for it to be available
echo "...Waiting for MS SQL to be available ⏳"

isReady=`isreadycmd && echo 1`
while [[ $isReady != "1" ]]; do
    isReady=`isreadycmd && echo 1`
    sleep 1
done

printf "...MS SQL is available!\n"

userExists=`${sqlcmd} -C -h-1 -V1 -W -U SA -P ${SA_PASSWORD} -Q "SET NOCOUNT ON; SELECT 1 FROM sys.server_principals WHERE name = '${MSSQL_USER}'"`
if [[ $userExists != "1" ]]; then
    $sqlcmd -C -U SA -P "${SA_PASSWORD}" -Q "USE master; CREATE LOGIN ${MSSQL_USER} WITH PASSWORD = '${MSSQL_PASSWORD}', CHECK_POLICY = OFF"
    $sqlcmd -C -U SA -P "${SA_PASSWORD}" -Q "USE master; EXEC master..sp_addsrvrolemember @loginame = '${MSSQL_USER}', @rolename = 'sysadmin'"
fi

dbExists=`${sqlcmd} -C -h-1 -V1 -W -U SA -P ${SA_PASSWORD} -Q "SET NOCOUNT ON; SELECT 1 FROM sys.databases WHERE name = '${MSSQL_DATABASE}'"`
if [[ $dbExists != "1" ]]; then
    $sqlcmd -C -U SA -P "${SA_PASSWORD}" -Q "CREATE DATABASE ${MSSQL_DATABASE}"
fi
