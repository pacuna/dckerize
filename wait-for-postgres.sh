#!/bin/bash

set -e

host="$1"
shift
cmd="$@"

until PGPASSWORD=mysecretpassword psql -h "$host" -U "myapp" -d "myapp_development" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd

