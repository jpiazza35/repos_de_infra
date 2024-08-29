#!/usr/bin/env python3.8

# Script can be used for extraction of logs from certain CloudWatch log group based on some filter (queryString)

import boto3
import time

def lambda_handler(event, context):
    client = boto3.client('logs', region_name='eu-west-2')
    # Set log group name 
    account_id = context.invoked_function_arn.split(":")[4]
    if str(account_id).startswith("X"):
        log_group_name = "xxxxxxxxxxxx"
    else:
        log_group_name = "xxxxxxxxxxxx"
    # Set begin and end time of query period in epoch
    end_time = int(time.time())
    begin_time = end_time - 86400   # One day ago
    # Start the query
    response = client.start_query(
        logGroupName=log_group_name,
        startTime=begin_time,
        endTime=end_time,
        queryString='fields @message, @timestamp | filter @message like /PATTERN/ | sort @timestamp',
        limit=100
    )
    # Get query id
    query_id = response['queryId']
    # Get query details
    response_details = client.get_query_results(
        queryId=query_id
    )
    # Set start time of the timer and max query runtime in seconds
    start_time = time.time()
    seconds = 300
    # Wait for query status complete
    while True:
        current_time = time.time()
        elapsed_time = current_time - start_time
        # Check current status of the query
        response_details = client.get_query_results(
            queryId=query_id
        )
        # print(response_details['status'])
        if response_details['status'] == "Complete":
            response_details = client.get_query_results(
                queryId = query_id
            )
            break
        if elapsed_time > seconds:
            print("Finished iterating in: " + str(int(elapsed_time)) + " seconds")
            break
        time.sleep(5)
    # Print query results in the lambda cw logs 
    if len(response_details['results']) > 0:
        for finding in response_details['results']:
            find_message = ""
            for find_details in finding:
                if find_details['field'] == "@message":
                    find_message = find_details['value']
            print(find_message)
    else:
        print('No findings.')
