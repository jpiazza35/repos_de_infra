#!/bin/sh

# this script will execute a mysql connection loop and print the results to the console.

while true;
do
    
    sleep 1

    # execute the mysql connection
    result=$(mysql --host="$MYSQL_HOST" --port="$MYSQL_PORT" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --database=$MYSQL_DATABASE --execute="$MYSQL_QUERY")

    # if the exit code is 0
    if [ $? -eq 0 ]; then
        echo "MYSQL connect succeeded for $MYSQL_HOST"
    fi

done
