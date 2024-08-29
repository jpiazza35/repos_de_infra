#!/bin/sh

# this script will execute a DNS lookup loop and print the results to the console.

while true;
do
    
    sleep 1

    # execute a DNS lookup
    result=$(dig +short $DNS_LOOKUP_DOMAIN)


    # if the result has a value, it is valid
    if [ ! -z "$result" ];
    then
        echo "DNS lookup successful for $DNS_LOOKUP_DOMAIN: "$result
    fi

    # if the result is empty, it is not valid
    if [ -z "$result" ];
    then
        echo "DNS lookup FAILED for $DNS_LOOKUP_DOMAIN"
    fi

done
