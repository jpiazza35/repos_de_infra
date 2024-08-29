#!/usr/bin/env python3.8

# This script can be used for detection of successful AWS console user logins. It will also detect root user logins. An email 
# will be send to the user or to the DevOps team in the case of successful root user login. 
# In this example user email address is placed in the IAM user tags.

from datetime import datetime, timedelta
import boto3
from botocore.exceptions import ClientError

SES_SENDER = 'mail@example.com'     # Change it according to your needs
SES_REGION = 'eu-west-1'            # Change it according to your needs

def lambda_handler(event, context):
    
    # Set Boto3 clients
    iam_client = boto3.client('iam')
    ses_client = boto3.client('ses', region_name=SES_REGION)

    # Function for sending email notification to certain user
    def send_notification(email, ev_time, acc_name, source_ip):
        email_text = f'''
            This is an automatic notification about successful login with your credentials to Pillar's AWS {acc_name} console. 
            
            Event time: {ev_time}
            Source IP address: {source_ip}
            
            If this is you, take this email as informative. If not, please contact DevOps team as soon as possible.\n

            Regards,
            DevOps Team
            '''

        try:
            ses_response = ses_client.send_email(
                Destination={'ToAddresses': [email]},
                Message={
                    'Body': {'Text': {'Charset': 'UTF-8', 'Data': email_text}},
                    'Subject': {'Charset': 'UTF-8',
                                'Data': f'You successfully logged in to AWS {acc_name} account!'}
                },
                Source=SES_SENDER
            )
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print(f'Notification email sent successfully to {email}!')

    # Function for sending email notification about Root login to devops team
    def send_notification_for_root(ev_time, acc_name, source_ip):
        root_email_text = f'''
            This is an automatic notification about successful login with the Root credentials to Pillar's AWS {acc_name} console. 

            Event time: {ev_time}
            Source IP address: {source_ip}

            Regards,
            DevOps Team
            '''

        try:
            ses_response = ses_client.send_email(
                Destination={'ToAddresses': ["devops@example.com"]},
                Message={
                    'Body': {'Text': {'Charset': 'UTF-8', 'Data': root_email_text}},
                    'Subject': {'Charset': 'UTF-8',
                                'Data': f'Root user successfully logged in to AWS {acc_name} account!!!'}
                },
                Source=SES_SENDER
            )
        except ClientError as e:
            print(e.response['Error']['Message'])
        else:
            print(f'Notification email sent successfully to devops@example.com!')

    # Function for extraction of email address from IAM user tags
    def get_email(usr_nm):
        user_tags = iam_client.list_user_tags(
            UserName=usr_nm
        )
        if user_tags['Tags']:
            for tag in user_tags['Tags']:
                if tag['Key'] == 'email':
                    return tag['Value']

    # Get status of ConsoleLogin event
    details = event['detail']
    login_status = details['responseElements']['ConsoleLogin']

    if login_status == 'Success':
        # Set account name
        account_nr = event['account']
        if str(account_nr).startswith("X"):
            account_name = "QA"
        else:
            account_name = "PROD"
        user_name = details['userIdentity']['userName']
        print(user_name)
        # Get event time
        event_time = details['eventTime']
        print(event_time)
        # Get source IP address
        sourceIP = details['sourceIPAddress']
        print(sourceIP)
        # Get type of the user
        user_type = details['userIdentity']['type']

        # Send email notification
        if user_type == "Root":
            print(user_type)
            send_notification_for_root(event_time, account_name, sourceIP)
        else:
            # Get user email address first
            try:
                email_address = get_email(user_name)
                print(email_address)
            except ClientError as e:
                print("Unknown error getting Report: " + e.message)
            # Then send notification
            send_notification(email_address, event_time, account_name, sourceIP)
                