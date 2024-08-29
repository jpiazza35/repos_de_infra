#!/usr/bin/env bash

#move to app folder
cd /app/

source /app/script/env.sh

#install python dependencies
pip3 install -r requirements.txt

#wait for mysql to be initialized
./script/wait-for-mysql.sh

#recreate database schema
./script/database_recreate_schema.sh;

#update database schema
#script/database_run_migrations_local.sh;

#import database
#./script/database_load_fixture.sh

#run the server
#./script/server_run.sh

#show log
#./script/server_log.sh

#run app
flask run --host=0.0.0.0 --port=8000