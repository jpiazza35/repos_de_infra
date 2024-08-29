#!/bin/bash
while ! mysqladmin ping -h"tarmac_flask_db" --silent; do
	echo "MySQL instance isn't ready, waiting..."
    sleep 1
done
echo "Connected to MySQL database"
