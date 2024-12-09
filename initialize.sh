sqlcmd=${INPUT_MSSQL_TOOLS:-"/opt/mssql-tools18/bin/sqlcmd"}

# Set default values
default_root_password="123qweASD"

# SA password
INPUT_MSSQL_ROOT_PASSWORD=${INPUT_MSSQL_ROOT_PASSWORD:-$default_root_password}
# Database user
INPUT_MSSQL_USER=${INPUT_MSSQL_USER:-test}
# Database password
INPUT_MSSQL_PASSWORD=${INPUT_MSSQL_PASSWORD:-test}
# Database name
INPUT_MSSQL_DATABASE=${INPUT_MSSQL_DATABASE:-test}


# Set default values for local variables
root_password=${INPUT_MSSQL_ROOT_PASSWORD}
db_username=${INPUT_MSSQL_USER}
db_password=${INPUT_MSSQL_PASSWORD}
db_name=${INPUT_MSSQL_DATABASE}

# Check if SQL tools are available
if [[ ! -f $sqlcmd ]]; then
    printf "Cannot find sqlcmd in $sqlcmd\n"
    exit 1
fi

isreadycmd () {
    isReady=`${sqlcmd} -C -l 5 -h-1 -V1 -W -U SA -P ${root_password} -Q "SET NOCOUNT ON; SELECT 1"`

    if [[ $isReady != "1" ]]; then
        return 1
    fi

    return 0
}

printf "Setup Microsoft SQL server configuration\n"

# Wait for it to be available
echo "...Waiting for MS SQL to be available ⏳"

limit=60
isReady=`isreadycmd && echo 1`
while [[ $isReady != "1" ]]; do
    isReady=`isreadycmd && echo 1`
    sleep 1
    limit=$((limit-1))
    if [[ $limit -le 0 ]]; then
        printf "MS SQL is not available after 60 seconds.\n"
        printf "Terminating the setup...\n"
        exit 2
    fi
done

printf "...MS SQL is available!\n"

userExists=`${sqlcmd} -C -h-1 -V1 -W -U SA -P ${root_password} -Q "SET NOCOUNT ON; SELECT 1 FROM sys.server_principals WHERE name = '${db_username}'"`
if [[ $userExists != "1" ]]; then
    $sqlcmd -C -U SA -P "${root_password}" -Q "USE master; CREATE LOGIN ${db_username} WITH PASSWORD = '${db_password}', CHECK_POLICY = OFF"
    $sqlcmd -C -U SA -P "${root_password}" -Q "USE master; EXEC master..sp_addsrvrolemember @loginame = '${db_username}', @rolename = 'sysadmin'"
    printf "...User ${db_username} created\n"
else
    printf "...User ${db_username} already exists\n"
fi

dbExists=`${sqlcmd} -C -h-1 -V1 -W -U SA -P ${root_password} -Q "SET NOCOUNT ON; SELECT 1 FROM sys.databases WHERE name = '${db_name}'"`
if [[ $dbExists != "1" ]]; then
    $sqlcmd -C -U SA -P "${root_password}" -Q "CREATE DATABASE ${db_name}"
    printf "...Database ${db_name} created\n"
else
    printf "...Database ${db_name} already exists\n"
fi

printf "...Done\n"
