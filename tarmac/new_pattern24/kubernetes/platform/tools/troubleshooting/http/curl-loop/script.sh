#!/bin/sh

# this script will execute an http request loop using curl and print the results to the console.

# determine if credentials are provided for the request
if [ -n "${USER}" ] && [ -n "${PASSWORD}" ];
then
    echo "Credentials will be used for the http requests"
fi

while true;
do

    sleep 1

    # if credentials are provided, use them for the request. otherwise, execute the request without credentials.
    if [ -n "${USER}" ] && [ -n "${PASSWORD}" ];
    then
        result=$(curl $HTTP_ENDPOINT --max-time $MAX_TIMEOUT --location --output /dev/null --write-out '%{http_code}\n' --silent -u "${USER}:${PASSWORD}") 
    else
        result=$(curl $HTTP_ENDPOINT --max-time $MAX_TIMEOUT --location --output /dev/null --write-out '%{http_code}\n' --silent)
    fi
    
    # if the http response code is 200-299, then the request was successful
    if [ $result -ge 200 ] && [ $result -le 299 ]; then
        echo "Successful request for $HTTP_ENDPOINT - http_code:" $result
    else
        echo "Failed request for $HTTP_ENDPOINT - http_code:" $result
    fi

done
