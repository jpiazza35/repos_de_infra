#!/usr/bin/env bash

if [ ! -f "`dirname $0`/../database_schema_initialized" ]; then
    echo "Recreating database schema..."
    mysql -u root -proot -h tarmac_flask_db --execute "DROP DATABASE IF EXISTS tarmac_flask_db"
    mysql -u root -proot -h tarmac_flask_db --execute "CREATE DATABASE IF NOT EXISTS tarmac_flask_db"
    flask initdb
    touch `dirname $0`/../database_schema_initialized
fi