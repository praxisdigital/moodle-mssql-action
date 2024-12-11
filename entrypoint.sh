#!/bin/sh

sa_pass=${INPUT_MSSQL_ROOT_PASSWORD}
db_user=${INPUT_MSSQL_USER}
db_password=${INPUT_MSSQL_PASSWORD}
db_name=${INPUT_MSSQL_DATABASE}
version=${INPUT_VERSION:-2022-latest}
container_port=${INPUT_CONTAINER_PORT:-1433}
host_port=${INPUT_HOST_PORT:-1433}

# Validate inputs
if [ -z "${version}" ]; then
    echo "Version not set (), exiting"
    exit 1
fi

if [ -z "${sa_pass}" ]; then
    echo "SA password not set, exiting"
    exit 1
fi

if [ -z "${db_user}" ]; then
    echo "Database user not set, exiting"
    exit 1
fi

if [ -z "${db_password}" ]; then
    echo "Database password not set, exiting"
    exit 1
fi

if [ -z "${db_name}" ]; then
    echo "Database name not set, exiting"
    exit 1
fi

# Build image
image_name="moxis/moodle-mssql-action"
docker build . \
    -t $image_name \
    -f mssql.Dockerfile \
    --build-arg VERSION=${version}

# Generate a random container name
id=$(tr -dc a-z0-9 </dev/urandom | head -c 10)
container_name="mssql-server-$id"

# Run the container
command="docker run -d --rm\
    --name $container_name \
    -p ${host_port}:${container_port} \
    -e ACCEPT_EULA='Y' \
    -e MSSQL_SA_PASSWORD=${sa_pass} \
    -e INPUT_MSSQL_ROOT_PASSWORD=${sa_pass} \
    -e INPUT_MSSQL_PASSWORD=${db_password} \
    -e INPUT_MSSQL_USER=${db_user} \
    -e INPUT_MSSQL_DATABASE=${db_name} \
    $image_name:latest"

sh -c "$command"
